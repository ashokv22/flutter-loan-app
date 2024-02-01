import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:origination/core/utils/colors.dart';
import 'package:image_picker/image_picker.dart';


class DocumentUpload extends StatefulWidget {
  const DocumentUpload({super.key});

  @override
  State<DocumentUpload> createState() => _DocumentUploadState();
}

class _DocumentUploadState extends State<DocumentUpload> {

  Future<bool> requestPermission() async {
    final status = await Permission.camera.request();
    if (status != PermissionStatus.granted) {
      // Handle permission denial if needed
      return false;
    }
    final storageStatus = await Permission.storage.request();
    if (storageStatus != PermissionStatus.granted) {
      // Handle permission denial if needed
      return false;
    }
    return true;
  }

  Future<Image?> pickImage() async {
    if (!await requestPermission()) {
      // Handle permission denial gracefully
      return null;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery, // Or ImageSource.camera
    );

    if (pickedFile != null) {
      return Image.file(File(pickedFile.path));
    } else {
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(CupertinoIcons.arrow_left)),
          title: const Text("Document Upload", style: TextStyle(fontSize: 18))),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDarkTheme
              ? null // No gradient for dark theme, use a single color
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                      Colors.white,
                      Color.fromRGBO(193, 248, 245, 1),
                    ]),
        ),
        child: Column(
          children: [
            Container(
              // height: 100,
              margin:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(8.0),
                border: isDarkTheme
                    ? Border.all(
                        color: Colors.white12,
                        width: 1.0) // Outlined border for dark theme
                    : null,
                boxShadow: isDarkTheme
                    ? null
                    : [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), //color of shadow
                          spreadRadius: 2, //spread radius
                          blurRadius: 6, // blur radius
                          offset: const Offset(2, 3),
                        )
                      ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("File Name.jpg"),
                  IconButton(
                    onPressed: () {
                      pickImage();
                    }, 
                    icon: const Icon(Icons.cloud_upload, color: ColorConstants.primaryColor),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
