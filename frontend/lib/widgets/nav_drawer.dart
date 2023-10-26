import 'package:flutter/material.dart';
import '../pages/notify_location_time.dart';
import '../pages/polls.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key? key, this.onSwitchTab, this.onNavigate}) : super(key: key);
  final ValueChanged<int>? onSwitchTab;
  final ValueChanged<StatefulWidget>? onNavigate;
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
            title: const Text('Create Menu Choices Poll'),
            onTap: () => {
              Navigator.of(context).pop(),
              onNavigate?.call(menuChoicesPollPage),
            },
          ),
          ListTile(
            leading: const Icon(Icons.poll),
            title: const Text('Create Final Selections Poll'),
            onTap: () => {
              Navigator.of(context).pop(),
              onNavigate?.call(finalSelectionsPollPage),
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_city),
            title: const Text('Notify Location and Time'),
            onTap: () => {
              Navigator.of(context).pop(),
              onNavigate?.call(const NotifyLocationTimePage()),
            },
          ),
        ],
      ),
    );
  }
}