---
title: "Flutter Tablet App that detects Stylus (Apple Pencil, Samsung Pen) & the Limits of Riverpod (Open Source App)"
date: 2023-01-11
slug: flutter-tablet-app-that-detects-stylus-apple-pencil-samsung-pen-open-source-app
---


I recently got a tablet including a pen, and I was looking for a
calendar App where you can draw, no typing. No Luck.

I was confident that Flutter can somehow distinguish between a finger
and a pen, so I started the App with Flutter myself.

## Tech Specs

- Code in Dart only
- State Management: Riverpod
- Database: Firebase, Firestore

## Recognize the Stylus

The Listener-Widget detects raw-touch events and can recognize the use
of a pen instead of a finger. Also, for each touch event you get a touch
ID with which you can distinguish each finger. For example, if you move
3 fingers, you will get 3 touch events in a row but each event from each
finger will always have the same touch id. This allows you to track
exactly which finger makes which movement. The touch event also gives
you the information if it is a stylus event or a normal touch event and
if you just want to use the stylus event, just ignore everything that is
not a stylus.

`Listener( onPointerMove: (event) { onPointerMove(event, setState); }, onPointerUp: (event) { onPointerUp(event, setState); }, child: Container(...) )`

## Scaling and Zooming the Calendar Widget with 2 fingers

I ended up using the InteractiveViewer widget to pinch-zoom with two
fingers, which works pretty well, but it still limits the desired
behavior.

- Example: If you turn off drawing with your fingers and draw only with
  the pen, you should be able to scroll through the calendar with one
  finger. This does not work with the InteractiveViewer since the
  Listener catches the one-finger touch event instead of the
  InteractiveViewer

## Most interesting: The Limits of Riverpod

Whenever you draw on the calendar, the Listener-Widget detects the exact
position to draw a colorful point. This Listener-Event triggers a few
hundred times per second, and I saved the exact position inside a
Riverpod StateNotifier. Another widget is listening on that state and
paints the colorful point. First: it worked, but the update mechanism
was just too slow. The drawing was painted on the screen too late and it
looked super laggy.

I solved this issue with a classic Flutter StatefulWidget and the
setState(...) method. Please try it out, it works pretty well. Will
potentially write a more detailed article on my [Flutter
Blog](https://thiele.dev) soon.

# Links

[Github Open Source
App](https://github.com/AlexanderThiele/stift_flutter_app)

[Google Play
Store](https://play.google.com/store/apps/details?id=app.tnx.tabletcalendar)

[Apple App
Store](https://apps.apple.com/us/app/stift-calendar-for-tablet-pen/id1661094074)

​

I would also be very happy if you could leave a rating in the App Store.
This would really help to make the app a bit more popular. Thanks a lot!
🤝
