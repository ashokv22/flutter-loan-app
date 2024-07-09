import 'package:json_annotation/json_annotation.dart';

part 'loan_application_entity.g.dart';

@JsonSerializable()
class LoanApplicationEntity {
  int id;
  String entityType;
  String entitySubType;
  String displayTitle;
  String entityName;
  String entityIdGeneration;
  String entitySequence;
  String cssClassName;
  List<LoanSection> loanSections;

  LoanApplicationEntity({
    required this.id,
    required this.entityType,
    required this.entitySubType,
    required this.displayTitle,
    required this.entityName,
    required this.entityIdGeneration,
    required this.entitySequence,
    required this.cssClassName,
    required this.loanSections
  });

  factory LoanApplicationEntity.fromJson(Map<String, dynamic> json) =>
      _$LoanApplicationEntityFromJson(json);

  Map<String, dynamic> toJson() => _$LoanApplicationEntityToJson(this);

}

@JsonSerializable()
class LoanSection {
  int? id;
  String sectionName;
  String displayTitle;
  String status;
  String? type;
  String? uiKey;
  List<String>? dependencies;

  LoanSection({
    this.id,
    required this.sectionName,
    required this.displayTitle,
    required this.status,
    this.type,
    this.uiKey,
    this.dependencies
  });

  factory LoanSection.fromJson(Map<String, dynamic> json) => _$LoanSectionFromJson(json);
  Map<String, dynamic> toJson() => _$LoanSectionToJson(this);
}