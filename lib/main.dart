import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/firebase_options.dart';
import 'package:stronger_muscles/view/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';


Future<void> main() async {
  await Firebase.initializeApp(

    options: DefaultFirebaseOptions.currentPlatform,

);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: const MyHomePage(),
    );
  }
}

