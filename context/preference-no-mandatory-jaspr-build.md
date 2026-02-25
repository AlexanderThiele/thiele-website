# No Mandatory Jaspr Build

## Type
Preference

## Date
2026-02-25

## Description
The user has requested the removal of the mandatory `jaspr build` requirement and the "No-Shortcut Policy" from the Jaspr skill instructions.

## Context/Reasoning
The mandatory build step was previously required after every code change to ensure no regressions. The user wants to simplify the workflow and remove this strict requirement.

## Actionable Item
Do not automatically run `jaspr build` or enforce a "No-Shortcut Policy" for Jaspr-related changes unless specifically asked or if it's necessary for a specific verification step.
