// Initialization of poll results
import 'dart:collection';

class PollResults {
  Map<String, int> results;
  Map<String, dynamic> quantityResults;

  PollResults(this.results, this.quantityResults);

  factory PollResults.fromJson(Map<String, dynamic> json) {
    return PollResults(
        HashMap.from(json["results"]),
        HashMap.from(json["quantityResults"])
    );
  }
}
