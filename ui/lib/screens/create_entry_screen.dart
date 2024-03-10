import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui/controllers/entry_controller.dart';
import 'package:ui/controllers/preferences_controller.dart';
import 'package:ui/controllers/tag_controller.dart';
import 'package:path/path.dart' as path;
import 'package:ui/models/entry.dart';
import 'package:uuid/uuid.dart';

class CreateEntryScreen extends StatefulWidget {
  final Entry? entry;

  const CreateEntryScreen({super.key, this.entry});

  @override
  State<CreateEntryScreen> createState() => _CreateEntryScreenState();
}

class _CreateEntryScreenState extends State<CreateEntryScreen> {
  final titleController = TextEditingController();
  final tagsController = TextEditingController();

  final tagController = Get.find<TagController>();
  final entryController = Get.find<EntryController>();
  final preferencesController = Get.find<PreferencesController>();

  File? imageFile;
  String imageExtension = '';

  Future<void> selectImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result == null) {
      return;
    }

    PlatformFile platformFile = result.files.first;

    imageExtension = platformFile.extension!;

    setState(() {
      imageFile = File(platformFile.path!);
    });
  }

  void confirmEntry(BuildContext context) {
    if (imageExtension == '' || imageFile == null) {
      return;
    }

    const uuid = Uuid();
    final uuidV4 = uuid.v4();
    final defaultPath = preferencesController.defaultPath.value;
    var imagePath = path.join(defaultPath, 'images', '$uuidV4.$imageExtension');
    var metaPath = path.join(defaultPath, 'meta', '$uuidV4.json');

    File(imagePath).createSync(recursive: true);
    File(metaPath).createSync(recursive: true);

    imageFile!.copySync(imagePath);

    var jsonFile = File(metaPath);
    jsonFile.createSync(recursive: true);
    jsonFile.writeAsStringSync(jsonEncode({
      'title': titleController.text,
      'imagePath': '$uuidV4.$imageExtension',
      'tags': tagsController.text.split(' '),
    }));

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Original image'),
          content: const Text('Do you want to delete the original image?'),
          actions: [
            TextButton(
              onPressed: () {
                finishAddEntry(false);
                Navigator.of(context).pop();
                Get.back();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                finishAddEntry(true);
                Navigator.of(context).pop();
                Get.back();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void confirmEditEntry() {
    final defaultPath = preferencesController.defaultPath.value;
    final entry = widget.entry!;

    final uuidV4 = entry.imagePath.split('.')[0];
    final metaPath = path.join(defaultPath, 'meta', '$uuidV4.json');

    File(metaPath).writeAsStringSync(jsonEncode({
      'title': titleController.text,
      'imagePath': entry.imagePath,
      'tags': tagsController.text.split(' '),
    }));

    final currentEntry = entryController.entries.firstWhere(
      (element) => element.imagePath == entry.imagePath,
    );

    currentEntry.title = titleController.text;
    currentEntry.tags = tagsController.text.split(' ');

    entryController.loadAllEntries(
      Directory(defaultPath),
    );

    Get.back();
  }

  void finishAddEntry(bool delete) {
    if (delete) {
      imageFile!.deleteSync();
    }

    entryController.loadAllEntries(
      Directory(preferencesController.defaultPath.value),
    );
  }

  @override
  Widget build(BuildContext context) {
    String title = 'Create entry';
    if (widget.entry != null) {
      title = 'Edit entry';
      titleController.text = widget.entry!.title;
      tagsController.text = widget.entry!.tags.join(' ');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        leading: const BackButton(
          color: Colors.white,
        ),
        backgroundColor: Colors.deepPurple,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              onPressed: () {
                if (widget.entry == null) {
                  confirmEntry(context);
                  return;
                }

                confirmEditEntry();
              },
              icon: const Icon(Icons.check),
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Title'),
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              TextField(
                controller: tagsController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Tags'),
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              if (widget.entry == null)
                TextButton(
                  onPressed: () async => await selectImage(),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.deepPurple.shade100,
                    ),
                  ),
                  child: const Text('Select image'),
                ),
              const SizedBox(
                height: 16.0,
              ),
              if (imageFile != null)
                Image.file(
                  imageFile!,
                ),
              const SizedBox(
                height: 16.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
