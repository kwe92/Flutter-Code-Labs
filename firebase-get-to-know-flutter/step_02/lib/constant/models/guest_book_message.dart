class GuestBookMessage {
  final String userID;
  final String name;
  final String message;
  final String textID;

  const GuestBookMessage(
      {required this.textID,
      required this.userID,
      required this.name,
      required this.message});

  factory GuestBookMessage.fromJSON(Map<String, Object> json) =>
      GuestBookMessage(
          textID: json['textID'] as String,
          userID: json['userid'] as String,
          name: json['name'] as String,
          message: json['text'] as String);

  Map<String, Object> toJSON() {
    final int timestamp = DateTime.now().millisecondsSinceEpoch;

    return <String, Object>{
      'textID': textID,
      'text': message,
      'timestamp': timestamp,
      'name': name,
      'userid': userID,
    };
  }
}
