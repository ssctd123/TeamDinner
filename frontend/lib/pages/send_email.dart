import 'package:flutter/material.dart';
import 'package:TeamDinner/api/teams_repository.dart';
import 'package:TeamDinner/api/users_repository.dart';
import '../Types/team.dart';
import '../Types/user.dart';
import 'package:url_launcher/url_launcher.dart';


class SendEmail extends StatefulWidget {
  const SendEmail({Key? key}) : super(key: key);

  @override
  State<SendEmail> createState() => _SendEmailState();

}

class _SendEmailState extends State<SendEmail> {
  final formKey = GlobalKey<FormState>();
  final payorEmail = TextEditingController();
  final senderEmail = TextEditingController();
  late List<Team> teams = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      asyncInit();
    });
  }

  asyncInit() async {
    List<Team> teams = await TeamsRepository.getInvitesForUser(null);
    setState(() {
      this.teams = teams;
    });
  }

  void sendEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: payorEmail.text,
      query: 'subject=Someone wants to join your TeamDinner team&body=Hello, this is a reminder that ${senderEmail.text} is waiting to join your team'
    );

    payorEmail.clear();
    senderEmail.clear();

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      throw 'Could not send email';
    }
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Send Email',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextField(
                      controller: payorEmail,
                      decoration: InputDecoration(labelText: 'Recipient Email'),
                    ),
                    TextField(
                      controller: senderEmail,
                      decoration: InputDecoration(labelText: 'Sender Name'),
                    ),
                    SizedBox(height: 32),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF3CBD9F)),
                      ),
                      onPressed: sendEmail,
                      child: Text('Send Email'),
                    ),
                  ],
                )
            )
        )
    );
  }
}
