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
  Team team = Team("", "", "", "", [], []);
  bool isOwner = false;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF045D5D),
        centerTitle: true,
        title: const Text('Members'),
      ),
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
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("${element.firstName} ${element.lastName}",
                    style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left
                ),
                if (element.id == team.owner)
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
    var user = await UsersRepository.get(null);

    team = await TeamsRepository.getMembersTeam(user.id);
    isOwner = team.owner == user.id;

    for (var member in team.members) {
      memberList.add(await UsersRepository.get(member['id']));
    }
    return memberList;
  }
}
