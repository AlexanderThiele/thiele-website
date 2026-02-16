---
title: "Flutter CI/CD on Github actions without fastlane"
description: You don't need fastlane for a flutter release. Just use the command flutter release ipa to build and release your Flutter app.
date: 2024-11-25
slug: flutter-ci-cd-on-github-actions-without-fastlane
tags: ["flutter", "github-actions", "ci-cd"]
---


You don't need fastlane for a flutter release. Just use the command `flutter build ipa` to build and release your Flutter app to the apple app store or google play store. How? It is actually very simple. There are just a few steps you need to consider:

1. Use the macOS runner and install your Apple certificate and provisioning profile.
2. Install Flutter
3. Build your Flutter IPA file
4. Upload to appstoreconnect

## Install Apple Certificates

The magic lies in how you install the apple certificates. This is the build step of the Github action that saves my created Apple certificates to keychain.

```yaml
- name: Install apple certificate and provisioning profile
  env:
    BUILD_CERTIFICATE_BASE64: ${{ secrets.CERTIFICATES_P12 }}
    P12_PASSWORD: ${{ secrets.CERTIFICATE_PASSWORD }}
    BUILD_PROVISION_PROFILE_BASE64: ${{ secrets.PROVISIONING_PROFILE }}
    KEYCHAIN_PASSWORD: ${{ secrets.APPLE_APP_PASS }}
  run: |
    # create variables
    CERTIFICATE_PATH=$RUNNER_TEMP/build_certificate.p12
    PP_PATH=$RUNNER_TEMP/build_pp.mobileprovision
    KEYCHAIN_PATH=$RUNNER_TEMP/app-signing.keychain-db

    # import certificate and provisioning profile from secrets
    echo -n "$BUILD_CERTIFICATE_BASE64" | base64 --decode -o $CERTIFICATE_PATH
    echo -n "$BUILD_PROVISION_PROFILE_BASE64" | base64 --decode -o $PP_PATH

    # create temporary keychain
    security create-keychain -p "$KEYCHAIN_PASSWORD" $KEYCHAIN_PATH
    security set-keychain-settings -lut 21600 $KEYCHAIN_PATH
    security unlock-keychain -p "$KEYCHAIN_PASSWORD" $KEYCHAIN_PATH

    # import certificate to keychain
    security import $CERTIFICATE_PATH -P "$P12_PASSWORD" -A -t cert -f pkcs12 -k $KEYCHAIN_PATH
    security set-key-partition-list -S apple-tool:,apple: -k "$KEYCHAIN_PASSWORD" $KEYCHAIN_PATH
    security list-keychain -d user -s $KEYCHAIN_PATH

    # apply provisioning profile
    mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
    cp $PP_PATH ~/Library/MobileDevice/Provisioning\ Profiles
```

The Github Action is now ready to build a flutter app with your own signings.

## Install Flutter

We still need to install flutter, but that's easy.

```yaml
- name: Install Flutter
  uses: subosito/flutter-action@v2
  with:
    channel: 'stable'
    flutter-version-file: pubspec.yaml
    cache: true
```

## Build your ipa

And finally build your release ipa including env-dart-define-file, your build number & build name

```yaml
- name: Building IPA
  run: |
    flutter build ipa --release 
      --export-options-plist=ios/Runner/ExportOptions.plist 
      --dart-define-from-file=env.staging.json 
      --build-number $BUILD_NUMBER 
      --build-name ${{ github.event.inputs.app_version }}
```
