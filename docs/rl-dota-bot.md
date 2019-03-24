---
title: RL Dota Bot
has_children: false
nav_order: 15
permalink: /rl-dota-bot
---

# Reinforcement Learning (RL) Dota Bot

*Dec 2018 - Mar 2019*<br />

-----

## Introduction

The bulk of the project consists out of two big components.
The [dotaservice](https://github.com/TimZaman/dotaservice) that allows you to play Dota through
and synchronous state-action loop using gRPC, and the
[dotaclient](https://github.com/TimZaman/dotaclient) that has the code for the agents to play
through the dotaservice, and a (distributed) optimizer that trains from experience, and creates
new policies.

## Optimizer

The optimizer trains in [A3C](https://arxiv.org/pdf/1602.01783) mode, it's async, but not very
off-policy. It every time the policy is updated, it is sent to the agents immediatelly, which then
adopt it, even if they are mid-game. Advantage estimation is done through
[GAE](https://arxiv.org/abs/1506.02438), optimization using [PPO](https://arxiv.org/abs/1707.06347).
