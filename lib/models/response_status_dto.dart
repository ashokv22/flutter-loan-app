class ResponseStatusDTO {
  final String status;
  final String reasonCode;
  final String reason;

  ResponseStatusDTO({
    required this.status,
    required this.reasonCode,
    required this.reason
  });

  factory ResponseStatusDTO.fromJson(Map<String, dynamic> json) {
    return ResponseStatusDTO(
        status: json['status'],
        reasonCode: json['reasonCode'],
        reason: json['reason']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'reasonCode': reasonCode,
      'reason': reason
    };
  }
}