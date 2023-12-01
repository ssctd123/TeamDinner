import 'package:flutter/material.dart';
import '../Types/team.dart';
import '../pages/notify_location_time.dart';
import '../pages/polls.dart';
import '../pages/send_team_message.dart';
import 'member_list_widgets.dart';
import 'split_bill_form.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key? key, this.onSwitchTab, this.onNavigate, this.team, this.isOwner}) : super(key: key);
  final ValueChanged<int>? onSwitchTab;
  final ValueChanged<StatefulWidget>? onNavigate;
  final Team? team;
  final bool? isOwner;
  static const PollsPage menuChoicesPollPage = PollsPage(title: "Dinner Choices", tlPollStage: 0);
  static const PollsPage finalSelectionsPollPage = PollsPage(title: "Final Selections", tlPollStage: 1);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const SizedBox(
            height: 150.0,
            width: double.infinity,
            child: DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF045D5D)),
              child: Text(
                'Team Dinner',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Team Info'),
            onTap: () => {
              onSwitchTab?.call(0),
              Navigator.of(context).pop()
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Members'),
            onTap: () => {
              onSwitchTab?.call(1),
              Navigator.of(context).pop()
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () => {
              onSwitchTab?.call(2),
              Navigator.of(context).pop()
            },
          ),
          ListTile(
            leading: const Icon(Icons.poll),
            title: const Text('Menu Choices Poll'),
            onTap: () => {
              Navigator.of(context).pop(),
              onNavigate?.call(menuChoicesPollPage),
            },
          ),
          ListTile(
            leading: const Icon(Icons.poll),
            title: const Text('Final Selections Poll'),
            onTap: () => {
              Navigator.of(context).pop(),
              onNavigate?.call(finalSelectionsPollPage),
            },
          ),
          Visibility(
            visible: isOwner ?? false,
            child: ListTile(
              leading: const Icon(Icons.location_city),
              title: const Text('Notify Location and Time'),
              onTap: () => {
                Navigator.of(context).pop(),
                onNavigate?.call(const NotifyLocationTimePage()),
              },
            ),
          ),
          Visibility(
            visible: isOwner ?? false,
            child: ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Send Team Message'),
              onTap: () => {
                Navigator.of(context).pop(),
                onNavigate?.call(const SendTeamMessagePage()),
              },
            ),
          ),
          Visibility(
            visible: true,
            child: ListTile(
              leading: const Icon(Icons.numbers),
              title: const Text('Number of Participants'),
              onTap: () => {
                Navigator.of(context).pop(),
                //onNavigate?.call(const SendTeamMessagePage()),
              },
            ),
          ),
          Visibility(
            visible: isOwner ?? false,
            child: ListTile(
              leading: const Icon(Icons.monetization_on),
              title: const Text('Split Payment'),
              onTap: () => {
                Navigator.of(context).pop(),
                onNavigate?.call(const SplitBillForm())
              },
            ),
          ),
          Visibility(
            visible: isOwner ?? false,
            child: ListTile(
              leading: const Icon(Icons.edit_document),
              title: const Text('Log Payments'),
              onTap: () => {
                Navigator.of(context).pop(),
                onNavigate?.call(MemberListWidget(team: team ?? Team("", "", "", [], [], []))),
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help'),
            onTap: () => {
              Navigator.of(context).pop(),
              // TODO: Add Navigation to Help Page
            },
          ),
        ],
      ),
    );
  }
}