import 'package:json_annotation/json_annotation.dart';
import 'package:origination/models/bureau_check/individual.dart';

part 'login_pending_products_dto.g.dart';

@JsonSerializable()
class LoginPendingProductsDTO {
  int id;
  String product;
  double loanAmount;
  List<Individual> applicants;

  LoginPendingProductsDTO({
    required this.id,
    required this.product,
    required this.loanAmount,
    required this.applicants
  });

  factory LoginPendingProductsDTO.fromJson(Map<String, dynamic> json) => _$LoginPendingProductsDTOFromJson(json);
  Map<String, dynamic> toJson() => _$LoginPendingProductsDTOToJson(this);

}

