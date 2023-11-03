import 'package:TeamDinner/widgets/poll_form.dart';
import 'package:flutter/material.dart';
import 'package:TeamDinner/Types/poll_option.dart';
import 'package:TeamDinner/Types/poll_results.dart';
import 'package:TeamDinner/Types/poll_stage.dart';
import 'package:TeamDinner/Types/quantity_result.dart';
import 'package:TeamDinner/Types/vote.dart';

import '../Types/Poll.dart';
import '../Types/team.dart';
import '../api/polls_repository.dart';
import '../api/teams_repository.dart';
import '../api/users_repository.dart';
import '../widgets/create_poll_form.dart';
import '../widgets/split_bill_form.dart';
import '../helpers/PollHelper.dart';


// Poll handling and functionality page
class PollsPage extends StatefulWidget {
  const PollsPage({Key? key, this.title, this.tlPollStage}) : super(key: key);
  final String? title;
  final int? tlPollStage;

  @override
  State<PollsPage> createState() => _PollsPageState();
}

class _PollsPageState extends State<PollsPage> {
  Poll poll = Poll("", "", "", DateTime.now(), "", false, false, []);
  bool isOwner = false;
  Vote vote = Vote("","", [], null);
  bool reset = true;
  PollResults? results;
  bool pollHasBeenSplit = false;
  Map<String, String> memberNames = {};

  // Establish layout of the page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF045D5D),
        centerTitle: true,
        title: Text("Poll"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: _getPoll(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: getPollInfo(),
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      )
    );
  }

  // Getting poll information for processing
  Future<Poll> _getPoll() async {
    if (!reset) {
      pollHasBeenSplit = await PollHelper.hasPollBeenSplit(poll.id);
      return poll;
    }
    var user = await UsersRepository.get(null);
    try {
      Team memberTeam = await TeamsRepository.getMembersTeam(user.id);
      isOwner = memberTeam.owner == user.id;
      Poll poll = await PollsRepository.get(memberTeam.id + (widget.title ?? ""));
      for (var member in memberTeam.members) {
        var memberUser = await UsersRepository.get(member["id"]);
        memberNames[member["id"]] = memberUser.firstName + " " + memberUser.lastName;
      }
      if (poll.votes != null) {
        vote = poll.votes!.firstWhere((vote) => vote.userId == user.id,
            orElse: () => Vote("","", [], null));
      }
      PollResults? res;
      if (poll.stage == PollStage.FINISHED) {
        res = await PollsRepository.getResults(poll.id);
      }
      if (mounted) {
        setState(() {
          this.poll = poll;
          reset = false;
          results = res;
        });
      }

      return poll;
      // Error handling for no active poll
    } on Exception {
      setState(() {
        poll.description = "No active poll";
        reset = false;
      });
    }

    pollHasBeenSplit = await PollHelper.hasPollBeenSplit(poll.id);
    return poll;
  }

  // List of all the poll information topic, description, and stage processing
  List<Widget> getPollInfo() {
    List<Widget> widgets = [];
    widgets.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(widget.title ?? "",
          style: const TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black)),
    ));
    widgets.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(poll.description,
          style: const TextStyle(fontSize: 18, color: Colors.black)),
    ));
    switch (poll.stage) {
      case PollStage.NOT_STARTED:
        widgets.add(const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Poll has not started yet",
              style: TextStyle(fontSize: 18, color: Colors.black)),
        ));
        break;
      case null:
        break;
    }

    widgets.add(Container(height: 15,),);

    if (results != null && (results?.results.isNotEmpty == true || results?.quantityResults.isNotEmpty == true)) {
      widgets.add(const Padding(
        padding: EdgeInsets.all(6.0),
        child: Text("Results",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
      ));
      if (poll.isQuantityEnabled) {
        results!.quantityResults.forEach((key, value) {
          var quantityResultList = value as List<QuantityResult>;
          widgets.add(Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(memberNames[key] ?? "",
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
          ));

          for (var quantityResult in quantityResultList) {
            if (poll.options.any((element) => quantityResult.optionId == element.id)) {
              String name = poll.options
                  .firstWhere((element) => quantityResult.optionId == element.id,
                  orElse: () => PollOption("", ""))
                  .option;
              widgets.add(Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text("$name: ${quantityResult.quantity}",
                    style: const TextStyle(fontSize: 16, color: Colors.black)),
              ));
            }
          }
        });
      } else {
        results!.results.forEach((key, value) {
          if (poll.options.any((element) => key == element.id)) {
            String name = poll.options
                .firstWhere((element) => key == element.id,
                orElse: () => PollOption("", ""))
                .option;
            widgets.add(Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("$name: $value",
                  style: const TextStyle(fontSize: 16, color: Colors.black)),
            ));
          }
        });
      }

    } else if (poll.stage != PollStage.NOT_STARTED) {
      widgets.add(PollForm(poll: poll, submitText: widget.tlPollStage == 1 ? "Submit Selections" : "Submit Vote"));
    }
    widgets.add(Container(height: 15,),);
    if (isOwner && poll.stage != null && poll.stage != PollStage.FINISHED) {
      String text = poll.stage == PollStage.NOT_STARTED ? "Start Poll" : "End Poll";
      widgets.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
            poll.stage == PollStage.NOT_STARTED ? Colors.green : Color.fromRGBO(199, 137, 54, 1.0),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          onPressed: () async {
            if (poll.stage == PollStage.NOT_STARTED) {
              await PollsRepository.startPoll(poll.id);
            } else {
              await PollsRepository.endPoll(poll.id);
            }
            resetPage();
          },
          child: Text(text, style: const TextStyle(fontSize: 20)),
        ),
      ));
    } else if (isOwner &&
        (poll.stage == PollStage.FINISHED || poll.stage == null)) {
      widgets.add(ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9E3531),
              side: BorderSide.none,
              shape: const StadiumBorder()),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return CreatePollForm(
                topicValue: widget.title,
                descriptionValue: (widget.tlPollStage == 1) ? "Choose your final dinner selections and how many of each you want per family (including players)" : "What would you like for dinner?",
                enableMultipleMenuSelections: (widget.tlPollStage == 1) ? true : false,
                enableQuantityEntry: (widget.tlPollStage == 1) ? true : false,
              );
            })).then((value) => {resetPage()});
          },
          icon: const Icon(Icons.poll),
          label: Text((widget.tlPollStage == 1) ? 'Start Final Selections Poll' : 'Start Dinner Choices Poll',
              style: TextStyle(color: Colors.white))));
      if (poll.stage == PollStage.FINISHED && !pollHasBeenSplit && widget.tlPollStage == 1) {
        widgets.add(ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E9079),
                side: BorderSide.none,
                shape: const StadiumBorder()),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SplitBillForm(poll: poll);
              })).then((value) => {resetPage()});
            },
            icon: const Icon(Icons.monetization_on),
            label: const Text('Split Bill',
                style: TextStyle(color: Colors.white))));
      }
    }
    return widgets;
  }

  // Used to reset the poll page when finished
  resetPage() async {
    poll = Poll("", "", "", DateTime.now(), "", false, false, []);
    isOwner = false;
    vote = Vote("","", [], null);
    pollHasBeenSplit = false;
    reset = true;

    await _getPoll();
    setState(() { });
  }
}