import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:multi_updater/multi_updater.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    UpdaterWrapper(
      iosPath: 'https://apps.apple.com/app/id1234567890',
      androidPath:
          'https://play.google.com/store/apps/details?id=com.example.app',
      jsonUrl: 'https://example.com/versions.json',
      onUpdateTap: null,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: Text("Hello from multi_updater"))),
    );
  }
}
