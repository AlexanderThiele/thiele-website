# Learning: Hero Image Generation Command

## Type
Learning

## Date
2026-03-06

## Description
Created a new Gemini CLI command `create-hero-image.toml` to automate the generation of blog post hero images using the `creating-images` skill.

## Context/Reasoning
The user wanted a standardized way to generate hero images for new blog posts. By creating a command, we ensure consistency in style (gradients, typography, layout) and automate the manual steps of SVG generation, PNG conversion (`qlmanage`), and cropping (`sips`).

## Actionable Item
Use the `create-hero-image` command with a blog post slug to automatically generate a matching hero image in `web/images/hero/[slug].png`.
