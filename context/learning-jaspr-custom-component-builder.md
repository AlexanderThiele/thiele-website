# Learning: CustomComponent Builder Signature in jaspr_content

## Type
Learning

## Date
2026-02-15

## Description
Identified the correct signature for the `builder` function in `jaspr_content`'s `CustomComponent`.

## Context/Reasoning
Initially, I misaligned the arguments in the `CustomComponent` builder, thinking the attributes were the third argument. This caused a build error when trying to access attributes as a map. Through investigation (and a failed `query-docs` call followed by a web search), I found that the signature is `(String name, Map<String, String> attributes, Component? child)`.

## Actionable Item
When using `CustomComponent` in `jaspr_content`, always use the second parameter to access attributes passed from the Markdown tag. The signature is `(name, attributes, child)`.
