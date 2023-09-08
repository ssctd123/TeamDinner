// Initializing the attributes of a user
class User {
  String id;
  String firstName;
  String lastName;
  String? email;
  String? venmo;
  String? paypal;
  dynamic debt;
  dynamic tipPercent;

  User(this.firstName, this.lastName, this.email, this.id,
      {this.venmo, this.paypal, this.debt, this.tipPercent});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(json['firstName'], json['lastName'], json['email'], json['id'],
        venmo: json['venmo'],
        paypal: json['paypal'],
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