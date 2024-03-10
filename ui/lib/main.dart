import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui/constants/preferences.dart';
import 'package:ui/controllers/entry_controller.dart';
import 'package:ui/controllers/preferences_controller.dart';
import 'package:ui/controllers/tag_controller.dart';
import 'package:ui/screens/first_time_screen.dart';
import 'package:ui/screens/home_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Future<String> startControllers() async {
    Get.put(PreferencesController());
    Get.put(EntryController());
    Get.put(TagController());

    final prefs = await SharedPreferences.getInstance();
    final defaultPath = prefs.getString(defaultPathKey) ?? '';

    final preferencesController = Get.find<PreferencesController>();
    preferencesController.defaultPath.value = defaultPath;

    final entryController = Get.find<EntryController>();
    entryController.loadAllEntries(Directory(defaultPath));

    final tagController = Get.find<TagController>();
    tagController.loadAllTags(entryController.entries);

    return defaultPath;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 106, 6, 152),
      ),
      home: FutureBuilder(
        future: startControllers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const FirstTimeScreen();
          }

          var dir = Directory(snapshot.data!);

          if (snapshot.data!.isEmpty || !dir.existsSync()) {
            return const FirstTimeScreen();
          }

          return const HomeScreen();
        },
      ),
    );
  }
}
