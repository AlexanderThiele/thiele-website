---
title: "Load Secret Api Keys with Flutter without git file check in"
description: "Every app has some api keys or secrets that should not be checked into git. Here is how i've implemented the Keyloader for Flutter."
date: 2022-09-19
slug: load-secret-api-keys-with-flutter-without-git-file-check-in
---

## Assets Key File
First, you need to find a folder for your API keys. In this example, we will use the assets folder for our keys.

We need to specify the assets folder and file in our pubspec.yaml:

```yml
flutter:
  assets:
    - assets/apikey.json
```

### Git ignore
We also don't want to commit the file to our git repository. That‘s why we will add the file to our .gitignore file:

```sh
/assets/apikey.json
```

## Load the Key in Flutter
The content of apikey.json could be in the following format:

```json
{
  "linkfive_api_key": "TmljZSAyIG1lZXQgeW91IE1yLkhhY2tlcg="
}
```

We need to load the file in our app and wait for the result.
Let's create the Keys.dart and KeyLoader.dart classes which handles the whole loading process:

Keys data class that holds the keys:

```dart
class Keys {
  final String linkFiveApiKey;

  Keys({this.linkFiveApiKey = ""});

  factory Keys.fromJson(Map<String, dynamic> jsonMap) {
    return new Keys(linkFiveApiKey: jsonMap["linkfive_api_key"]);
  }
}
```

KeyLoader class that loads the key file:

```dart
class KeyLoader {
  final String keyPath = "assets/apikey.json";

  KeyLoader();

  Future<Keys> load(BuildContext context) async {
    String data = await DefaultAssetBundle.of(context).loadString(keyPath);
    final jsonResult = json.decode(data);
    return Keys.fromJson(jsonResult);
  }
}
```

## Load the File

We can then savely load the file in our main method. NOTE: we need a BuildContext since we're accessing the assets folder.

```dart
  @override
  void initState() {
    KeyLoader().load(context);
    super.initState();
  }
```

We could also wait for the keys to load with a completer:

```dart
class MyAppState extends State<MyApp> {
  Completer<Keys> _keysCompleter = Completer<Keys>();
  late Future<Keys> _keysFuture;

  MyAppState() {
    _keysFuture = _keysCompleter.future;
  }

  @override
  void initState() {
    _keysCompleter.complete(KeyLoader().load(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Keys>(
        future: _keysFuture,
        builder: (BuildContext context, AsyncSnapshot<Keys> snapshot) {
          if (snapshot.hasData) {
            // Key Loaded
            return Container();
          }
          // Still Loading
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [CircularProgressIndicator()],
            ),
          );
        });
  }
}
```

