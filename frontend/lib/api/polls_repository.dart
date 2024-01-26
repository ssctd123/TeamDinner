import 'dart:convert';

import 'package:TeamDinner/Types/poll_results.dart';
import 'package:TeamDinner/Types/poll_stage.dart';
import 'package:http/http.dart' as http;

import '../Types/Poll.dart';
import '../Types/vote.dart';
import '../util.dart';
import 'base_repository.dart';

/* Repository for polls; stores descriptions and behaviors of the poll object */
class PollsRepository extends BaseRepository {
  static final Map<String, String> headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };
  static const String repositoryName = "polls";

  /* Waiting for creator to send in poll */
  static Future<Poll> get(String id) async {
    final response = await http.get(
      Uri.parse("${BaseRepository.baseUrl}/$repositoryName?id=$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${(await Util.getAccessToken())!.token}"
      },
    );
    /* Error handling for no poll */
    if (response.statusCode == 200) {
      Poll poll = Poll.fromJson(json.decode(response.body));
      return poll;
    } else {
      throw Exception('Poll not found.');
    }
  }

  /* Handling poll results that are sent in */
  static Future<PollResults> getResults(String id) async {
    final response = await http.get(
      Uri.parse("${BaseRepository.baseUrl}/$repositoryName/results?id=$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${(await Util.getAccessToken())!.token}"
      },
    );
    /* Error handling no poll results */
    if (response.statusCode == 200) {
      PollResults results = PollResults.fromJson(json.decode(response.body));
      return results;
    } else {
      throw Exception('Poll Results not found.');
    }
  }

  /* creating the poll, with all attributes (topic, description, time, location, isMultichoice, options */
  static Future<Poll> create(Poll poll) async {
    final response = await http.post(
      Uri.parse("${BaseRepository.baseUrl}/$repositoryName/create"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${(await Util.getAccessToken())!.token}"
      },
      body: jsonEncode(<String, dynamic>{
        'topic': poll.topic,
        "description": poll.description,
        "time": poll.time.toIso8601String(),
        "location": poll.location,
        "isMultichoice": poll.isMultipleChoice,
        "isQuantityEnabled": poll.isQuantityEnabled,
        "options": poll.options.map((e) => e.option).toList()
      }),
    );
    /* Error handling cannot create poll */
    if (response.statusCode == 201) {
      return Poll.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create poll.');
    }
  }

  /* Waiting for poll vote info to be sent in for processing, pollId, userId, optionIds */
  static Future<Poll> vote(String pollId, Vote vote) async {
    final response = await http.post(
      Uri.parse("${BaseRepository.baseUrl}/$repositoryName/vote"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${(await Util.getAccessToken())!.token}"
      },
      body: jsonEncode(<String, dynamic>{
        "pollId": pollId,
        "userId": vote.userId,
        "optionIds": vote.optionIds,
        "quantities": vote.quantities,
      }),
    );
    /* Error handling no votes for the poll */
    if (response.statusCode == 201) {
      return Poll.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to vote on poll.');
    }
  }

  /* There is a poll currently running */
  static Future<Poll> startPoll(String pollId) async {
    return changeStage(pollId, PollStage.IN_PROGRESS);
  }

  /* Current poll has been completed */
  static Future<Poll> endPoll(String pollId) async {
    return changeStage(pollId, PollStage.FINISHED);
  }

  /* Change the stage of the current poll, i.e. in progress or finished */
  static Future<Poll> changeStage(String pollId, PollStage stage) async {
    final response = await http.post(
      Uri.parse("${BaseRepository.baseUrl}/$repositoryName/stage"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${(await Util.getAccessToken())!.token}"
      },
      body:
          jsonEncode(<String, dynamic>{"pollId": pollId, "stage": stage.name}),
    );
    /* Error handling no votes for poll */
    if (response.statusCode == 201) {
      return Poll.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to vote on poll.');
    }
  }

  /* Handles splitting payment after poll has been completed */
  static Future<double> split(String pollDesc, double amount) async {
    final response = await http.post(
      Uri.parse("${BaseRepository.baseUrl}/$repositoryName/split"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${(await Util.getAccessToken())!.token}"
      },
      body: jsonEncode(<String, dynamic>{
        "pollDesc": pollDesc,
        "amount": amount
      }),
    );

    /* Error handling not able to split payments */
    if (response.statusCode == 201) {
      return json.decode(response.body)["tip"] * 1.0;
    } else {
      throw Exception('Failed to split payments.');
    }
  }
}
