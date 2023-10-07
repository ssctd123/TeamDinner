import 'package:flutter/material.dart';
import 'package:frontend/api/locations_repository.dart';


class NotifyLocationTimePage extends StatefulWidget {
  const NotifyLocationTimePage({Key? key}) : super(key: key);

  @override
  State<NotifyLocationTimePage> createState() => _NotifyLocationTimePage();

}

class _NotifyLocationTimePage extends State<NotifyLocationTimePage> {

  final formKey = GlobalKey<FormState>();
  TimeOfDay time =
  TimeOfDay.fromDateTime(DateTime.now().add(const Duration(hours: 1)));
  TextEditingController meetingLocation = TextEditingController();
  TextEditingController meetingTime = TextEditingController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF045D5D),
          centerTitle: true,
          title: const Text('Notify Location and Time'),
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
                    meetingLocation, "Location (Where will we meet to eat?)", Icons.location_city),
                buildTextField(meetingTime, "Time (When will we meet?)", Icons.punch_clock,
                        () async {
                      FocusScope.of(context).requestFocus(FocusNode());

                      TimeOfDay? picked = await showTimePicker(
                        initialTime: TimeOfDay.now(),
                        context: context,
                      );
                      if (picked != null) {
                        meetingTime.text = picked.format(context); // add this line.
                        setState(() {
                          time = picked;
                        });
                      }
                    }),
                SizedBox(
                  width: double.infinity,
                  child: RawMaterialButton(
                    fillColor: const Color(0xFF045D5D),
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        LocationsRepository.create(meetingLocation.text, meetingTime.text);
                      }
                    },
                    child: Text(
                      "Send Notification",
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
