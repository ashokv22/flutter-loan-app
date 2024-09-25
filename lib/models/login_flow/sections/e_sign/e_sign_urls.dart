import 'package:json_annotation/json_annotation.dart';
import 'package:origination/models/login_flow/sections/e_sign/invitee_urls.dart';

part 'e_sign_urls.g.dart';

@JsonSerializable()
class ESignUrls {
  final String? documentType;
  final String? status;
  final String? customerType;
  final List<InviteeUrls>? inviteeUrls;

  ESignUrls({
    this.documentType,
    this.status,
    this.customerType,
    this.inviteeUrls
  });

  factory ESignUrls.fromJson(Map<String, dynamic> json) => _$ESignUrlsFromJson(json);
  Map<String, dynamic> toJson() => _$ESignUrlsToJson(this);

}
