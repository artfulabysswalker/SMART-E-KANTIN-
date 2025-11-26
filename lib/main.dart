import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'main_page.dart'; // Make sure class name inside is MainPage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 Initialize Firebase before runApp()
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temp Auth UI',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const mainpage(), // 🔥 FIXED (class must be MainPage)
      debugShowCheckedModeBanner: false,
    );
  }
}
