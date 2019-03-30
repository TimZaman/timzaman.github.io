#include "TinyGPS.h"
#include <stdio.h>
#include <util/crc16.h>
#include <Flash.h>
#include <Wire.h>
#include <TMP102.h>
#include <CN3063.h>
#include <SdFat.h> //Eats ~8kb

#define ENDLN           "\r\n"  // SD

TinyGPS gps;

int count = 0;
byte navmode = 0;
float flat=0, flon=0;
unsigned long date, time, chars, age;

int hour = 0 , minute = 0 , second = 0, oldsecond = 0;
char latbuf[12] = "0", lonbuf[12] = "0";
long int ialt = 0;
long int maxAlt=0;
int numbersats = 0;

int batmv=0;
int temp=0;

int descent=0;
int ascent=0;
int ExecOnce=0;   

//Camerapins
int pinpolasnap=5;
long int imagealt=0;
long int imagestaken=0;

unsigned long time_ascent=0;
unsigned long time_snapshot=0;
unsigned long time_turnon=0;

int execonceALT=0;

//SD
Sd2Card card;
SdVolume volume;
SdFile root;
SdFile file;

// RTTY Functions 

void rtty_txstring (char * string)
{

	char c;
	c = *string++;
	while ( c != '\0')
	{
		rtty_txbyte (c);
		c = *string++;
	}
  delay(50);
}

void rtty_txbyte (char c)
{

	int i;
	rtty_txbit (0); // Start bit
	// Send bits for for char LSB first	
	for (i=0;i<7;i++) //7 or 8 bit ascii
	{
		if (c & 1) rtty_txbit(1); 
			else rtty_txbit(0);	
		c = c >> 1;
	}
	rtty_txbit (1); // Stop bit
        rtty_txbit (1); // Stop bit
}

void rtty_txbit (int bit)
{
		if (bit)
		{
		  // high
                    digitalWrite(3, LOW);
		}
		else
		{
		  // low
                    digitalWrite(3, HIGH);
		}

                //delay(10);
                //delayMicroseconds(19500); // 10000 = 100 BAUD 20150
                delayMicroseconds(19800); // 10000 = 100 BAUD 20150
}

uint16_t gps_CRC16_checksum (char *string)
{
	size_t i;
	uint16_t crc;
	uint8_t c;
 
	crc = 0xFFFF;
 
	// Calculate checksum ignoring the first two $s
	for (i = 2; i < strlen(string); i++)
	{
		c = string[i];
		crc = _crc_xmodem_update (crc, c);
	}
 
	return crc;
}
  
// Send a byte array of UBX protocol to the GPS
void sendUBX(uint8_t *MSG, uint8_t len) {
  for(int i=0; i<len; i++) {
    Serial.print(MSG[i], BYTE);
  }
}
  
  
// Calculate expected UBX ACK packet and parse UBX response from GPS
boolean getUBX_ACK(uint8_t *MSG) {
	uint8_t b;
	uint8_t ackByteID = 0;
	uint8_t ackPacket[10];
        Serial.flush();
	unsigned long startTime = millis();
 
	// Construct the expected ACK packet    
	ackPacket[0] = 0xB5;	// header
	ackPacket[1] = 0x62;	// header
	ackPacket[2] = 0x05;	// class
	ackPacket[3] = 0x01;	// id
	ackPacket[4] = 0x02;	// length
	ackPacket[5] = 0x00;
	ackPacket[6] = MSG[2];	// ACK class
	ackPacket[7] = MSG[3];	// ACK id
	ackPacket[8] = 0;		// CK_A
	ackPacket[9] = 0;		// CK_B
 
	// Calculate the checksums
	for (uint8_t i=2; i<8; i++) {
		ackPacket[8] = ackPacket[8] + ackPacket[i];
		ackPacket[9] = ackPacket[9] + ackPacket[8];
	}
 
	while (1) {
 
		// Test for success
		if (ackByteID > 9) {
				// All packets in order!
                                navmode = 1;
				return true;
		}
 
		// Timeout if no valid response in 3 seconds
		if (millis() - startTime > 3000) { 
                        navmode = 0;
			return false;
		}
 
		// Make sure data is available to read
		if (Serial.available()) {
			b = Serial.read();

			// Check that bytes arrive in sequence as per expected ACK packet
			if (b == ackPacket[ackByteID]) { 
				ackByteID++;
                                //Serial.print(ackPacket[ackByteID], HEX);
                                //Serial.print(" ");
			} else {
				ackByteID = 0;	// Reset and look again, invalid order
			}
 
		}
	}
}

