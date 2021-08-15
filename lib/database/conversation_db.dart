part of 'index.dart';

extension ConvDB on Database {
  Future<String> addConversation(List<String> uids,
      {ConvType type = ConvType.PRIVATE}) async {
    assert(uids.length > 0);
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw UnauthorizedException();
      }
      final convDoc = convCol.doc();
      final userDoc = userCol.doc(currentUser.uid);
      final friendDoc = userCol.doc(uids.first);

      final id = convDoc.id;

      await _firestore.runTransaction((transaction) async {
        try {
          final user = await transaction.get(userDoc);
          final friend = await transaction.get(friendDoc);

          transaction
              .set(
            convDoc,
            Conversation(
              id: id,
              createdAt: Timestamp.now(),
              type: type,
              users: [for (var uid in uids) userCol.doc(uid), userDoc],
              logo: friend.data()!.photoUrl,
            ),
          )
              .update(userDoc, {
            'conversations': [
              id,
              if (user.data()?.conversations != null)
                ...user.data()!.conversations!
            ],
          }).update(friendDoc, {
            'conversations': [
              id,
              if (user.data()?.conversations != null)
                ...user.data()!.conversations!
            ],
          });
        } catch (e, s) {
          return Future.error(e, s);
        }
      });

      await _batch.commit();
      return id;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<Conversation>> getConversationByUser(User currentUser) async {
    try {
      final snapshot = await convCol
          .where('users', arrayContains: userCol.doc(currentUser.uid))
          .get();
      return snapshot.docs.map((e) => e.data()).toList();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Conversation> getConversationById(String id) async {
    try {
      final snapshot = await convCol.doc(id).get();
      return snapshot.data()!;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Stream<List<Conversation>> getConversationStreamByUser() async* {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw UnauthorizedException();
      }
      final snapshot =
          convCol.where('users', arrayContains: currentUser.uid).snapshots();
      // return snapshot.map((e) => e.docs.map((e) => e.data()).toList());
      await for (var item in snapshot) {
        yield item.docs.map((e) => e.data()).toList();
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> deleteConversation() async {}
}
