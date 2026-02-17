# GitHub Workflow for Netlify Deployment

## Type
Decision

## Date
2026-02-17

## Description
Added a GitHub Actions workflow to automatically build the Jaspr site using the official Dart Docker image and deploy it to Netlify.

## Context/Reasoning
The user wanted to automate the deployment process to Netlify. Since Jaspr is a Dart framework, using the official `dart:stable` image ensures a consistent build environment. The workflow uses `nwtgck/actions-netlify` for the actual deployment.

## Actionable Item
- Ensure `NETLIFY_AUTH_TOKEN` and `NETLIFY_SITE_ID` are set as repository secrets in GitHub.
- Any changes pushed to the `main` branch will trigger a redeploy.
