import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:private_photo_gallery/save_photo_page.dart';
import 'package:private_photo_gallery/view_photo_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Private Photo Gallery'),
      ),
      body: Stack(
        children: <Widget>[
          FutureBuilder(
            future: getImages(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 110),
                  child: GridView.builder(
                      itemCount: snapshot.data!.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, childAspectRatio: 3.0 / 4.6),
                      itemBuilder: (context, index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) => ViewImage(
                                    filePath: snapshot.data![index],
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.file(
                                File(snapshot.data![index]),
                                fit: BoxFit.cover,
                                cacheHeight: 400,
                              ),
                            ),
                          ),
                        );
                      }),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return const Center(
                  child: Text("There is no Photos in Gallery"),
                );
              }
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: SizedBox(
                width: 200,
                height: 60,
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {});
                    takePhoto(context);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                  ),
                  icon: const Icon(
                    Icons.camera,
                    size: 40,
                  ),
                  label: const Text(
                    'Take a photo',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void takePhoto(BuildContext context) async {
    final navigator = Navigator.of(context);
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo == null) {
      return;
    }
    navigator.push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => SaveImage(
          photo: photo,
        ),
      ),
    );
  }

  Future<List<String>?> getImages() async {
    List<String> photoList = [];
    PermissionStatus status = await Permission.storage.status;
    Directory? appDocumentsDirectory = await getExternalStorageDirectory();
    String folderName = "images";
    String appDocumentsPath = appDocumentsDirectory!.path;
    final folderPath = Directory("$appDocumentsPath/$folderName");

    if (!status.isGranted) {
      await Permission.storage.request();
    } else if (status.isGranted) {
      await folderPath.create();
      setState(() {
        photoList = folderPath
            .listSync()
            .map((item) => item.absolute.path)
            .where((item) => item.endsWith(".jpg"))
            .toList();
      });
    }
    if (photoList.isNotEmpty) {
      return photoList;
    } else {
      return null;
    }
  }
}
