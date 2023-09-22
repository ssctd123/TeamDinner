import 'dart:collection';

class QuantityResult {
  String optionId;
  int quantity;

  QuantityResult(this.optionId, this.quantity);

  factory QuantityResult.fromJson(Map<String, dynamic> json) {
    return QuantityResult(
        json['optionId'],
        json['quantity']
    );
  }
}