import 'package:flutter/material.dart';

class CustomSnackBar extends StatefulWidget {
  final String message;
  final String type;
  final bool isDarkTheme;

  // ignore: prefer_const_constructors_in_immutables, use_key_in_widget_constructors
  CustomSnackBar({required this.message, required this.type, required this.isDarkTheme});

  static void show(BuildContext context,
      {required String message, required String type, required bool isDarkTheme}) {
    final snackBar = CustomSnackBar(message: message, type: type, isDarkTheme: isDarkTheme);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.removeCurrentSnackBar();
    scaffoldMessenger.showSnackBar(
      SnackBar(
        elevation: 1,
        content: snackBar,
        duration: const Duration(seconds: 2),
        backgroundColor: isDarkTheme
            ? Colors.white.withOpacity(0.8)
            : Colors.black.withOpacity(0.7),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  // ignore: library_private_types_in_public_api
  _CustomSnackBarState createState() => _CustomSnackBarState();
}

class _CustomSnackBarState extends State<CustomSnackBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Row(
          children: <Widget>[
            if (widget.type.toLowerCase() == "success") ...[
              const Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
            ] else if (widget.type.toLowerCase() == "warn") ...[
              Icon(
                Icons.warning,
                color: widget.isDarkTheme ? Colors.black : Colors.white,
              ),
            ] else ...[
              const Icon(
                Icons.error,
                color: Colors.red,
              ),
            ],
            const SizedBox(width: 5),
            Text(
              widget.message,
              style: TextStyle(
                  color: widget.isDarkTheme ? Colors.black : Colors.white),
            ),
          ],
        );
      },
    );
  }
}
