import 'package:flutter/material.dart';
import 'package:TeamDinner/pages/polls.dart';
import 'package:TeamDinner/pages/profile.dart';
import 'package:TeamDinner/pages/teams.dart';
import 'package:TeamDinner/widgets/nav_drawer.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'pages/help_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

int _selectedIndex = 0;
const List<Widget> _widgetOptions = <Widget>[
  TeamPage(),
  PollsPage(),
  ProfilePage(),
];

// Basic layout of the homepage
class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: const Color(0xFF045D5D),
        elevation: 0,
        centerTitle: true,
        title: const Text('T e a m   D i n n e r'),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.help_outline),
                onPressed: () {
                  // Go to help_page.dart
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HelpButton()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      drawer: NavDrawer(
        onSwitchTab: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        onNavigate: (page) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return page;
                },
              ),
          );
        },
      ),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 20,
          ),
          // Navigation bar to go to other pages team page, poll page, and profile page
          child: GNav(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.white,
            padding: const EdgeInsets.all(16),
            gap: 8,
            tabs: const [
              GButton(
                icon: Icons.group,
                text: 'Team',
                backgroundColor: Color(0xFFEAB541),
              ),
              GButton(
                icon: Icons.poll,
                text: 'Poll',
                backgroundColor: Color(0xFF9E3531),
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
                backgroundColor: Color(0xFF045F5F),
              ),
              //GButton(icon: Icons.people),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
