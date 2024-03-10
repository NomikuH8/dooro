import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui/controllers/entry_controller.dart';
import 'package:ui/controllers/preferences_controller.dart';
import 'package:ui/models/entry.dart';
import 'package:ui/screens/create_entry_screen.dart';
import 'package:ui/screens/entry_screen.dart';
import 'package:path/path.dart' as path;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final entryController = Get.find<EntryController>();

  void goToAddEntry() {
    Get.to(() => const CreateEntryScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dooro',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              onPressed: () => goToAddEntry(),
              icon: const Icon(Icons.add),
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Obx(
        () => GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300.0,
            mainAxisExtent: 250.0,
          ),
          itemCount: entryController.entries.length,
          itemBuilder: (context, index) {
            return EntryCard(
              entry: entryController.entries[index],
            );
          },
        ),
      ),
    );
  }
}

class EntryCard extends StatelessWidget {
  final Entry entry;
  final preferencesController = Get.find<PreferencesController>();

  EntryCard({super.key, required this.entry});

  File getImageFile() {
    return File(path.join(
        preferencesController.defaultPath.value, 'images', entry.imagePath));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Get.to(() => EntryScreen(entry: entry));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 190.0,
                child: Image(
                  fit: BoxFit.contain,
                  image: FileImage(
                    getImageFile(),
                  ),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Center(
                child: Text(entry.title),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
