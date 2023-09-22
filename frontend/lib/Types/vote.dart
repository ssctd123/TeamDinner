// Initializing the functionality of a vote
class Vote {
  String userId;
  List<String> optionIds;
  Map<String, int>? quantities;

  Vote(this.userId, this.optionIds, this.quantities);

  factory Vote.fromJson(Map<String, dynamic> json) {
    Map<String, int> quantities = {};
    json['quantities'].forEach((key, value) {
      quantities[key] = value;
    });
    return Vote(json['userId'],
        json['optionIds'].map<String>((e) => e as String).toList(),
        quantities);
  }

}
