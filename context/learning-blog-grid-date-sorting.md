# Blog Grid Date Sorting

## Type
Learning

## Date
2026-02-19

## Description
Ensured that the blog grid sorts posts correctly by date using a `DateTime` object instead of a formatted date string.

## Context/Reasoning
The previous implementation sorted by the formatted date string (`dd.MM.YYYY`), which resulted in incorrect lexicographical sorting (e.g., "01.01.2023" coming after "09.04.2022" because "01" < "09"). By adding a `rawDate` field of type `DateTime` to the `_PostData` class and using it for sorting, the chronological order is now correctly maintained.

## Actionable Item
Always use `DateTime` objects or raw `YYYY-MM-DD` strings for sorting dates lexicographically. Avoid sorting by formatted display strings.
