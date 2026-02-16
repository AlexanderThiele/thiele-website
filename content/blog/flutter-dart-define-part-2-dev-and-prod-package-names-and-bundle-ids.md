---
title: "Flutter dart-define Part 2: Dev and Prod Package Names & Bundle IDs"
date: 2022-10-24
---


The [first
part](https://thiele.dev/blog/part-1-configure-a-flutter-app-with-dart-define-environment-variable)
of the dart-define series was about the HOST\_URL. By using the
HOST\_URL we could inject a string parameter during the build process
and thus build different apps with different API urls.

The second part is all about changing the package name for android and
the bundle id for iOS using the dart-define command.

In my app projects I usually have a local dev version, a staging version
and a production version. The dev version is only used for local
development and has for example the package name `io.linkfive.dev`. The
staging version is the first version given to the first testers like the
PO or to other team members. The staging version also uses the staging
api and has the package name `io.linkfive.staging`. The production
version uses the production api and has the package name `io.linkfive`.

In short:

- io.linkfive.dev with local or staging server api
- io.linkfive.staging with the staging api
- io.linkfive with the production api

## Advantage of different package names and bundle IDs?

Different package names or bundle IDs mean different apps that do not
replace each other if installed by the local machine or using TestFlight
or Firebase App Distribution. You can basically install multiple apps at
the same time if they have a different package name/bundle id.

If we now build the same app with `io.linkfive` and
`io.linkfive.staging`, we can install the same app multiple times. This
is of advantage if you own staging api and the product owner wants to
start testing the app or also compare the current production app verison
with the staging app. In addition, the production app will not be
regularly broken due to different APIs, user accounts and test data.

## Use dart-define to change the package name or bundle id

The package name is stored in the gradle build file for android and in
the project.pbxproj file for ios.

Now, how can we change the package name depending on which dart-define
variable we use? The answer is actually easier than you might think.

Another overview of all app versions:

- Development `io.linkfive.dev`
- Staging `io.linkfive.staging`
- Production `io.linkfive`

If you want to read how to use dart-define in your app then start by
reading [part
1](https://thiele.dev/blog/part-1-configure-a-flutter-app-with-dart-define-environment-variable).

In Dart-Define we would define the following:

`--dart-define="APP_CONFIG_ENV=staging" // oder --dart-define="APP_CONFIG_ENV=production"`

We don't define an extra dart-define parameter for development.

### Gradle Android Setup

Open the gradle android build file `android/app/build.gradle`.

first, define the default config which is used whenever you don't type
any dart-define variable. Second, insert the default config variable in
the android defaultConfig section. Set the production package name and
add the suffix from the dart-define config. After that, it should look
similar to what you see here:

`def dartEnvironmentVariables = [ APP_CONFIG_SUFFIX: '.dev', APP_CONFIG_NAME : '[DEV] LinkFive' ]; android { ... defaultConfig { applicationId "io.linkfive" applicationIdSuffix dartEnvironmentVariables.APP_CONFIG_SUFFIX resValue "string", "app_name", dartEnvironmentVariables.APP_CONFIG_NAME } }`

The app now starts app with package name `io.linkfive.dev`.

#### Inject the dart-define variables

Let's go one step further and overwrite the default parameters with the
dart-define variable. For this you simply have to access the
`dart-defines` of the project properties:

`def dartEnvironmentVariables = [ APP_CONFIG_SUFFIX: '.dev', APP_CONFIG_ICON : '', APP_CONFIG_NAME : '[DEV] LinkFive' ]; // Inject the dart define variables if available: if (project.hasProperty('dart-defines')) { dartEnvironmentVariables = dartEnvironmentVariables + project.property('dart-defines') .split(',') .collectEntries { entry -> def pair = new String(entry.decodeBase64(), 'UTF-8').split('=') if (pair.first() == 'APP_CONFIG_ENV') { switch (pair.last()) { case 'staging': return [ APP_CONFIG_SUFFIX: ".staging", APP_CONFIG_NAME : "[STA] LinkFive" ] case 'production': return [ APP_CONFIG_SUFFIX: "", APP_CONFIG_NAME : "LinkFive" ] } } [(pair.first()): pair.last()] } println dartEnvironmentVariables } android { ... defaultConfig { applicationId "io.linkfive" applicationIdSuffix dartEnvironmentVariables.APP_CONFIG_SUFFIX resValue "string", "app_name", dartEnvironmentVariables.APP_CONFIG_NAME } }`

Now, open the Android Manifest
`android/app/src/main/AndroidManifest.xml` and use the `app_name`
variable which is set in the previous gradle build file.

`<manifest ...> <application android:label="@string/app_name" ... > ... <`

Afterwards you get the staging app with
`--dart-define="APP_CONFIG_ENV=staging"` including the staging app name.
With `--dart-define="APP_CONFIG_ENV=productionn"` the production app
including the production package name and if nothing is used, the dev
app version.

### Xcode iOS Setup

For iOS a config file must be created in the Flutter folder of the ios
project. Therefore create or open the following file
`ios/Flutter/LinkFiveConfig-default.xcconfig`.

As in the Android setup, the default settings must be created which are
used when no flutter dart-define is used.

`APP_CONFIG_SUFFIX=.dev APP_CONFIG_NAME=[DEV] LinkFive`

Now the file must be included programatically. Open the file
`ios/Flutter/Debug.xcconfig` and `ios/Flutter/Release.xcconfig` and add
the following lines at the end. Note: The file `AppConfig.xcconfig` does
not exist yet, but will be created during the build phase.

`#include "AppConfig-default.xcconfig" #include "AppConfig.xcconfig"`

Now, open the file `project.pbxproj` within the path
`ios/Runner.xcodeproj/project.pbxproj` and inject the newly created
variables. The file contains all different build schemes like Profile or
Debug. Search for the parameter `PRODUCT_BUNDLE_IDENTIFIER` and replace
the configuration with your production package name and the SUFFIX
environment variable:

`PRODUCT_BUNDLE_IDENTIFIER = "io.linkfive$(APP_CONFIG_SUFFIX)";`

Wenn die Flutter App nun gestartet wird, wird die Bundle ID
`io.linkfive.dev` initialisiert.

Now, set the App name by opening the `Info.plist` located in
`ios/Runner/Info.plist` and set the APP\_CONFIG\_NAME paramter below the
`CFBundleDisplayName` key.

` <key>CFBundleDisplayName</key> <string>$(APP_CONFIG_NAME)</string>`

#### After build script to generate the config file

The only thing missing is to overwrite the default parameters. For this
we open the iOS project with Xcode and create a new pre-build action
scheme.

![xcode pre build action scheme
1](//images.ctfassets.net/z94tijvlkhs1/3bul4iH4j7z7V5b6EN9XfZ/a08ab89779c4902c60ad68743c3c8295/Screenshot_2022-10-21_at_13.47.22.png)

From there you can press Build &gt; Pre-action and the following window
will appear

![xcode pre build action scheme
2](//images.ctfassets.net/z94tijvlkhs1/1vDAsyYZCUz7wvdi45mHDD/c7d06b4cb1b033ad2bdef932fed7053a/Screenshot_2022-10-21_at_13.49.36.png)

The pre-action is a script that is executed before each build process.
In this step we overwrite the default values. The script will look like
this:

`# Type a script or drag a script file from your workspace to insert its path. function entry_decode() { echo "${*}" | base64 --decode; } IFS=',' read -r -a define_items <<< "$DART_DEFINES" result=[] resultIndex=0 for index in "${!define_items[@]}" do if [ $(entry_decode "${define_items[$index]}") == "APP_CONFIG_ENV=staging" ]; then result[$resultIndex]="APP_CONFIG_ICON=AppIcon-staging"; resultIndex=$((resultIndex+1)) result[$resultIndex]="APP_CONFIG_SUFFIX=.staging"; resultIndex=$((resultIndex+1)) result[$resultIndex]="APP_CONFIG_NAME=[STA] LinkFive"; resultIndex=$((resultIndex+1)) fi if [ $(entry_decode "${define_items[$index]}") == "APP_CONFIG_ENV=prod" ]; then result[$resultIndex]="APP_CONFIG_ICON=AppIcon-prod"; resultIndex=$((resultIndex+1)) result[$resultIndex]="APP_CONFIG_SUFFIX="; resultIndex=$((resultIndex+1)) result[$resultIndex]="APP_CONFIG_NAME=LinkFive"; resultIndex=$((resultIndex+1)) fi done printf "%s\n" "${result[@]}"|grep '^APP_CONFIG_' > ${SRCROOT}/Flutter/AppConfig.xcconfig`

The next build will create the file `AppConfig.xcconfig`.

The bundle id and app name are now dynamic and can be changed with the
flutter dart-define command.
