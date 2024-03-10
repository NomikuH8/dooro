import 'package:get/get.dart';
import 'package:ui/models/entry.dart';

class TagController extends GetxController {
  final availableTags = <String>[].obs;

  void loadAllTags(List<Entry> entries) {
    for (var entry in entries) {
      for (var tag in entry.tags) {
        if (availableTags.contains(tag)) {
          continue;
        }

        availableTags.add(tag);
      }
    }
  }
}
