import 'package:json_annotation/json_annotation.dart';

part 'address_dto.g.dart';

@JsonSerializable()
class AddressDTO {
  String? city;
  String? country;
  String? district;
  String? state;


  AddressDTO({
    this.city,
    this.country,
    this.district,
    this.state
  });

  factory AddressDTO.fromJson(Map<String, dynamic> json) => _$AddressDTOFromJson(json);
  Map<String, dynamic> toJson() => _$AddressDTOToJson(this);
}
