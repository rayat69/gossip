part of 'index.dart';

extension MsgDB on Database {
  Future<void> sendMessage(String convId, String message) async {
    try {
      final msgDoc = msgCol(convId).doc();
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

  Future<List<FirestoreMessage>?> messages(String convId) async {
    try {
      final snapshot = await msgCol(convId).get();
      final docs = snapshot.docs;
      if (docs.isEmpty || docs.length == 0) {
        return [];
      }
      return docs.map((e) => e.data()).toList();
    } catch (e) {
      print(e);
    }
  }
}
