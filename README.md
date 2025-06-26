# multi_updater

A lightweight Flutter package that checks for app updates via Firebase Remote Config or a custom JSON API.  
It shows an update dialog with options to update via App Store or Play Store — or to exit the app.

## ✨ Features

- 🔥 Firebase Remote Config support
- 🌐 Custom JSON endpoint fallback
- 📲 Works on both Android & iOS
- 🧱 Uses a simple wrapper — no need to modify every screen
- 🆕 `onUpdateTap` support — override default behavior

## 🚀 Getting Started

### Add dependency


### Usage

'''example
    import 'package:flutter/material.dart';
import 'package:multi_updater/multi_updater.dart';

void main() {
  runApp(
    UpdaterWrapper(
      iosPath: "https://apps.apple.com/app/id1234567890",
      androidPath: "https://play.google.com/store/apps/details?id=com.example.app",
      useFirebase: true,
      remoteConfigKey: "latest_version",
      jsonUrl: "https://example.com/version.json",
      onUpdateTap: null,
      child: const MyApp(),
    ),
  );
}


```yaml
dependencies:
  multi_updater: ^1.0.1
