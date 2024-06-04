class DashBoardSummaryDTO {
  final String stage;
  final int count;
  final double loanAmount;

  DashBoardSummaryDTO({
    required this.stage,
    required this.count,
    required this.loanAmount,
  });

  factory DashBoardSummaryDTO.fromJson(Map<String, dynamic> json) {
    return DashBoardSummaryDTO(
      stage: json['stage'],
      count: json['count'],
      loanAmount: json['loanAmount'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stage': stage,
      'count': count,
      'loanAmount': loanAmount,
    };
  }
}
