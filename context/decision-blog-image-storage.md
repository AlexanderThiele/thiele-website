# Decision: Blog Post Image Storage

## Type
Decision

## Date
2026-02-16

## Description
Established a convention for storing images associated with specific blog posts.

## Context/Reasoning
When migration images from external CDNs (like Contentful's `ctfassets.net`) to local hosting, we need a structured way to store these assets to avoid cluttering the root images directory.

## Actionable Item
Images specific to a blog post should be stored in `web/images/blog/[post-slug]/`.
For example: `web/images/blog/4-years-at-doodle/ds1.jpg`.
These are then referenced in Markdown as `/images/blog/[post-slug]/[filename]`.
