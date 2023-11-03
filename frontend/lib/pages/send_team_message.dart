import 'package:flutter/material.dart';
import 'package:TeamDinner/api/messages_repository.dart';


class SendTeamMessagePage extends StatefulWidget {
  const SendTeamMessagePage({Key? key}) : super(key: key);

  @override
  State<SendTeamMessagePage> createState() => _SendTeamMessagePage();

}

class _SendTeamMessagePage extends State<SendTeamMessagePage> {

  final formKey = GlobalKey<FormState>();
  TimeOfDay time =
  TimeOfDay.fromDateTime(DateTime.now().add(const Duration(hours: 1)));
  TextEditingController messageContent = TextEditingController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF045D5D),
        centerTitle: true,
        title: const Text('Send Team Message'),
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
                    messageContent, "Enter message...", Icons.message),
                SizedBox(
                  width: double.infinity,
                  child: RawMaterialButton(
                    fillColor: const Color(0xFF045D5D),
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        MessagesRepository.create(messageContent.text);
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(
                      "Send Message",
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
