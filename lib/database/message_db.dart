part of 'index.dart';

extension MsgDB on Database {
  Future<void> sendMessage(String message) async {
    try {
      final msgDoc = msgCol.doc();
      final id = msgDoc.id;
      await msgDoc.set(FirestoreMessage(
        id: id,
        sender: _auth.currentUser!.uid,
        time: Timestamp.now(),
        text: message,
        isLiked: false,
        unread: true,
      ));
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  Future<List<FirestoreMessage>> get  messages async {
    try
  }
}
