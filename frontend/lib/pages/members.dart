import 'package:flutter/material.dart';

import '../Types/team.dart';
import '../Types/user.dart';
import '../api/teams_repository.dart';
import '../api/users_repository.dart';


class MembersPage extends StatefulWidget {
  const MembersPage({Key? key}) : super(key: key);

  @override
  State<MembersPage> createState() => _MembersPage();

}

class _MembersPage extends State<MembersPage> {

  List<User> memberList = [];
  User currentUser = User("", "", "", "");
  Team team = Team("", "", "", [], [], []);
  bool isOwner = false;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder(
            future: getInformation(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: getMemberInfo(),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }

  List<Widget> getMemberInfo() {
    List<Widget> widgets = [];

    for (var element in memberList) {
      widgets.add(Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("${element.firstName} ${element.lastName}",
                    style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left
                ),
                if (team.owners.contains(element.id))
                  const Text("Team Lead",
                      style: const TextStyle(fontSize: 14, color: Colors.black,),
                      textAlign: TextAlign.left
                  ),
                Container(height: 5),
                Text("${element.email}",
                    style: const TextStyle(fontSize: 12, color: Colors.black, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.left
                ),
                const Divider(),
              ],
            ),
            if (isOwner && (!team.owners.contains(element.id)))
              SizedBox(
                width: 120,
                height: 35,
                child: RawMaterialButton(
                  fillColor: const Color(0xFF045D5D),
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  onPressed: () async {
                    team.owners.add(element.id);
                    Map<String, dynamic> updates = {
                      'owners': team.owners
                    };
                    await TeamsRepository.update(team.name, updates);
                    setState(() {});
                  },
                  child: Text(
                    "Assign Team Lead",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            if (team.owners.contains(element.id) && element.id != currentUser.id)
              SizedBox(
                width: 120,
                height: 35,
                child: RawMaterialButton(
                  fillColor: Colors.red[300],
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  onPressed: () async {
                    team.owners.remove(element.id);
                    Map<String, dynamic> updates = {
                      'owners': team.owners
                    };
                    await TeamsRepository.update(team.name, updates);
                    setState(() {});
                  },
                  child: Text(
                    "Remove Team Lead",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
          ],
        )
      ));
    }

    /*
    Text("$name: ${quantityResult.quantity}",
            style: const TextStyle(fontSize: 16, color: Colors.black))
     */
    return widgets;
  }

  Future<List<User>> getInformation() async {
    memberList = [];
    currentUser = await UsersRepository.get(null);

    team = await TeamsRepository.getMembersTeam(currentUser.id);
    isOwner = team.owners.contains(currentUser.id);

    for (var member in team.members) {
      memberList.add(await UsersRepository.get(member['id']));
    }
    return memberList;
  }
}
