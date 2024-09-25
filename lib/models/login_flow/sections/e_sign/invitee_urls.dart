
import 'package:json_annotation/json_annotation.dart';

part 'invitee_urls.g.dart';

@JsonSerializable()
class InviteeUrls {
  final String? customerType;
  final String? name;
  final String? phone;
  final String? email;
  final String? url;
  final bool? signed;

  InviteeUrls({
    this.customerType,
    this.name,
    this.phone,
    this.email,
    this.url,
    this.signed
  });

  factory InviteeUrls.fromJson(Map<String, dynamic> json) => _$InviteeUrlsFromJson(json);
  Map<String, dynamic> toJson() => _$InviteeUrlsToJson(this);

}