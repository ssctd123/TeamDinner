class Message {
  String id;
  String body;
  String teamId;
  String senderName;

  Message(this.id, this.body, this.teamId, this.senderName);

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      json['id'],
      json['body'],
      json['teamId'],
      json['senderName'],
    );
  }
}
