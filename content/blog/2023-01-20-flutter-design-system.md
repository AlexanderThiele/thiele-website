---
title: "Flutter Design System"
date: 2023-01-20
slug: flutter-design-system
---


Many may even know the term "design system". The idea behind the design
system is that all components should look the same and that changes have
an effect all over the app. This is where the collaboration of your
UI/UX team and your app team plays a big role. Ideally, your UI/UX team
should have one or more UI pages where all components can be easily
viewed. This page should also exist in your Flutter project. Of course
we don't want to show the page to the end customer so you can easily
outsource the UI page in a Flutter UI module. You can read about how to
create other Flutter modules in the post [Modularization of Flutter Apps
with
Packages](https://thiele.dev/blog/modularization-of-flutter-apps-with-packages-for-growing-teams/).
The outsourced module can contain an example folder that you can run
independently from other Modules.

## Design System Components

The design system starts from the smallest elements and grows larger and
larger until whole pages are created. The components are Atoms,
Melecules, Organisms, Templates and Pages.

### Atoms

The smallest elements are no longer subdivisible and are called atoms.
An example of atoms are your text labels (`Text()`), buttons and input
fields.

### Molecules

Molecules follow atoms and connect atoms to each other. An example would
be a Row of an Input field next to a Button.

### Organisms

Organisms are a mixture of molecules and/or atoms. An example of an
organism is an app bar that contains a search box with a button.

### Templates

Templates are, a mixture of Organisms which represents a complete page.
The content is still a demo or empty content and should just give an
order to all ui components.

### Pages

A page includes a Template and adds content to the template.

## Flutter Design System Project Structure

We create the design system in a sub-module. Therefore, the folder
structure will look like this:

`. ├── lib # Flutter App Code │ └── main.dart ├── packages # All Sub-Packages │ └── design_system # Design System Plugin │ ├── android │ ├── example │ │ └── main.dart # Display your components │ ├── ios │ ├── lib │ │ ├── atoms │ │ ├── molecules │ │ ├── organisms │ │ ├── theme │ │ └── design_system.dart │ └── pubspec.yaml └── pubspec.yaml`

it's also nice to have an export of all atoms in a single file so you
might want to create a `all_atoms.dart` file which exports all atoms.

`export 'package:design_system/atoms/side_menu_button.dart'; export 'package:design_system/atoms/side_menu_button_small.dart';`

## Flutter Theme inside design\_system Module

Since all UI components exist in the design\_system module, the AppTheme
should also be in the same project, otherwise all UI components will not
have the correct colors and borders that exist in the final app.

Therefore we create the file `light_theme.dart` inside the `theme`
folder and set our app colors.

`import 'package:flutter/material.dart'; final ThemeData lightTheme = ThemeData( colorScheme: const ColorScheme( brightness: Brightness.light, primary: Color(0xFFCDF77E), onPrimary: Color(0xFFF77E65), secondary: Color(0xFF88966A), onSecondary: Color(0xFFFFFFFF), error: Colors.red, onError: Colors.white, background: Color(0xFFFAFEF2), onBackground: Colors.black, surface: Color(0xFFFAFEF2), onSurface: Colors.black), scaffoldBackgroundColor: const Color(0xFFFAFEF2), backgroundColor: const Color(0xFFFAFEF2), toggleableActiveColor: const Color(0xFFF77E65), floatingActionButtonTheme: const FloatingActionButtonThemeData( backgroundColor: Color(0xFFCDF77E), foregroundColor: Colors.black, focusColor: Colors.red), brightness: Brightness.light, textTheme: const TextTheme(bodySmall: TextStyle(color: Colors.black)));`

You may have noticed that we have named the file light\_theme since we
can also create a `dark_theme.dart` accordingly.

## Flutter Design System Atoms

As described before, atoms are the smallest possible UI components. An
example would be a button and therefore create the file
`side_menu_button.dart` inside the `atoms` folder.

`import 'package:flutter/material.dart'; class SideMenuButton extends StatelessWidget { final Function()? onTap; final IconData iconData; const SideMenuButton({Key? key, required this.onTap, required this.iconData}) : super(key: key); @override Widget build(BuildContext context) { return ElevatedButton( clipBehavior: Clip.hardEdge, style: ElevatedButton.styleFrom( minimumSize: const Size.square(42), padding: EdgeInsets.zero, side: BorderSide( width: 1, color: Theme.of(context).colorScheme.secondary)), onPressed: onTap, child: Center( child: Icon(iconData, size: 20, color: Theme.of(context) .floatingActionButtonTheme .foregroundColor))); } }`

The click event is set via the constructor as well as the desired icon.
We also use the colors of the theme which is set by the context.

Note: You might want to create a different file for each atom.

## Design System in a real Flutter project

We all know that in theory everything sounds nice, but in reality it is
different. I think the whole system with Atoms, Molecules, Organisms,
Templates and Pages is great, but it brings a lot of complexity.

Therefore, do not start immediately with all design system components.
In my projects I get along quite well with Atoms, Molecules and
Organisms.

In your Flutter Design System Module should therefore exist at least all
Atoms and Molecules which will be constantly refreshed with your UI/UX
team. If and how far you include your Organisms, Templates and Pages in
your UI library is up to you and your team.
