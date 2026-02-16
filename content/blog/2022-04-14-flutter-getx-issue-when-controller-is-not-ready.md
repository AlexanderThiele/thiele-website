---
title: "Flutter GetX Issue when controller is not ready"
description: "In my last project we used GetX for flutter state management. One problem we had regularly was the onInit and onReady method of the controller."
date: 2022-04-14
slug: flutter-getx-issue-when-controller-is-not-ready
---

In my last project we used GetX for flutter state management. One problem we had regularly was the onInit and onReady method of the controller.

The state management system of GetX for flutter is widely used but we had one issue all the time (or lets call it some struggleing).

The GetXControllers have the methods onInit and onReady and onReady is always executed after onInit. The problem was that the view build method was executed even though onInit of the controller was not ready yet, especially when we needed asynchronous initializations.

This regularly led to problems especially with late variables that are executed in onInit.

## Solution 1:

Create the controller null-safe i.e. initially most variables as null and behave with the UI accordingly (empty, loading state).

## Solution 2:
Create a bool observer and show a loading state while the controller is not ready.

We have also created a mixin on the GetXController:

```dart
import 'dart:async';

import 'package:get/get.dart';

mixin ReadyMixin on GetxController {
  final isControllerReady = false.obs;

  FutureOr<void> initController();

  FutureOr<void> controllerReady() {}

  @override
  void onInit() async {
    await initController();
    super.onInit();
  }

  @override
  void onReady() async {
    isControllerReady.value = true;
    await controllerReady();
    super.onReady();
  }
}
```

The controller would then be as follows:

```dart
class MyController extends GetxController with ReadyMixin {

  @override
  FutureOr<void> initController() {
    return _initSomething();
  }

}
```

and within the view:

```dart
    Obx(() {
        if (!controller.isControllerReady.value) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [CircularProgressIndicator()],
            );
        }
        return Container(child:Text("ready"));
```
