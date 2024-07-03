import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/screens/admin/configs/config_service.dart';
import 'package:origination/screens/widgets/custom_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigControllers extends StatefulWidget {
  const ConfigControllers({super.key});

  @override
  State<ConfigControllers> createState() => _ConfigControllersState();
}

class _ConfigControllersState extends State<ConfigControllers> {

  bool enableCibilFallback = false;
  bool isLoading = false;
  String message = '';

  final configService = ConfigService();
  final logger = Logger();

  @override
  void initState() {
    super.initState();
    _loadDedupePref();
  }

  Future<void> _loadDedupePref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      enableCibilFallback = prefs.getBool('enableDedupe') ?? false;
    });
  }

  Future<void> _updateDedupePref(bool value) async {
    setState(() {
      isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('enableDedupe', value);
    setState(() {
      enableCibilFallback = value;
      isLoading = false;
    });
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
        title: const Text("Configurations",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
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
                      Color.fromRGBO(184, 182, 253, 1),
                      Color.fromRGBO(62, 58, 250, 1),
                    ]),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text("Features", style: TextStyle(fontSize: 16, ), textAlign: TextAlign.start),
                ),
                const SizedBox(height: 12.0),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(8.0),
                    border: isDarkTheme
                        ? Border.all(color: Colors.white12, width: 1.0)
                        : null,
                    boxShadow: isDarkTheme
                        ? null
                        : [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset: const Offset(2, 3),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Enable Dedupe',
                          style: TextStyle(fontSize: 14),
                        ),
                        // isLoading
                        //     ? const SizedBox(
                        //   width: 20.0,
                        //   height: 20.0,
                        //   child: CircularProgressIndicator(
                        //     strokeWidth: 2.0,
                        //   ),
                        // )
                        //     :
                        CupertinoSwitch(
                          value: enableCibilFallback,
                          onChanged: (bool value) {
                            // _updateDedupePref(value);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text("Fallbacks", style: TextStyle(fontSize: 16, ), textAlign: TextAlign.start),
                ),
                const SizedBox(height: 12.0),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(8.0),
                    border: isDarkTheme
                        ? Border.all(color: Colors.white12, width: 1.0)
                        : null,
                    boxShadow: isDarkTheme
                        ? null
                        : [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 6,
                              offset: const Offset(2, 3),
                            )
                          ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Enable Cibil Fallback',
                          style: TextStyle(fontSize: 14),
                        ),
                        isLoading
                            ? const SizedBox(
                                width: 20.0,
                                height: 20.0,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                ),
                              )
                            : CupertinoSwitch(
                                value: enableCibilFallback,
                                onChanged: (bool value) {
                                  _showConfirmationDialog(value);
                                },
                              ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(8.0),
                    border: isDarkTheme
                        ? Border.all(color: Colors.white12, width: 1.0)
                        : null,
                    boxShadow: isDarkTheme
                        ? null
                        : [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 6,
                              offset: const Offset(2, 3),
                            )
                          ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Enable Dedupe Fallback',
                          style: TextStyle(fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: () {
                            CustomSnackBar.show(context, message: "Coming soom!", isDarkTheme: true);
                          },
                          child: const Icon(Icons.history, size: 25.0,),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(8.0),
                    border: isDarkTheme
                        ? Border.all(color: Colors.white12, width: 1.0)
                        : null,
                    boxShadow: isDarkTheme
                        ? null
                        : [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 6,
                              offset: const Offset(2, 3),
                            )
                          ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Enable Email OTP',
                          style: TextStyle(fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: () {
                            CustomSnackBar.show(context, message: "Coming soon!", isDarkTheme: true);
                          },
                          child: const Icon(Icons.history, size: 25.0,),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(bool newValue) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Confirm Change',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text('Are you sure you want to change the property?'),
              const SizedBox(height: 20),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        updateConfig(newValue);
                      },
                      color: const Color.fromARGB(255, 237, 9, 9),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: const Text('Update',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> updateConfig(bool value) async {
    setState(() {
      isLoading = true;
      message = '';
    });

    // Simulate a network request
    try {
      final response = await configService.updateCibilFallback(value);

      // await Future.delayed(const Duration(seconds: 3));
      // int statusCode = 200;
      logger.i("Status: ${response.statusCode}, body: ${response.body}");
      int statusCode = response.statusCode;

      if (statusCode == 200) {
        setState(() {
          enableCibilFallback = value;
          message = 'Property updated';
        });
      } else {
        showErrorMessage();
        // CustomSnackBar.show(context, message: "Coming soon!", isDarkTheme: true);
        setState(() {
          message = 'Failed to update property';
        });
      }
    } catch (e) {
      setState(() {
        message = 'Error occurred: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showErrorMessage() {
    CustomSnackBar.show(context, message: "Something went wrong!", isDarkTheme: true);
  }
}
