import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/api/users_repository.dart';
import 'package:frontend/main.dart';
import 'package:frontend/pages/teams.dart';

import '../Types/user.dart';
import '../util.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

// Functions of the pofile page
class _ProfilePageState extends State<ProfilePage> {
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final preferredTipController = TextEditingController();
  final venmoController = TextEditingController();
  late User user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      asyncInit();
    });
  }

  Future<void> asyncInit() async {
    user = await UsersRepository.get(null);
    final tipPercent = user.tipPercent != null ? user.tipPercent * 100 : 0;
    firstNameController.text = user.firstName;
    lastNameController.text = user.lastName;
    preferredTipController.text = tipPercent.toString();
    venmoController.text = user.venmo ?? "";
    setState(() {});
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    preferredTipController.dispose();
    venmoController.dispose();
    super.dispose();
  }

  // Layout of the profile page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: formKey,
              child: Column(
                // Handling user information in profile page firstName, lastName, email, password, venmo, and tipAmount
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: TextFormField(
                      controller: firstNameController,
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
                      controller: venmoController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: "Venmo Username",
                        prefixIcon: Icon(Icons.money, color: Colors.black),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: TextFormField(
                      controller: preferredTipController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: false),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      decoration: const InputDecoration(
                        hintText: "Default Tip Percentage (e.g. 20)",
                        prefixIcon: Icon(Icons.percent, color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RawMaterialButton(
                      fillColor: Colors.deepPurple[300],
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          final email = emailController.value.text;
                          final password = passwordController.value.text;
                          double? tipAmount = double.tryParse(
                              preferredTipController.value.text);
                          if (tipAmount != null) {
                            tipAmount /= 100;
                          }
                          final loginUpdated =
                              email.isNotEmpty || password.isNotEmpty;
                          Map<String, dynamic> updates = {
                            'firstName': firstNameController.value.text,
                            'lastName': lastNameController.value.text,
                            'email': email,
                            'password': password,
                            'venmo': venmoController.value.text,
                            'tipAmount': tipAmount,
                          };
                          // handling updating the suer profiling
                          updates.removeWhere((key, value) =>
                              value == null ||
                              (value is String && value.isEmpty));
                          try {
                            await UsersRepository.modify(updates);
                            if (loginUpdated &&
                                await Util.login(email, password) &&
                                mounted) {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const TeamPage()),
                                  (r) => false);
                            } else if (loginUpdated) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Login failed.')));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Profile updated.')));
                            }
                          } on Exception {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Failed to modify user"),
                              ),
                            );
                          }
                        }
                      },
                      // button to update user profile
                      child: const Text(
                        "Update Profile",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Sign-out button

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SizedBox(
                width: double.infinity,
                child: RawMaterialButton(
                  fillColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  onPressed: () async {
                    try {
                      Util.logout();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const MyApp()),
                          (r) => false);
                    } on Exception {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Failed to logout"),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    "Sign Out",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  clear() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    passwordController.clear();
    preferredTipController.clear();
    venmoController.clear();
  }
}