//Function to poll the NAV5 status of a Ublox GPS module (5/6)
//Sends a UBX command (requires the function sendUBX()) and waits 3 seconds
// for a reply from the module. It then isolates the byte which contains 
// the information regarding the NAV5 mode,
// 0 = Pedestrian mode (default, will not work above 12km)
// 6 = Airborne 1G (works up to 50km altitude)
//Adapted by jcoxon from getUBX_ACK() from the example code on UKHAS wiki
// http://wiki.ukhas.org.uk/guides:falcom_fsa03
boolean checkNAV(){
  uint8_t b, bytePos = 0;
  uint8_t getNAV5[] = { 0xB5, 0x62, 0x06, 0x24, 0x00, 0x00, 0x2A, 0x84 }; //Poll NAV5 status
  
  Serial.flush();
  unsigned long startTime = millis();
  sendUBX(getNAV5, sizeof(getNAV5)/sizeof(uint8_t));
  
  while (1) {
    // Make sure data is available to read
    if (Serial.available()) {
      b = Serial.read();
      
      if(bytePos == 8){
        navmode = b;
        return true;
      }
                        
      bytePos++;
    }
    // Timeout if no valid response in 3 seconds
    if (millis() - startTime > 3000) {
      navmode = 0;
      return false;
    }
  }
}

void setupGPS() {
  //Turning off all GPS NMEA strings apart on the uBlox module
  Serial.println("$PUBX,40,GLL,0,0,0,0*5C");
  Serial.println("$PUBX,40,GGA,0,0,0,0*5A");
  Serial.println("$PUBX,40,GSA,0,0,0,0*4E");
  Serial.println("$PUBX,40,RMC,0,0,0,0*47");
  Serial.println("$PUBX,40,GSV,0,0,0,0*59");
  Serial.println("$PUBX,40,VTG,0,0,0,0*5E");;
  
  delay(3000); // Wait for the GPS to process all the previous commands
  
 // Check and set the navigation mode (Airborne, 1G)
  uint8_t setNav[] = {0xB5, 0x62, 0x06, 0x24, 0x24, 0x00, 0xFF, 0xFF, 0x06, 0x03, 0x00, 0x00, 0x00, 0x00, 0x10, 0x27, 0x00, 0x00, 0x05, 0x00, 0xFA, 0x00, 0xFA, 0x00, 0x64, 0x00, 0x2C, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x16, 0xDC};
  sendUBX(setNav, sizeof(setNav)/sizeof(uint8_t));
  
  getUBX_ACK(setNav);
  delay(500);
}

// Sensor-stuff

int gettemp(){
  int t;
  TMP102.getValues(&t);
  return t;
}

int getbat(){
  int bat_volt;
  CN3063.getBatVolt(&bat_volt); //in mV
  return bat_volt;
}


// ----- Polaroid 635 Supercolor

void polaroidsnap(){
 file << F("Polarizing Space!") << ENDLN;
 rtty_txstring("! POLARIZING SPACE !");
 digitalWrite(pinpolasnap,HIGH);
 delay(800);
 digitalWrite(pinpolasnap,LOW);
 delay(3000);
 imagestaken++;
 imagealt=ialt;
}



/*Setup and Main*/


void setup()
{
  pinMode(3, OUTPUT); //Radio Tx
  Serial.begin(9600);
  
  pinMode(pinpolasnap, OUTPUT);
  
  
  
  CN3063.attach_ana(7);
  TMP102.init();
  delay(5000); // We have to wait for a bit for the GPS to boot otherwise the commands get missed
  setupGPS();
  
  //SD
  if (!card.init()) Serial << F("* SD card init. failed!") << ENDLN;
  if (!volume.init(&card)) Serial << F("* volume init. failed!") << ENDLN;
  if (!root.openRoot(&volume)) Serial << F("* openRoot failed") << ENDLN;
  
  // Check for an available filename
  char fileName[13];
  Serial << F("* Opening log file...") << ENDLN;
  for (int i = 0; i < 1000; i++) {
    sprintf(fileName, "SCLOG%03d.TXT", i);
    if (file.open(&root, fileName, O_CREAT | O_EXCL | O_WRITE)) break;
  }

  // Ensure we opened the file without error
  if (!file.isOpen()) {
    Serial << F("* Failed to open log file!") << ENDLN;
  } 
  else {
    file.writeError = false;
    Serial << F("* Logging to ") << fileName << ENDLN;
    file.write("* ");
    file << F("Project SpaceCameraLive booted!") << ENDLN;
    if (file.writeError || !file.sync()){ 
      Serial << F("* Error writing to SD card!") << ENDLN;
    }/* else {
      send_sms("SD Works!"); 
    }*/
  }
  Serial << ENDLN;

}


