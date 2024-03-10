import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui/controllers/entry_controller.dart';
import 'package:ui/models/entry.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key, required this.entry});

  final Entry entry;

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  final entryController = Get.find<EntryController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.entry.title,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
