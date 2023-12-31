import 'package:flutter/material.dart';
import 'package:frontend/api/teams_repository.dart';
import 'package:frontend/api/users_repository.dart';

import '../Types/team.dart';
import '../Types/user.dart';

class InviteForm extends StatefulWidget {
  final Team team;

  const InviteForm({Key? key, required this.team}) : super(key: key);

  @override
  State<InviteForm> createState() => _InviteFormState();
}

class _InviteFormState extends State<InviteForm> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  late Team team;

  @override
  void initState() {
    super.initState();
    team = widget.team;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: IconButton(
                  color: Colors.deepPurple[300],
                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                ),
              ),
            ),
            Visibility(
              visible: team.invitations.isNotEmpty,
              child: Column(
                children: getInvitations(),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Invite team members",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter an email";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: "Email",
                        prefixIcon: Icon(Icons.email, color: Colors.black),
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
                          var email = emailController.value.text;
                          try {
                            Team team = await TeamsRepository.invites(
                                this.team.id, email);
                            emailController.clear();

                            for (var element in this.team.invitations) {
                              team.invitations.remove(element.id);
                            }
                            if (team.invitations.isNotEmpty) {
                              User newMember = await UsersRepository.get(
                                  team.invitations[0]);
                              setState(() {
                                this.team.invitations.add(newMember);
                              });
                            }
                            if (mounted) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Invite sent"),
                              ));
                            }
                          } on Exception {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Failed to invite member"),
                                ),
                              );
                            }
                          }
                        }
                      },
                      child: const Text(
                        "Invite",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  getInvitations() {
    List<Widget> widgets = [
      const Text(
        "Invitations:",
        style: TextStyle(
          color: Colors.black,
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
        ),
      )
    ];
    widgets.addAll(List.generate(team.invitations.length, (index) {
      return Row(
        children: [
          Text(team.invitations[index].toString()),
          IconButton(
            onPressed: () async {
              var user = team.invitations[index];
              try {
                await TeamsRepository.rejectInvites(team.id, user.id);
                setState(() {
                  team.invitations.remove(user);
                });
              } on Exception {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Failed to remove invite.")));
              }
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      );
    }));
    return widgets;
  }
}