/* Main Loop */



void loop() { 
    char superbuffer [120];
    char checksum [10];
    int n;

    if((count % 10) == 0) {
     checkNAV();
     delay(1000);
     if(navmode != 6){
       setupGPS();
       delay(1000);
     }
     checkNAV();
     delay(1000);
   }
    temp=gettemp();
    batmv=getbat();
  
    Serial.println("$PUBX,00*33"); //Poll GPS
   
    while (Serial.available())
    {
      int c = Serial.read();
      if (gps.encode(c))
      {
        //Get Data from GPS library
        //Get Time and split it
        gps.get_datetime(&date, &time, &age);
        hour = (time / 1000000);
        minute = ((time - (hour * 1000000)) / 10000);
        second = ((time - ((hour * 1000000) + (minute * 10000))));
        second = second / 100;
      }
    }
      
    numbersats = gps.sats();
       
    if (numbersats >= 1) {
      
      //Get Position
      gps.f_get_position(&flat, &flon);
  
      //convert float to string
      dtostrf(flat, 7, 4, latbuf);
      dtostrf(flon, 7, 4, lonbuf);
      
      //just check that we are putting a space at the front of lonbuf
      if(lonbuf[0] == ' ')
      {
        lonbuf[0] = '+';
      }
      
      // +/- altitude in meters
      ialt = (gps.altitude() / 100);    
    }
    
    n=sprintf (superbuffer, "$$PD4TA,%d,%02d:%02d:%02d,%s,%s,%ld,%d,%d,%d", count, hour, minute, second, latbuf, lonbuf, ialt, numbersats, temp, batmv);
    if (n > -1){
      n = sprintf (superbuffer, "%s*%04X\n", superbuffer, gps_CRC16_checksum(superbuffer));
      //noInterrupts(); //DO NOT USE (No)Interrupts!
      rtty_txstring(superbuffer); //Not using RTTY on this launch in this module
      //interrupts(); //DO NOT USE (No)Interrupts!
      
    }
    
    // Keep track of the maximum altitude
    if (ialt > maxAlt) { 
      maxAlt = ialt; 
    }
    // Check to see if we've fallen 1000m, if so switch to descent mode
    if (ialt < (maxAlt - 1500)) { //If current altitude smaller than max-1.5km
      descent = 1;  //Descent mode on, ascent mode off.
      ascent = 0;
    } 
    
    // Check to see if we've risen 10km, turn on ascent mode
    if (ialt > 10000) { 
      ascent = 1; 
      if (execonceALT==0){ //Define time_ascent only once at time of first >10km
        execonceALT=1;
        time_ascent=millis();
      }
    } 
    
    if (ascent==1) { //If risen 10km
      //Wait for first picture
      if (imagestaken == 0){ //If there has been no picture taken yet
        if ( (ialt > 17000) || (time_ascent+1400000) < millis() ){
          polaroidsnap();
        }
      } else if (imagestaken <10) { //If the film is not empty yet
        if ( (ialt > (imagealt+2000)) || (time_snapshot+300000) < millis() ){
          //If the altitude is larger than the previous one +1.5km or time since last shot is 5min
          polaroidsnap();
        }
      }
    }
    
    if (descent == 1){
      if (imagestaken<20){ //On the descent make pictures until we've made 20 (just in case)
        polaroidsnap();
      }
    }
    //100 seconden wachten is 0.5km


        
    count++;
    
    //Serial << superbuffer << ENDLN;
    file << superbuffer << ENDLN;
    file.sync(); //Force update SD
    delay(300); //give some rest
}
