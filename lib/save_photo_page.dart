import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SaveImage extends StatelessWidget {
  const SaveImage({super.key, required this.photo});
  final XFile? photo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Save Photo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Flexible(
              child: SizedBox(
                width: 350,
                child: Image.file(
                  File(photo!.path),
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
                      onPressed: () => savePhoto(context),
                      icon: const Icon(Icons.save),
                      label: const Text("Save Photo")),
                ),
                SizedBox(
                  width: 140,
                  height: 35,
                  child: ElevatedButton.icon(
                      onPressed: () => cancel(context),
                      icon: const Icon(Icons.cancel),
                      label: const Text("Cancel")),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  savePhoto(BuildContext context) async {
    PermissionStatus status = await Permission.storage.status;
    Directory? appDocumentsDirectory = await getExternalStorageDirectory();
    String folderName = "images";
    String appDocumentsPath = appDocumentsDirectory!.path;
    final folderPath = Directory("$appDocumentsPath/$folderName");

    if (!status.isGranted) {
      await Permission.storage.request();
    } else if (status.isGranted) {
      await folderPath.create();

      final fileName = basename(photo!.path);
      final path = folderPath.path;
      await photo!
          .saveTo('$path/$fileName')
          .then((_) => Navigator.pop(context))
          .whenComplete(
              () => snackBarShow(context, "Save Photo to Private Gallery"));
    }
  }

  cancel(BuildContext context) {
    Navigator.pop(context);
    snackBarShow(context, "Cancel the Saving");
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
