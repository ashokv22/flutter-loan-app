import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:origination/core/widgets/number_input.dart';
import 'package:origination/models/applicant/entity_stage_configuration.dart';
import 'package:origination/models/applicant/entity_state_manager.dart';
import 'package:origination/service/entity_state_manager_service.dart';

class MoveStage extends StatefulWidget {
  const MoveStage({
    super.key,
    required this.applicantId,
  });

  final int applicantId;

  @override
  State<MoveStage> createState() => _MoveStageState();
}

class _MoveStageState extends State<MoveStage> {

  late EntityStateManager esm;
  List<EntityStageConfiguration> entityStageConfigurations = [];
  bool isLoading = false;
  String errorMessage = '';

  late Future<EntityStateManager> esmFuture;
  late Future<List<EntityStageConfiguration>> configurationsFuture;
  final EntityStateManagerService entityStateManagerService = EntityStateManagerService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    esmFuture = fetchESM();
    configurationsFuture = fetchEntityStageConfigurations();

    // getEntityStateConfigurations();
    // getESM();
  }

  void getESM() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await entityStateManagerService.getEntityStateManagerByApplicantId(widget.applicantId);
      if (response.hashCode == 200) {
        setState(() {
          esm = EntityStateManager.fromJson(json.decode(response.body));
        });
      } else {
        errorMessage = 'Error code: ${response.statusCode}, Message: ${response.body}';
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void getEntityStateConfigurations() async {
    try {
      final response = await entityStateManagerService.getAllEntityStageConfigurations();
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        List<EntityStageConfiguration> entityStageConfigurations = [];
        for (var data in responseData) {
          EntityStageConfiguration entityStageConfiguration = EntityStageConfiguration.fromJson(data);
          entityStageConfigurations.add(entityStageConfiguration);
        }
        entityStageConfigurations = entityStageConfigurations;
      } else {
        errorMessage = 'Error code: ${response.statusCode}, Message: ${response.body}';
      }
    } catch (e) {
      errorMessage = e.toString();
    }

  }

  Future<EntityStateManager> fetchESM() async {
    try {
      final response = await entityStateManagerService.getEntityStateManagerByApplicantId(widget.applicantId);
      if (response.statusCode == 200) {
        return EntityStateManager.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error code: ${response.statusCode}, Message: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to load ESM: $e');
    }
  }

  Future<List<EntityStageConfiguration>> fetchEntityStageConfigurations() async {
    try {
      final response = await entityStateManagerService.getAllEntityStageConfigurations();
      if (response.statusCode == 200) {
        final List responseData = json.decode(response.body);
        return responseData.map((data) => EntityStageConfiguration.fromJson(data)).toList();
      } else {
        throw Exception('Error code: ${response.statusCode}, Message: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to load configurations: $e');
    }
  }

  void submitMoveStage() {

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AppBar(
          automaticallyImplyLeading: false,
          leading: const Icon(Icons.warning_rounded, color: Colors.orange,),
          title: const Text(
            'Move stage',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder(
            future: Future.wait([esmFuture, configurationsFuture]),
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {

                final esm = snapshot.data![0] as EntityStateManager;
                final configurations = snapshot.data![1] as List<EntityStageConfiguration>;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildDropdown(esm, configurations),
                  ],
                );
              }
              return const SizedBox.shrink();
            }
          ),
        ),
        const Expanded(child: SizedBox()), // Add an expanded widget to fill remaining space
        Container(
          width: double.infinity,
          height: 80.0,
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 3, 71, 244),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
            ),
            child: const Text('Continue', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget buildDropdown(EntityStateManager esm, List<EntityStageConfiguration> configurations) {
    return InputDecorator(
      decoration: const InputDecoration(
        labelText: "Stage",
        border: OutlineInputBorder(),
        isDense: true, // Reduce the height of the input
        contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          value: esm.status.isNotEmpty ? esm.status : "" ,
          items: [
            const DropdownMenuItem<String>(
              value: "",
              enabled: false,
              child: Text("Select"),
            ),
            ...configurations.map((option) {
              return DropdownMenuItem<String>(
                value: option.stage,
                child: SizedBox(
                    width: 280,
                    child: Text(
                      option.stage,
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    )
                ),
              );
            }),
          ],
          onChanged: (newValue) {
            setState(() {
              esm.status = newValue!;
            });
          },
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
