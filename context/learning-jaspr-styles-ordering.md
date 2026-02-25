# Jaspr Styles Ordering

## Type
Learning

## Date
2026-02-25

## Description
The `jaspr_lints` package enforces a specific order for CSS properties in `.styles()` calls. Properties should be grouped and then sorted.

## Context/Reasoning
When running `dart analyze`, many "info" messages were reported regarding `styles_ordering`. This rule is part of the `jaspr_lints` plugin.

## Actionable Item
Order CSS properties in the following groups:
1.  **Positioning** (`position`, `top`, `bottom`, `left`, `right`, `zIndex`)
2.  **Box Model** (`display`, `flex`, `margin`, `padding`, `width`, `height`, `maxWidth`, `minHeight`, `overflow`)
3.  **Typography** (`fontSize`, `fontWeight`, `color`, `textAlign`, `lineHeight`, `letterSpacing`)
4.  **Visuals** (`backgroundColor`, `border`, `radius`, `boxShadow`)
5.  **Misc** (`raw`, `cursor`, `transition`)

Within each group, maintain alphabetical order.
