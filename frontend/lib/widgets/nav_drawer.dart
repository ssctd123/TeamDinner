import 'package:flutter/material.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key? key, this.onSwitchTab}) : super(key: key);
  final ValueChanged<int>? onSwitchTab;

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
            leading: const Icon(Icons.group),
            title: const Text('Team'),
            onTap: () => {
              onSwitchTab?.call(0),
              Navigator.of(context).pop()
            },
          ),
          ListTile(
            leading: const Icon(Icons.poll),
            title: const Text('Poll'),
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
        ],
      ),
    );
  }
}