---
title: "Flutter Bitbucket Pipeline cache"
description: Speed up your Bitbucket pipeline by caching Flutter dependencies.
date: 2022-09-19
slug: flutter-bitbucket-pipeline-cache
tags: ["flutter", "bitbucket", "ci-cd"]
---


It was pretty tricky to speed up the pipeline since there are not so many resources on how to cache your flutter app on Bitbucket Pipeline.

## How Dart/Flutter saves dependencies

Whenever you run `flutter pub get`, the system downloads all dependencies to the folder `.pub-cache` in your home directory. The Folder contains all cached dependencies and will look similar to:

`.pub-cache/hosted/pub.dartlang.org/linkfive_purchases-2.0.2/`

Caching those dependencies makes sense since a plugin with a specific version will never change. It's basically not possible to upload the same version with a different code to pub.dev.

## Dependency version changes

Whenever you change your dependencies, the new versions will appear in the same Folder.

`.pub-cache/hosted/pub.dartlang.org/linkfive_purchases-2.0.1/`
`.pub-cache/hosted/pub.dartlang.org/linkfive_purchases-2.0.2/`

## Alright. Let's cache the dependencies with bitbucket pipelines

### bitbucket-pipelines.yml config definitions

We want all dependencies to be cached in the `.pub-cache` folder on bitbucket. For this we define certain definitions that can be referenced in future steps.

```yaml
definitions:
  steps:
    - step: &Flutter-pub-get
        name: Flutter Pub Get
        script:
          - flutter pub get
        artifacts:
          - .dart_tool/**
          - .flutter-plugins
          - .flutter-plugins-dependencies
          - build/**
        caches:
          - dartpubcache
    - step: &Lint-and-test
        name: Flutter lint and test
        caches:
          - dartpubcache
        script:
          - flutter analyze
          - flutter test ./test
  caches:
    dartpubcache: $HOME/.pub-cache
```

We define the steps `Flutter-pub-get` and `Lint-and-test` plus the cache directory `$HOME/.pub-cache`. Now we just need to use the steps in any pipeline runner.

```yaml
pipelines:
  pull-requests:
    '**':
      - step: *Flutter-pub-get
      - step: *Lint-and-test
      - step:
          name: Build Flutter Android appbundle
          deployment: production
          caches:
            - dartpubcache
          script:
            - flutter build appbundle
```

And Bitbucket also notes that the cache was downloaded:

```yaml
Cache "dartpubcache": Downloading
Cache "dartpubcache": Downloaded 40.6 MiB in 2 seconds
Cache "dartpubcache": Extracting
Cache "dartpubcache": Extracted in 1 seconds
```

### Cache duration

The bitbucket cache will refreshed after a week. You can also delete the cache manually inside the bitbucket pipeline section. Click on the top right Cache button.

### Flutter dependency update

It also does not cause any problems if you change your dependencies before the cache has expired. The only thing that happens is that the command `flutter pub get` takes a little longer because additional dependencies are downloaded.
