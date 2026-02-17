# Jaspr link() sizes attribute

## Type
Learning

## Date
2026-02-17

## Description
The `link()` function in `package:jaspr/dom.dart` (version 0.22.2) does not support a named parameter `sizes`.

## Context/Reasoning
When adding favicons or apple-touch-icons that require the `sizes` attribute, passing `sizes: '32x32'` to `link()` results in a compilation error.

## Actionable Item
Always use the `attributes` parameter to specify `sizes` for `link()` tags:
`link(rel: 'icon', href: '...', attributes: {'sizes': '32x32'})`
