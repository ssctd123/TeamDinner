// Initializing the attributes of a user
class User {
  String id;
  String firstName;
  String lastName;
  String? venmo;
  dynamic debt;
  dynamic tipPercent;

  User(this.firstName, this.lastName, this.id,
      {this.venmo, this.debt, this.tipPercent});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(json['firstName'], json['lastName'], json['id'],
        venmo: json['venmo'],
        debt: json['debt'],
        tipPercent: json['tipAmount']);
  }

  setDebt(dynamic debt) {
    this.debt = debt;
  }

  @override
  String toString() {
    return "$firstName $lastName";
  }
}
