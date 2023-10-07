class Location {
  String id;
  String name;
  String time;
  String teamId;

  Location(this.id, this.name, this.time, this.teamId);

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      json['id'],
      json['name'],
      json['time'],
      json['teamId'],
    );
  }
}
