import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui/controllers/entry_controller.dart';
import 'package:ui/controllers/preferences_controller.dart';
import 'package:ui/models/entry.dart';
import 'package:path/path.dart' as path;
import 'package:ui/screens/create_entry_screen.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key, required this.entry});

  final Entry entry;

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  final entryController = Get.find<EntryController>();
  final preferencesController = Get.find<PreferencesController>();
  int entryIndex = 0;
  Entry? newEntry;

  File getImageFile() {
    return File(
      path.join(
        preferencesController.defaultPath.value,
        'images',
        widget.entry.imagePath,
      ),
    );
  }

  void deleteFile(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete'),
          content: const Text('Are you sure?'),
          actions: [
            TextButton(
              child: const Text('No'),
              onPressed: () => deleteFileConfirmation(false),
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () => deleteFileConfirmation(true),
            ),
          ],
        );
      },
    );
  }

  void deleteFileConfirmation(bool isToDelete) {
    if (isToDelete) {
      var uuid = widget.entry.imagePath.split('.')[0];
      var imageFile = File(
        path.join(
          preferencesController.defaultPath.value,
          'images',
          widget.entry.imagePath,
        ),
      );
      var metaPath = File(
        path.join(
          preferencesController.defaultPath.value,
          'meta',
          '$uuid.json',
        ),
      );

      imageFile.deleteSync();
      metaPath.deleteSync();

      entryController.loadAllEntries(
        Directory(
          preferencesController.defaultPath.value,
        ),
      );
    }

    Get.back();
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    if (entryIndex == 0) {
      entryIndex = entryController.entries.indexWhere(
        (element) => element.title == widget.entry.title,
      );
      newEntry = widget.entry;
    } else {
      setState(() {
        newEntry = entryController.entries[entryIndex];
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        leading: const BackButton(
          color: Colors.white,
        ),
        title: Text(
          newEntry!.title,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            color: Colors.white,
            onPressed: () {
              Get.to(
                () => CreateEntryScreen(entry: newEntry),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.white,
              onPressed: () {
                deleteFile(context);
              },
            ),
          )
        ],
      ),
      body: Center(
        child: Image.file(
          getImageFile(),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
