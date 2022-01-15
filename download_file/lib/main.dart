import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loading = false;
  final Dio dio = Dio();
  double progress = 0;
  Future<bool> saveFile(String url, String fileName) async {
    Directory? directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = await getExternalStorageDirectory();
          if (directory != null) {
            String newPath = "";
            List<String> folders = directory.path.split('/');
            for (int x = 1; x < folders.length; x++) {
              String folder = folders[x];
              if (folder != "Android") {
                newPath += "/" + folder;
              } else {
                break;
              }
            }
            newPath += "/Download";
            directory = Directory(newPath);
            directory.path;
          }
        } else {
          return false;
        }
      } else if (Platform.isIOS) {
        if (await _requestPermission(Permission.photos)) {
          directory = await getTemporaryDirectory();
        } else {
          return false;
        }
      } else {}
      if (directory != null) {
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        if (await directory.exists()) {
          File saveFile = File(directory.path + "/$fileName");
          await dio.download(url, saveFile.path,
              onReceiveProgress: (downloaded, totalSize) {
            setState(() {
              progress = downloaded / totalSize;
            });
          });
          if (Platform.isIOS) {
            await ImageGallerySaver.saveFile(saveFile.path,
                isReturnPathOfIOS: true);
          }
          return true;
        }
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
    return false;
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  downloadFile() async {
    setState(() {
      loading = true;
    });

    bool downloaded = await saveFile(
        "https://www.learningcontainer.com/download/sample-mp4-video-file-download-for-testing/#",
        "Test-Mahdi.mp4");

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text('home'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: loading
            ? LinearProgressIndicator(
                value: progress,
                minHeight: 10,
              )
            : ElevatedButton.icon(
                onPressed: downloadFile,
                icon: const Icon(Icons.download),
                label: const Text('Download File')),
      ),
    );
  }
}
