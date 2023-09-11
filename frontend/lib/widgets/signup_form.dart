import 'package:flutter/material.dart';

import '../Types/user_type.dart';
import '../api/users_repository.dart';
import '../homepage.dart';
import '../util.dart';
import '../utils/extensions/EmailValidatorExtensions.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  SignupFormState createState() {
    return SignupFormState();
  }
}

class SignupFormState extends State<SignupForm> {
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  UserType userTypeValue = UserType.PLAYER;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  // Formatting and functionality of the signup page
  Widget build(BuildContext context) {
    // Text fields that let the user enter first name, last name, email, and password
    return Form(
      key: formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: TextFormField(
              controller: firstNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a first name";
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: "First Name",
                prefixIcon: Icon(Icons.abc, color: Colors.black),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: TextFormField(
              controller: lastNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a last name";
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: "Last Name",
                prefixIcon: Icon(Icons.abc, color: Colors.black),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: TextFormField(
              controller: emailController,
              validator: (value) {
                if ((value == null || value.isEmpty) || value?.isValidEmail() != true) {
                  return "Please enter a valid email";
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: "Email",
                prefixIcon: Icon(Icons.mail, color: Colors.black),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: TextFormField(
              controller: passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a password";
                }
                return null;
              },
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "Password",
                prefixIcon: Icon(Icons.lock, color: Colors.black),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: TextFormField(
              controller: confirmPasswordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a password";
                }
                if (value != passwordController.text) {
                  return "Passwords do not match";
                }
                return null;
              },
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "Confirm Password",
                prefixIcon: Icon(Icons.lock, color: Colors.black),
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              SizedBox(
                width: 10,
              ), //SizedBox
              Text(
                'Player',
                style: TextStyle(fontSize: 17.0),
              ), //Text//SizedBox
              Checkbox(
                value: this.userTypeValue == UserType.PLAYER,
                onChanged: (bool? value) {
                  setState(() => this.userTypeValue = UserType.PLAYER);
                },
              ),
              SizedBox(width: 10),
              Text(
                'Family',
                style: TextStyle(fontSize: 17.0),
              ), //Text
              Checkbox(
                value: this.userTypeValue == UserType.FAMILY,
                onChanged: (bool? value) {
                  setState(() => this.userTypeValue = UserType.FAMILY);
                },
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: RawMaterialButton(
              fillColor: const Color(0xFF216067),
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  try {
                    var email = emailController.value.text;
                    var password = passwordController.value.text;
                    await UsersRepository.signup(firstNameController.value.text,
                        lastNameController.value.text, email, password, userTypeValue);
                    clear();
                    if (await Util.login(email, password) && mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                          (r) => false);
                      // Error handling for not being able to login
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Login failed.')));
                    }
                    // Error handling for not being able to register
                  } on Exception {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Register failed.')));
                  }
                }
              },
              // button to signup with the inputted information
              child: const Text(
                "Sign-up",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  clear() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }
}
