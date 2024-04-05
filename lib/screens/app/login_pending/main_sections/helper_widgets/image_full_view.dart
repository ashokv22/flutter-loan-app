import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageFullView extends StatefulWidget {
  const ImageFullView({
    super.key,
    required this.image,
  });

  final Uint8List image;

  @override
  State<ImageFullView> createState() => _ImageFullViewState();
}

class _ImageFullViewState extends State<ImageFullView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () {Navigator.pop(context);},
            icon: const Icon(CupertinoIcons.arrow_left, color: Colors.white,)),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.memory(widget.image, fit: BoxFit.contain,)
      ),
    );
  }
}