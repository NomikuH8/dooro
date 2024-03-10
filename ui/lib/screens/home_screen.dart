import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  final searchController = TextEditingController();

  void goToAddEntry() {
    Get.to(() => const CreateEntryScreen());
  }

  void search() {
    entryController.filterEntries(searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Dooro',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) => search(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Search'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: constraints.maxHeight - 88.0,
                    child: Obx(
                      () => GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200.0,
                          mainAxisExtent: 250.0,
                        ),
                        itemCount: entryController.entriesFiltered.length,
                        itemBuilder: (context, index) {
                          return EntryCard(
                            entry: entryController.entriesFiltered[index],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class EntryCard extends StatelessWidget {
  final Entry entry;
  final preferencesController = Get.find<PreferencesController>();

  EntryCard({super.key, required this.entry});

  File getImageFile() {
    return File(
      path.join(
        preferencesController.defaultPath.value,
        'images',
        entry.imagePath,
      ),
    );
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
                child: Text(
                  entry.title,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
