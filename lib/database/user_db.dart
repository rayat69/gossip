part of 'index.dart';

extension UserDB on Database {
  Future<void> addUser(User currentUser) async {
    try {
      await userCol
          .doc(currentUser.uid)
          .set(FirestoreUser.fromUser(currentUser));
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteUser(User currentUser) async {
    try {
      await userCol.doc(currentUser.uid).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<FirestoreUser> user(User currentUser) async {
    try {
      final snapshot = await userCol.doc(currentUser.uid).get();
      return snapshot.data()!;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<bool> userExists(String id) async {
    try {
      final snapshot = await userCol.doc(id).get();
      return snapshot.exists;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<FirestoreUser>> searchUserByEmail(String email) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    try {
      if (currentUser == null) {
        throw UnauthorizedException();
      }
      RegExp('source', caseSensitive: false, multiLine: false)
          .hasMatch('input');
      final snapshot = await userCol
          .where(
            'email',
            isEqualTo: email,
            isNotEqualTo: currentUser.email,
          )
          .get();
      return snapshot.docs.map((e) => e.data()).toList();
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
