import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/screens/admin/configs/config_service.dart';
import 'package:origination/screens/widgets/custom_snackbar.dart';

class ConfigControllers extends StatefulWidget {
  const ConfigControllers({super.key});

  @override
  State<ConfigControllers> createState() => _ConfigControllersState();
}

class _ConfigControllersState extends State<ConfigControllers> {
  Map<String, bool> booleanProperties = {};
  Map<String, bool> loadingStates = {};

  bool isLoading = false;
  String message = '';

  final configService = ConfigService();
  late Future<Map<String, dynamic>> configFuture;
  final logger = Logger();

  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  Future<void> _loadProperties() async {
    configFuture = configService.getProperties().then((response) {
      final properties = jsonDecode(response.body) as Map<String, dynamic>;
      properties.forEach((key, value) {
        if (value is bool) {
          booleanProperties[key] = value;
          loadingStates[key] = false;
        }
      });
      return properties;
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
        title: const Text("Configurations", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
        child: FutureBuilder(
            future: configFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData) {
                return const SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Center(child: Text('No data found', style: TextStyle(fontSize: 20))));
              } else if (snapshot.hasData) {
                final properties = snapshot.data!;
                final booleanProperties = properties.entries.where((entry) => entry.value is bool);
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(children: [
                        const SizedBox(height: 12.0),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: const Text("Fallbacks", style: TextStyle(fontSize: 16), textAlign: TextAlign.start),
                        ),
                        const SizedBox(height: 12.0),
                        Column(
                          children: booleanProperties.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(8.0),
                                border: isDarkTheme ? Border.all(color: Colors.white12, width: 1.0) : null,
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
                                    Text(entry.key, style: const TextStyle(fontSize: 14)),
                                    loadingStates[entry.key]!
                                        ? const SizedBox(
                                            width: 20.0,
                                            height: 20.0,
                                            child: CircularProgressIndicator(strokeWidth: 2.0))
                                        : CupertinoSwitch(
                                            value: entry.value,
                                            onChanged: (bool value) {
                                              _showConfirmationDialog(value, entry.key);
                                            },
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList()),
                      ]),
                    ),
                  ],
                );
              }
              return Container();
            }),
      ),
    );
  }

  void _showConfirmationDialog(bool value, String property) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Update'),
        content: const Text('Are you sure you want to update this setting?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                loadingStates[property] = true;
              });
              Navigator.of(context).pop();
              _updateProperty(property, value).then((_) {
                setState(() {
                  configFuture = configService
                      .getProperties()
                      .then((response) => jsonDecode(response.body));
                });
              });
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Future<void> _updateProperty(String property, dynamic value) async {
    setState(() {
      loadingStates[property] = true;
    });
    try {
      final response = await configService.updateProperties(property, value.toString());
      int statusCode = response.statusCode;
      if (statusCode == 200) {
        setState(() {
          booleanProperties[property] = value;
          message = 'Property updated';
          showSuccessMessage(message);
        });
      } else {
        setState(() {
          message = 'Failed: ${response.body}';
          showErrorMessage(message);
        });
      }
    } catch (e) {
      setState(() {
        message = 'Failed: $e';
        showErrorMessage(message);
      });
    } finally {
      setState(() {
        loadingStates[property] = false;
      });
    }
  }

  void showErrorMessage(String message) {
    CustomSnackBar.show(context, message: message, type: "error", isDarkTheme: true);
  }

  void showSuccessMessage(String message) {
    CustomSnackBar.show(context, message: message, type: "success", isDarkTheme: true);
  }

}
