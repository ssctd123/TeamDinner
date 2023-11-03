// Initializing the functionality of a vote
class Vote {
  String teamId;
  String userId;
  List<String> optionIds;
  Map<String, int>? quantities;

  Vote(this.teamId, this.userId, this.optionIds, this.quantities);

  factory Vote.fromJson(Map<String, dynamic> json) {
    Map<String, int> quantities = {};
    json['quantities'].forEach((key, value) {
      quantities[key] = value;
    });
    return Vote(json['teamId'],
        json['userId'],
        json['optionIds'].map<String>((e) => e as String).toList(),
        quantities);
  }

}
