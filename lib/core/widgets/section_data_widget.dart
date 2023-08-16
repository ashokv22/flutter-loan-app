import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SectionDataWidget extends StatelessWidget {
  const SectionDataWidget({
    super.key,
    required this.isDarkTheme,
    required this.status,
    required this.name
  });

  final bool isDarkTheme;
  final String status;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            name,
            style: TextStyle(
              color: Theme.of(context).textTheme.displayMedium!.color,
              fontSize: 18,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
          status == "PENDING" ? Icon(
                CupertinoIcons.chevron_right_circle_fill,
                color: Theme.of(context).iconTheme.color,
              ) : const Icon(
                CupertinoIcons.checkmark_alt_circle_fill,
                color: Color.fromARGB(255, 0, 152, 58),
              )
        ],
      ),
    );
  }
}