import 'package:TeamDinner/pages/members.dart';
import 'package:flutter/material.dart';
import 'package:TeamDinner/pages/profile.dart';
import 'package:TeamDinner/pages/teams.dart';
import 'package:TeamDinner/widgets/nav_drawer.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'Types/team.dart';
import 'Types/user.dart';
import 'Types/user_type.dart';
import 'api/teams_repository.dart';
import 'api/users_repository.dart';
import 'pages/help_page.dart';

class HomePage extends StatefulWidget {
  bool? wasPasswordReset;
  HomePage({Key? key, this.wasPasswordReset}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

int _selectedIndex = 0;
const List<Widget> _widgetOptions = <Widget>[
  TeamPage(),
  MembersPage(),
  ProfilePage(),
];

User currentUser = User("", "", "", "");
Team team = Team("", "", "", [], [], []);
bool isOwner = false;

// Basic layout of the homepage
class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    if (widget.wasPasswordReset == true) {
      Future.delayed(Duration.zero, () => showAlert(context));
    }
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
      drawer: FutureBuilder(
        future: _getInformation(),
        builder: (context, snapshot) {
          return NavDrawer(
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
            team: team,
            isFamilyAccount: currentUser.userType == UserType.FAMILY,
            isOwner: isOwner,
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
                icon: Icons.groups,
                text: 'Team',
                backgroundColor: Color(0xFFEAB541),
              ),
              GButton(
                icon: Icons.people,
                text: 'Members',
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

  void showAlert(BuildContext context) {
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
        _selectedIndex = 2;
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Password Reset!"),
      content: Text("Your password has been resetted. Please update it on the profile page."),
      actions: [
        okButton,
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        }
    );
  }

  Future<void> _getInformation() async {
    currentUser = await UsersRepository.get(null);
    team = await TeamsRepository.getMembersTeam(currentUser.id);
    isOwner = team.owners.contains(currentUser.id);

    List<User> members = [];
    for (var member in team.members) {
      if (member["id"] == currentUser.id) {
        currentUser.setDebt(member["debt"]);
      }
      User memberUser = await UsersRepository.get(member["id"]);
      memberUser.setDebt(member["debt"]);
      members.add(memberUser);
    }
    team.setMembers(members);
    if (team.owners.contains(currentUser.id)) {
      isOwner = true;
      List<User> invitations = [];
      for (var invitation in team.invitations) {
        invitations.add(await UsersRepository.get(invitation));
      }
      team.setInvitations(invitations);
    }
  }
}
