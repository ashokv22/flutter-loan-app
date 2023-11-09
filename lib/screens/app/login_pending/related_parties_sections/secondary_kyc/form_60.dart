import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Form60 extends StatefulWidget {
  const Form60({
    super.key,
    required this.relatedPartyId,
  });

  final int relatedPartyId;
  @override
  State<Form60> createState() => _Form60State();
}

class _Form60State extends State<Form60> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {Navigator.pop(context);}, icon: const Icon(CupertinoIcons.arrow_left)),
        title: const Text("Form 60", style: TextStyle(fontSize: 18)),
      )
    );
  }
}