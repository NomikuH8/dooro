import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:ui/models/entry.dart';
import 'package:path/path.dart' as path;

class EntryController extends GetxController {
  final entries = <Entry>[].obs;

  void loadAllEntries(Directory directory) {
    var metaPath = path.join(directory.path, 'meta');
    var metaDir = Directory(metaPath);

    entries.clear();

    var list = metaDir.listSync();
    for (var file in list) {
      var stat = file.statSync();
      if (stat.type == FileSystemEntityType.directory) {
        continue;
      }

      var newFile = File(file.path);
      var decoded = jsonDecode(newFile.readAsStringSync());

      final entry = Entry(
        title: decoded['title'],
        imagePath: decoded['imagePath'],
        tags: List<String>.from(decoded['tags']),
      );

      entries.add(entry);
    }

    entries.sort((a, b) {
      return a.title.toLowerCase().compareTo(b.title);
    });
  }
}
