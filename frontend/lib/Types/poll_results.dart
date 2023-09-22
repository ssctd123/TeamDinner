// Initialization of poll results
import 'dart:collection';

import 'package:frontend/Types/quantity_result.dart';

class PollResults {
  Map<String, int> results;
  Map<String, List<dynamic>> quantityResults;

  PollResults(this.results, this.quantityResults);

  factory PollResults.fromJson(Map<String, dynamic> json) {
    Map<String, List<dynamic>> quantityResults = {};
    json['quantityResults'].forEach((key, value) {
      quantityResults[key] = List.from(value).map((e) => QuantityResult.fromJson(e)).toList();
    });
    return PollResults(
        HashMap.from(json["results"]),
        quantityResults
    );
  }
}
