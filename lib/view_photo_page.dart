import 'dart:io';

import 'package:flutter/material.dart';

class ViewImage extends StatelessWidget {
  const ViewImage({super.key, required this.filePath});
  final String filePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('View Photo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Flexible(
              child: SizedBox(
                width: 350,
                child: Image.file(
                  File(filePath),
                  cacheHeight: 500,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 140,
                  height: 35,
                  child: ElevatedButton.icon(
                      onPressed: () => back(context),
                      icon: const Icon(Icons.arrow_back_rounded),
                      label: const Text("Back")),
                ),
                SizedBox(
                  width: 140,
                  height: 35,
                  child: ElevatedButton.icon(
                      onPressed: () => deletePhoto(filePath, context),
                      icon: const Icon(Icons.delete),
                      label: const Text("Delete")),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> deletePhoto(String filePath, BuildContext context) async {
    final file = File(filePath);
    try {
      if (await file.exists()) {
        await file
            .delete()
            .then((value) => Navigator.pop(context))
            .whenComplete(() => snackBarShow(context, "Photo Deleted"));
      }
    } catch (e) {
      e.toString();
    }
  }

  back(BuildContext context) {
    Navigator.pop(context);
  }

  snackBarShow(BuildContext context, String title) {
    final scaffold = ScaffoldMessenger.of(context);
    Future.delayed(const Duration(milliseconds: 400), () {
      scaffold.showSnackBar(
        SnackBar(
          content: Text(
            title,
          ),
        ),
      );
    });
  }
}
