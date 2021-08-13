part of 'index.dart';

mixin ConvDB on Database {
  Future<void> addConversation(List<String> uids,
      {ConvType type = ConvType.PRIVATE}) async {
    assert(uids.length > 0);
    try {
      final convDoc = convCol.doc();
      final userDoc = userCol.doc(_auth.currentUser!.uid);
      final id = convDoc.id;
      final user = await userDoc.get();

      final friendDoc = userCol.doc(uids.first);

      final friend = await friendDoc.get();

      final conv = convDoc.set(Conversation(
        createdAt: Timestamp.now(),
        type: type,
        users: [...uids, _auth.currentUser!.uid],
        logo: friend.data()!.photoUrl,
        recent: '',
        unread: false,
      ));

      final addConvToUser = userDoc.update({
        'conversations': [id, ...user.data()!.conversations],
      });

      await Future.wait([conv, addConvToUser]);
    } catch (e) {
      print(e);
    }
  }

  Future<List<Conversation>> getConversationByUser({
    required String uid1,
    required String uid2,
  }) async {
    try {
      final snapshot = await convCol
          .where('users', arrayContains: _auth.currentUser!.uid)
          .get();
      return snapshot.docs.map((e) => e.data()).toList();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> deleteConversation() async {}
}
