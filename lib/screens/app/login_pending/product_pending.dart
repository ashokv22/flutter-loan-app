import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductPending extends StatefulWidget {
  const ProductPending({super.key});

  @override
  State<ProductPending> createState() => _ProductPendingState();
}

class _ProductPendingState extends State<ProductPending> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {Navigator.pop(context);}, icon: const Icon(CupertinoIcons.arrow_left)),
        title: const Text("Login Pending"),
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Color.fromRGBO(193, 248, 245, 1),
                Color.fromRGBO(184, 182, 253, 1),
                Color.fromRGBO(62, 58, 250, 1),
              ]
            ),
          ),
        child: Column(
          children: [
            const SizedBox(height: 10,),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              padding: const EdgeInsets.all(16.0),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      width: 0.50,
                      strokeAlign: BorderSide.strokeAlignOutside,
                      color: Color.fromARGB(255, 46, 46, 46),
                    ),
                    borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Related Parties',
                    style: TextStyle(
                      color: Color.fromARGB(255, 46, 46, 46),
                      fontSize: 18,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(
                    CupertinoIcons.chevron_right_circle_fill,
                    color: Color.fromARGB(255, 46, 46, 46),)
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              padding: const EdgeInsets.all(16.0),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      width: 0.50,
                      strokeAlign: BorderSide.strokeAlignOutside,
                      color: Color.fromARGB(255, 46, 46, 46),
                    ),
                    borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Loan Details',
                    style: TextStyle(
                      color: Color.fromARGB(255, 46, 46, 46),
                      fontSize: 18,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(
                    CupertinoIcons.checkmark_shield,
                    color: Color.fromARGB(255, 0, 152, 58),)
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              padding: const EdgeInsets.all(16.0),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      width: 0.50,
                      strokeAlign: BorderSide.strokeAlignOutside,
                      color: Color.fromARGB(255, 46, 46, 46),
                    ),
                    borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Land & Crop Details',
                    style: TextStyle(
                      color: Color.fromARGB(255, 46, 46, 46),
                      fontSize: 18,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(
                    CupertinoIcons.chevron_right_circle_fill,
                    color: Color.fromARGB(255, 46, 46, 46),)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}