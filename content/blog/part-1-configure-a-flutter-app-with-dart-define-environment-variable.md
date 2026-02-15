---
title: "Configure a Flutter App with dart-define environment variable Part 1: HOST_URL"
date: 2023-01-19
---

# Configure a Flutter App with dart-define environment variable Part 1: HOST_URL

Different app environments, different ways to reach them.

I will show you the dart-define method to inject the environment
variable into your app during the build phase e.g. with your flutter
CI/CD. The usage is manifold and can be used for different host urls,
different package names or even for different app-icons.

In this short post I will show you how to set your host url dynamically
and thus build a Flutter App for your Production server or for your
staging server.

## What does dart-define do in Flutter?

A Flutter App production version is built with the commands
`flutter build appbundle`. But how can we use the same command to build
e.g. a staging, integration, developmenmt or even production version?

The answer is: `--dart-define`!

With dart-define you can pass environemnt variables or parameters to the
build process which can be used in your code to build different versions
of the same app.

### env host\_url with dart-define

We want to define the env variable "HOST\_URL" as our server API url.
For this we extend the flutter build-call with the `HOST_URL` parameter:

`flutter build appbundle --dart-define="HOST_URL=https://api.thiele.dev"`

The build process completes and a .aab file appears that can be uploaded
to Google Play or even firebase app distribution and contains your API's
production url.

### Read host\_url in code

In the first step we have only passed the env variable `HOST_URL` to the
build process. Now we have to read the parameter in the code.

Open your http api file, for example, api-service.dart which calls your
API or any other file you've created for your API calls.

To be able to use the `HOST_URL` within the code there is a method
called `fromEnvironment(...)`. In our case we want to get a String which
means we can use `String.fromEnvironment(...)`:

`class ApiService { static const String HOST_URL = String.fromEnvironment("HOST_URL", defaultValue: 'https://api.int.thiele.dev'); }`

It is important that the HOST\_URL is a `static const` or `final`
otherwise no environemnt variable is found.

The default value is also set and can be used e.g. for local
development.

Here is a short overview of which values the HOST\_URL contains when
different dart-define variants are entered:

`$ flutter build appbundle // HOST_URL uses default value = "https://api.int.thiele.dev" $ flutter build appbundle --dart-define="HOST_URL=https://api.thiele.dev" // HOST_URL uses value = "https://api.thiele.dev"`

If you now make an API call and use the BASE\_URL, you can build
different app versions with different URLs. And whenever you call your
API, don't forget to use the HOST\_URL in your URL as the prefix.

`var response = await http.get("${ApiService.HOST_URL}/user")`

Continue with [Flutter dart-define Part 2: Dev and Prod Package Names &
Bundle
IDs](https://thiele.dev/blog/flutter-dart-define-part-2-dev-and-prod-package-names-and-bundle-ids/)

Have fun!
