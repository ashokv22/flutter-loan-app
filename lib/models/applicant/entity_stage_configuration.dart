import 'package:json_annotation/json_annotation.dart';

part 'entity_stage_configuration.g.dart';

@JsonSerializable()
class EntityStageConfiguration {
  int id;
  String stage;
  String? status;
  int? order;
  int? isEditable;

  EntityStageConfiguration({
    required this.id,
    required this.stage,
    this.status,
    this.order,
    this.isEditable
  });

  factory EntityStageConfiguration.fromJson(Map<String, dynamic> json) => _$EntityStageConfigurationFromJson(json);
  Map<String, dynamic> toJson() => _$EntityStageConfigurationToJson(this);

}