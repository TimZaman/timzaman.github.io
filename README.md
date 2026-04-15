# timzaman.com

Personal site built with Jekyll and the Just the Docs theme.

## Local development

This site targets Ruby 3.3 and Jekyll 4.

```bash
bundle install
bundle exec jekyll serve
```

Preview the site at `http://127.0.0.1:4000`.

## Deployment

GitHub Pages is deployed through the workflow at `.github/workflows/pages.yml`.

In the repository settings on GitHub:

1. Open `Settings` > `Pages`.
2. Set `Build and deployment` > `Source` to `GitHub Actions`.
