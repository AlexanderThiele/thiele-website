---
title: "Modularization of Flutter Apps with Packages for Growing Teams"
date: 2023-01-19
---


Modularizing the app with packages is a good way to make the code more
maintainable and get the code ready for a growing team.

## What are Flutter Packages?

When you create a Flutter app, the app has no dependencies. However, if
you integrate a plugin or package from pub.dev, then you are using a
flutter package created by other developers.

Each Flutter package can also have other dependencies, but can also work
without any other dependencies. A package is independent and does not
know in which app it is integrated, i.e. it has no access to everything
that happens outside the package.

But not every flutter package has to exist on pub.dev. It is also
possible to let a flutter package exist only locally on your machine or
in a github repository.

In our example we only work with local packages which is also called a
monorepo.

## Local sub-packages

When you create a new Flutter app, you will get a project structure like
this:

`. ├── android # Android App ├── integration_test ├── ios # iOS App ├── lib # Flutter App Code │ └── main.dart ├── test └── pubspec.yaml`

The entire app code is stored in the `lib` folder. Now, as you develop
your app and the team grows, the `lib` folder gets bigger and bigger.

At some point, you need to consider how your growing team can work
together to avoid constantly getting into the next merge conflict.

A good way is to divide the project into different sub-modules. A new
Flutter package is created which works independently and the original
app can access it.

With a monorepo there is no big overhead and your team can still work
with a single git project. This is also how Google structure its
products, there is a monorepo for all google products. It's called the
one-version rule and means that all dependencies always use the latest
version.

### Proejct Structure of local sub-packages sub-plugins

If you want to create a new flutter package in the same repo as your
app, then create the folder `packages` which will contain all
sub-packages. All new packages and plugins would then be created in this
folder.

This is how it looks like:

`. ├── android # Android App ├── integration_test ├── ios # iOS App ├── lib # Flutter App Code │ └── main.dart ├── packages # All Sub-Packages │ └── linkfive_ui │ ├── android │ ├── example │ │ └── main.dart │ ├── ios │ ├── lib │ │ └── linkfive_ui.dart │ ├── test │ └── pubspec.yaml │ └── linkfive_analytics │ ├── lib │ │ └── linkfive_analytics.dart │ ├── test │ └── pubspec.yaml ├── test └── pubspec.yaml`

The packages folder would contain, for example, a UI components library
or the analytics-tracking code for Flutter.

It is not necessary to create an android or iOS folder in the
sub-packages. However, it is recommended because the package can be
tested independently without starting your main project. In addition, a
flutter native bridge can also be created in a sub-package.

### Include the package in your main app

The sub-packages are included by simply specifying the package as a
dependency in our main pubspec.yaml file.

`name: app version: 1.0.0+1 environment: sdk: ">=2.18.2 <3.0.0" flutter: ">=3.3.6" dependencies: flutter: sdk: flutter linkfive_ui: path: packages/linkfive_ui `

The package will now be included into your app whenever you run
`pub get`.

In another post, I'll go over good project abstraction options.
