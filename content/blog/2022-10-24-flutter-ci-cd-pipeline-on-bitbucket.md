---
title: "Flutter CI/CD Pipeline on Bitbucket"
description: How to run a Flutter CI/CD Bitbucket pipelines on each pull request or on each git version-tag.
date: 2022-10-24
slug: flutter-ci-cd-pipeline-on-bitbucket
tags: ["flutter", "bitbucket", "ci-cd"]
---


Flutter is becoming more and more popular and therefore more and more companies are using Flutter. In this post we take a look at CI/CD with Flutter on Bitbucket and develop a testing pipeline that is executed on every pull request or release. 

Let's start with the container image. Each pipeline is always executed in a defined container with a specific operating system. With Flutter, however, not only one operating system is addressed with the same code, so that you automatically have different platforms on which the CI/CD has to be executed and thus also different container images are required.

## Flutter Container Images
Android allows you to select almost all containers for the CI. Usually, a Linux system is chosen, since these images are usually very fast and require little memory. 

For iOS you need a MacOS Runner. This means that an Apple system is required to build a Flutter version in any CI/CD tool. At Bitbucket, cloud MacOS builds are not yet supported. The feature is on the Bitbucket roadmap, but since Q4 2021 it says "coming soon", initially with a release in Q1 2022 and now Q3 2022 and soon probably Q4 2022. 😫 It's possible to use your own MacOS hardware, but we're living in a world of clouds, so let's just wait patently. 

## Flutter Preinstalled Container
Fortunately, Flutter is already in wide use, so there are already containers that have Flutter pre-installed. For example there is the image [cirrusci/flutter](https://hub.docker.com/r/cirrusci/flutter/) which is regularly updated to the latest Flutter version. The basis of the container is [cirrusci/android-sdk](https://hub.docker.com/r/cirrusci/android-sdk/), which is the linux docker image docker-kvm.

## Bitbucket Pipeline File
To configure the Bitbucket pipeline, a `bitbucket-pipelines.yml` file is needed. Create the file in your root directory.

### Set the Container Image
Now define the container image. If you need e.g. the Flutter version 3.0.5 then you can specify this directly in the image version.

```yml
image: cirrusci/flutter:3.0.5
```

You can also check the [Tags on Docker Hub](https://hub.docker.com/r/cirrusci/flutter/tags) to see if your version is ready as a container. Usually it takes only 1-2 days until the latest stable version of flutter is available as a container.

### Pipelines & Steps
The basis of bitbucket pipelines is the pipelines definition. In this part you define when the pipeline should start. For example, you can make the pipeline run automatically on every pull request, every commit, every git tag or even at a certain time.

#### Trigger on Pull Request
In our example we want to run the flutter tests on every pull request:

```yml
pipelines:
  pull-requests:
    '**':
      - step:
          name: Flutter lint and test
          script:
            - flutter analyze
            - flutter test ./test
```

The pipeline trigger is a pull-request with no further limitations.
You can also specify a specific branch name for the pipeline:

```yml
pipelines:
  pull-requests:
    'feature/*':
      - step:
          name: Flutter lint and test
          script:
            - flutter pub get
            - flutter analyze
            - flutter test ./test
```

The pipeline will only run if a pull request is created and the branch name starts with `feature/`. Note: Bitbucket does not support RegExpr. Bitbucket only supports the [glob Pattern](https://support.atlassian.com/bitbucket-cloud/docs/use-glob-patterns-on-the-pipelines-yaml-file/) which is a very very limited version of regular expressions.

#### Trigger on Master/Main
Whenever you push a commit to master/main you might want to build a version which should be pushed and released to your PO.

We just create a trigger on master/main and build the version.

```yml
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

The script will fetch all dependencies, analyzes the code, run all tests and builds a new apk file.

#### Trigger on Git Tag Creation
Same as above, you can create a bitbucket pipeline which runs on any tag creation and creates a new Flutter android appbundle version.

```yml
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
```

Note: Bitbucket does only support the glob pattern and not any regExpr. Read more on the [glob pattern bitbucket descripition](https://support.atlassian.com/bitbucket-cloud/docs/use-glob-patterns-on-the-pipelines-yaml-file/)

### Store Artifacts
Whenever you build an APK or APPBUNDLE you may want to download the file whenever the build is complete. Usually Bitbucket closes the step and removes any files that were generated during the build step. 

We need to tell bitbucket to store some files as artifacts which can then be downloaded after the build is complete (Lets reuse the git tag example).

```yml
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

Bitbucket will now save all files that are stored in the specific folder. You can also save specific files by defining specific file names: e.g. `build/app/outputs/bundle/release/app-release.aab`

It's also possible to create a folder and move any file you might want to save as an artifact.

```yml
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
          - mkdir artifacts
          - cp build/app/outputs/bundle/release/app-release.aab ./artifacts/app-bundle-version.aab
        artifacts:
          - "artifacts/*"
```

Read more about [Bitbucket Triggers here](https://support.atlassian.com/bitbucket-cloud/docs/pipeline-triggers/).

## Environment Variables

It's possible to use environment variables in your Flutter Bitbucket CI/CD project. Setup and save your environment variables like any other project in Bitbucket by creating a deployment environment. After you have everything in place, use the dart-define build command to inject your environment variables during your build phase. 

Some Notes: 
* Don't forget to set the deployment name in your build step. 
* A Bitbucket deployment can only be used in a single step for the whole pipeline!

You can use the variables in your `bitbucket-pipelines.yml` file like:

```yml
pipelines:
  tags:
    '*.*.*':
      - step:
        name: Build a flutter appbundle
        size: 2x
        deployment: production
        script:
          - flutter pub get
          - flutter analyze
          - flutter test ./test
          - flutter build appbundle --dart-define="HOST_URL=$HOST_URL"
```

Dart-define environment variable blog series: 
* [Dart-define environment variable Part 1: HOST_URL](https://thiele.dev/blog/part-1-configure-a-flutter-app-with-dart-define-environment-variable)
* [Dart-define environment variable Part 2: Dynamic App name and Package Name/Bundle Id](https://thiele.dev/blog/flutter-dart-define-part-2-dev-and-prod-package-names-and-bundle-ids)

And become a Bitbucket pro:
* [How to speed up Bitbucket pipelines by caching libraries and build files.](https://thiele.dev/blog/flutter-bitbucket-pipeline-cache/)
