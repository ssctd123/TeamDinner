import 'package:flutter/material.dart';
import 'package:TeamDinner/api/teams_repository.dart';
import 'package:TeamDinner/api/users_repository.dart';
import '../Types/team.dart';
import '../Types/user.dart';
import 'package:url_launcher/url_launcher.dart';


class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();

}

class _ForgotPasswordState extends State<ForgotPassword> {
  final formKey = GlobalKey<FormState>();
  final senderEmail = TextEditingController();

  void sendEmail() async {
    UsersRepository.sendResetPassword(senderEmail.text);

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Forgot password email sent.')));

    senderEmail.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF045D5D),
        ),
        resizeToAvoidBottomInset: false,
        body: Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Send Forgot Password Email',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextField(
                      controller: senderEmail,
                      decoration: InputDecoration(labelText: 'Email: '),
                    ),
                    SizedBox(height: 32),
                    SizedBox(height: 50,
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF3CBD9F)),
                        ),
                        onPressed: sendEmail,
                        child: Text('Send Forgot Password Email',
                          style: TextStyle(
                            fontSize: 16,
                          )
                        ),
                      )
                    ),
                  ],
                )
            )
        )
    );
  }
}
