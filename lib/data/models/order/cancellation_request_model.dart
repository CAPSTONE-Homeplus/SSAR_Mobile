class CancellationRequestModel {
  final String cancellationReason;
  final String refundMethod;
  final String cancelledBy;

  CancellationRequestModel({
    required this.cancellationReason,
    required this.refundMethod,
    required this.cancelledBy,
  });

  Map<String, dynamic> toJson() {
    return {
      'cancellationReason': cancellationReason,
      'refundMethod': refundMethod,
      'cancelledBy': cancelledBy,
    };
  }

  factory CancellationRequestModel.fromJson(Map<String, dynamic> json) {
    return CancellationRequestModel(
      cancellationReason: json['cancellationReason'],
      refundMethod: json['refundMethod'],
      cancelledBy: json['cancelledBy'],
    );
  }
}