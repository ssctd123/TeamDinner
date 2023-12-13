import 'package:flutter/material.dart';

import '../api/users_repository.dart';

class NumberOfParticipantsPage extends StatefulWidget {
  const NumberOfParticipantsPage({Key? key}) : super(key: key);

  @override
  State<NumberOfParticipantsPage> createState() => _NumberOfParticipantsPage();

}

class _NumberOfParticipantsPage extends State<NumberOfParticipantsPage> {

  final formKey = GlobalKey<FormState>();
  TextEditingController numberOfParticipants = TextEditingController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF045D5D),
        centerTitle: true,
        title: const Text('Number of Participants'),
      ),
      resizeToAvoidBottomInset: false,
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                buildTextField(
                    numberOfParticipants, "How many people in your party participated in the meal?", Icons.people),
                SizedBox(
                  width: double.infinity,
                  child: RawMaterialButton(
                    fillColor: const Color(0xFF045D5D),
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        Map<String, dynamic> updates = {
                          'numberOfParticipants': int.parse(numberOfParticipants.value.text)
                        };
                        updates.removeWhere((key, value) =>
                        value == null ||
                            (value is String && value.isEmpty));
                        UsersRepository.modify(updates);
                        //LocationsRepository.create(meetingLocation.text, meetingTime.text);
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(
                      "Submit",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      TextEditingController controller, String hintText, IconData icon,
      [Function()? onTap]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter a $hintText";
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon, color: Colors.black),
        ),
        onTap: onTap,
      ),
    );
  }
}