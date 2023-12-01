import 'user_type.dart';

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
  UserType? userType;
  dynamic numberOfParticipants;

  User(this.firstName, this.lastName, this.email, this.id,
      {this.venmo, this.paypal, this.debt, this.tipPercent, this.userType, this.numberOfParticipants});

  factory User.fromJson(Map<String, dynamic> json) {
    var userType = UserType.values
        .firstWhere((e) => e.toString() == '${json["userType"]}', orElse: () => UserType.PLAYER);
    return User(json['firstName'], json['lastName'], json['email'], json['id'],
        venmo: json['venmo'],
        paypal: json['paypal'],
        debt: json['debt'],
        tipPercent: json['tipAmount'],
        userType: userType,
        numberOfParticipants: json['numberOfParticipants']);
  }

  setDebt(dynamic debt) {
    this.debt = debt;
  }

  @override
  String toString() {
    return "$firstName $lastName";
  }
}