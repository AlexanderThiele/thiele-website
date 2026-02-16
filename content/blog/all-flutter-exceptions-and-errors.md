---
title: "All Flutter Exceptions & Errors"
description: The difference between using either an exception or an error is the type of error.
date: 2022-08-03
tags: ["flutter", "dart"]
---


The difference between using either an exception or an error is the type of error. An exception is an error thrown by the user when something is not working properly and you want to send information between the call stack. An error is a non-expected error that should have been fixed before.

## Flutter Exceptions

An Exception is meant to inform the user of an error so that the error can be fixed programmatically. It is meant to be caught and should contain useful data fields.

There are only 3 Exceptions available in Flutter:
* Exception
* FormatException
* IntegerDivisionByZeroException

## Flutter Errors

Error objects are thrown in an event of a program failure. An `Error` object represents a programme error that the programmer should have avoided.

Examples are calling a function with invalid arguments or even with the wrong number of arguments or calling it at a time when this is not allowed.

These are not errors that a caller should expect or catch. If they occur, the programme is faulty and aborting the programme may be the safest response.

Here are all Flutter error classes:
* Error
* AssertionError
* TypeError
* CastError
* NullThrownError
* ArgumentError
* RangeError
* IndexError
* FallThroughError
* AbstractClassInstantiationError
* NoSuchMethodError
* UnsupportedError
* UnimplementedError
* StateError
* ConcurrentModificationError
* OutOfMemoryError
* StackOverflowError
* CyclicInitializationError
