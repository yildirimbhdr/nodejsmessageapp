class Message {
  final String message;
  final String senderUsername;
  final String receiverUsername;
  final int konusmaId;
  final DateTime sentAt;

  Message(
      {required this.message,
      required this.receiverUsername,
      required this.konusmaId,
      required this.senderUsername,
      required this.sentAt});
  factory Message.fromJson(Map<String, dynamic> message) {
    return Message(
        message: message['message'],
        konusmaId: message['konusmaId'],
        receiverUsername: message['receiverUsername'],
        senderUsername: message['senderUsername'],
        sentAt: DateTime.fromMillisecondsSinceEpoch(message['sentAt'] * 1000));
  }
}
