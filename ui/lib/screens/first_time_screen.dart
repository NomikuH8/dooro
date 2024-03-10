import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui/constants/preferences.dart';
import 'package:ui/screens/home_screen.dart';

class FirstTimeScreen extends StatefulWidget {
  const FirstTimeScreen({super.key});

  @override
  State<FirstTimeScreen> createState() => _FirstTimeScreenState();
}

class _FirstTimeScreenState extends State<FirstTimeScreen> {
  final projectPathController = TextEditingController();

  Future<void> pickFolder() async {
    String? result = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Select a folder for the project',
    );

    if (result == null) {
      return;
    }

    projectPathController.text = result;
  }

  Future<void> setProjectPath() async {
    var dir = Directory(projectPathController.text);
    dir.createSync(recursive: true);

    final prefs = await SharedPreferences.getInstance();
    prefs.setString(defaultPathKey, projectPathController.text);

    Get.off(() => const HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: projectPathController,
                    decoration: const InputDecoration(
                      label: Text('Project path'),
                      hintText: 'Folder to store the images',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.deepPurple.shade100,
                    ),
                    minimumSize: MaterialStateProperty.all(
                      const Size(32.0, 64.0),
                    ),
                  ),
                  onPressed: () => pickFolder(),
                  child: const Text('Select...'),
                )
              ],
            ),
            const SizedBox(
              height: 16.0,
            ),
            TextButton(
              onPressed: () => setProjectPath(),
              child: const Text('Set project path'),
            )
          ],
        ),
      ),
    );
  }
}
