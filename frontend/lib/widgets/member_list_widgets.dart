import 'package:flutter/material.dart';
import 'package:frontend/api/teams_repository.dart';
import 'package:intl/intl.dart';

import '../Types/team.dart';

class MemberListWidget extends StatefulWidget {
  final Team team;

  const MemberListWidget({Key? key, required this.team}) : super(key: key);

  @override
  State<MemberListWidget> createState() => _MemberListWidgetState();
}

class _MemberListWidgetState extends State<MemberListWidget> {
  final controllers = [];
  final teamNameController = TextEditingController();
  final descriptionController = TextEditingController();
  late Team team;

  @override
  void initState() {
    super.initState();
    team = widget.team;
  }

  // Format of user payments
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
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
            // Title of the page
            const Text(
              "Log Member Payments",
              style: TextStyle(
                color: Colors.black,
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Text field to enter how much the user has paid
            SingleChildScrollView(
              child: Column(
                children: List.generate(team.members.length, (index) {
                  final controller = TextEditingController();
                  final formKey = GlobalKey<FormState>();
                  double debt = 0;
                  try {
                    debt = team.members[index].debt * 1.0 ?? 0.0;
                  } on Exception {
                    debt = 0.0;
                  }
                  controllers.add(controller);
                  return Container(
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              width: 150,
                              child: Text(team.members[index].toString(),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1),
                            ),
                            SizedBox(
                              width: 150,
                              child: Text(
                                  "Debt: ${NumberFormat.simpleCurrency().format(debt)}",
                                  textAlign: TextAlign.left),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 75,
                          child: Form(
                            key: formKey,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: TextFormField(
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                controller: controller,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Enter value";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            if (!formKey.currentState!.validate()) {
                              return;
                            }
                            var user = team.members[index];
                            try {
                              final payment = double.parse(controller.text);
                              await TeamsRepository.pay(
                                  team.id, user.id, payment);
                              setState(() {
                                team.members[index].debt -= payment;
                              });
                              controller.clear();
                              // Error handling for not being able to reduce the users debt
                            } on Exception {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Failed to reduce debt.")));
                            }
                          },
                          icon: const Icon(Icons.send, color: Colors.green),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
