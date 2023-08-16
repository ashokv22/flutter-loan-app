import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:origination/screens/app/login_pending/related_parties.dart';

class ProductPending extends StatefulWidget {
  const ProductPending({super.key});

  @override
  State<ProductPending> createState() => _ProductPendingState();
}

class _ProductPendingState extends State<ProductPending> {
  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {Navigator.pop(context);}, icon: const Icon(CupertinoIcons.arrow_left)),
        title: const Text("Login Pending"),
      ),
      body: Container(
        decoration: BoxDecoration(
          border: isDarkTheme
          ? Border.all(color: Colors.white12, width: 1.0) // Outlined border for dark theme
          : null,
            gradient: isDarkTheme
              ? null // No gradient for dark theme, use a single color
              : const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Color.fromRGBO(193, 248, 245, 1),
                Color.fromRGBO(184, 182, 253, 1),
                Color.fromRGBO(62, 58, 250, 1),
              ]
            ),
            color: isDarkTheme ? Colors.black38 : null
          ),
        child: Column(
          children: [
            const SizedBox(height: 10,),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const RelatedParties()));
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                padding: const EdgeInsets.all(16.0),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 0.50,
                        strokeAlign: BorderSide.strokeAlignOutside,
                        color: isDarkTheme
                          ? Colors.white70
                          : Colors.black87
                      ),
                      borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Related Parties',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.displayMedium!.color,
                        fontSize: 18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(
                      CupertinoIcons.chevron_right_circle_fill,
                      color: Theme.of(context).iconTheme.color,)
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              padding: const EdgeInsets.all(16.0),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 0.50,
                      strokeAlign: BorderSide.strokeAlignOutside,
                      color: isDarkTheme
                        ? Colors.white70
                        : Colors.black87
                    ),
                    borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Loan Details',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.displayMedium!.color,
                      fontSize: 18,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Icon(
                    CupertinoIcons.checkmark_alt_circle_fill,
                    color: Color.fromARGB(255, 0, 152, 58),)
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              padding: const EdgeInsets.all(16.0),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 0.50,
                      strokeAlign: BorderSide.strokeAlignOutside,
                      color: isDarkTheme
                        ? Colors.white70
                        : Colors.black87
                    ),
                    borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Land & Crop Details',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.displayMedium!.color,
                      fontSize: 18,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(
                    CupertinoIcons.chevron_right_circle_fill,
                    color: Theme.of(context).iconTheme.color,)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}