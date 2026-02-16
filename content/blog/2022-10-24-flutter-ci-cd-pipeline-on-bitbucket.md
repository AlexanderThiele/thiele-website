---
title: "Flutter CI/CD Pipeline on Bitbucket"
description: A look at CI/CD with Flutter on Bitbucket and developing a testing pipeline.
date: 2022-10-24
slug: flutter-ci-cd-pipeline-on-bitbucket
tags: ["flutter", "bitbucket", "ci-cd"]
---


Flutter is becoming more and more popular and therefore more and more companies are using Flutter. In this post we take a look at CI/CD with Flutter on Bitbucket and develop a testing pipeline that is executed on every pull request or release.

## Flutter Container Images

Android allows you to select almost all containers for the CI. Usually, a Linux system is chosen, since these images are usually very fast and require little memory.

For iOS you need a MacOS Runner. At Bitbucket, cloud MacOS builds are not yet supported. Fortunately, there are already containers that have Flutter pre-installed, like `cirrusci/flutter`.

## Bitbucket Pipeline File

To configure the Bitbucket pipeline, a `bitbucket-pipelines.yml` file is needed.

### Set the Container Image

```yaml
image: cirrusci/flutter:3.0.5
```

### Trigger on Pull Request

```yaml
pipelines:
  pull-requests:
    '**':
      - step:
          name: Flutter lint and test
          script:
            - flutter analyze
            - flutter test ./test
```

### Trigger on Master/Main

```yaml
pipelines:
  branches:
    master:
      - step:
          name: Build a flutter version
          size: 2x
          script:
            - flutter pub get
            - flutter analyze
            - flutter test ./test
            - flutter build apk
```

### Trigger on Git Tag Creation

```yaml
pipelines:
  tags:
    '*.*.*':
      - step:
          name: Build a flutter appbundle
          size: 2x
          script:
            - flutter pub get
            - flutter analyze
            - flutter test ./test
            - flutter build appbundle
          artifacts:
            - "build/app/outputs/bundle/release/*"
```

## Environment Variables

Use the `dart-define` build command to inject your environment variables during your build phase.

```yaml
- step:
    name: Build a flutter appbundle
    deployment: production
    script:
      - flutter build appbundle --dart-define="HOST_URL=$HOST_URL"
```
