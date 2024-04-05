import 'dart:io';
import 'dart:typed_data';

import 'package:origination/models/login_flow/sections/document_upload/document_checklist_dto.dart';
import 'package:origination/screens/app/login_pending/main_sections/helper_widgets/image_full_view.dart';
import 'package:origination/service/login_flow_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:origination/core/utils/colors.dart';
import 'package:image_picker/image_picker.dart';


class DocumentUpload extends StatefulWidget {
  const DocumentUpload({
    super.key, 
    required this.id
  });

  final int id;

  @override
  State<DocumentUpload> createState() => _DocumentUploadState();
}

class _DocumentUploadState extends State<DocumentUpload> {
  late Future<List<DocumentChecklistDTO>> future;

  LoginPendingService loginFlowService = LoginPendingService();

  @override
  void initState() {
    super.initState();
    fetchDocuments();
  }

  void fetchDocuments() {
    future = fetchApplicationDocuments();
  }

  Future<List<DocumentChecklistDTO>> fetchApplicationDocuments() async {
    try {
      return await loginFlowService.getApplicationDocuments(widget.id);
    } catch (e) {
      throw Exception('Failed to fetch application documents: $e');
    }
  }

  void showUpdate(String msg) {
    ScaffoldMessenger(child: Text(msg));
  }


  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {Navigator.pop(context);},
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
            Expanded(
              child: FutureBuilder<List<DocumentChecklistDTO>>(
                future: future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        final document = snapshot.data![index];
                        return DocumentListItem(document: document);
                      },
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DocumentListItem extends StatefulWidget {
  final DocumentChecklistDTO document;

  const DocumentListItem({
    Key? key,
    required this.document,
  }) : super(key: key);

  @override
  State<DocumentListItem> createState() => _DocumentListItemState();
}

class _DocumentListItemState extends State<DocumentListItem> {
  List<XFile> _selectedImages = [];
  bool _uploading = false;
  double _uploadProgress = 0;

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8.0),
        border: isDarkTheme ? Border.all(color: Colors.white12, width: 1.0) : null,
        boxShadow: isDarkTheme ? null : [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(2, 3),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(widget.document.documentName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),],
                ),
              ),
              if (widget.document.uploadedDocuments != null)
                ...[
                  const SizedBox(width: 0),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
                ]
              else if (_uploading)
                SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(value: _uploadProgress, strokeWidth: 3.0,),
                )
              else
                IconButton(
                  onPressed: _selectedImages.isEmpty ? pickImage : uploadImages,
                  icon: _selectedImages.isEmpty ? const Icon(Icons.file_open, color: ColorConstants.primaryColor) : const Icon(Icons.cloud_upload, color: ColorConstants.primaryColor),
                ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (widget.document.uploadedDocuments != null)
                ...widget.document.uploadedDocuments!.map((application) => FutureBuilder<Uint8List?>(
                      future: fetchImage(application.fileId),
                      builder: (context, imageSnapshot) {
                        if (imageSnapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (imageSnapshot.hasError) {
                          return Text('Error: ${imageSnapshot.error}');
                        } else {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ImageFullView(image: imageSnapshot.data!)));
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6.0),
                              child: imageSnapshot.data != null ? Image.memory(imageSnapshot.data!, height: 60,) : const Text("File not found"),
                            ),
                          );
                        }
                      },
                    ))
              else
                ..._selectedImages.map((image) {
                  return Container(
                    margin: const EdgeInsets.all(8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6.0),
                      child: Image.file(File(image.path), height: 60,),
                    ),
                  );
                }).toList(),
            ],
          )
        ],
      ),
    );
  }

  Future<Uint8List?> fetchImage(int fileId) async {
    final response = await LoginPendingService().streamFile(fileId);
    if (response.statusCode == 200) {
      final imageData = response.bodyBytes;
      return imageData;
    } else {
      throw Exception('Failed to load image: ${response.reasonPhrase}');
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();

    if (pickedImages != null) {
      setState(() {
        _selectedImages = pickedImages;
      });
    }
  }

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
  Future<void> uploadImages() async {
    setState(() {
      _uploading = true;
    });

    // Simulating upload progress
    for (var i = 0; i < _selectedImages.length; i++) {
      await Future.delayed(const Duration(seconds: 1)); // Simulate upload delay
      setState(() {
        _uploadProgress = (i + 1) / _selectedImages.length;
      });
    }

    setState(() {
      _uploading = false;
      _uploadProgress = 0;
      _selectedImages.clear();
    });
  }
}