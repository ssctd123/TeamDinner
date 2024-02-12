// Creating token for implementation in other files
class Token {
  final String token;
  bool? wasPasswordReset;

  Token({required this.token, this.wasPasswordReset});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      token: json['token'],
      wasPasswordReset: json['wasPasswordReset'],
    );
  }
}