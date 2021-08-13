part of 'index.dart';

mixin UserDB on Database {
  Future<void> addUser() async {
    try {
      await userCol
          .doc(_auth.currentUser!.uid)
          .set(FirestoreUser.fromUser(_auth.currentUser!));
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteUser(User user) async {
    try {
      await userCol.doc(_auth.currentUser!.uid).delete();
    } catch (e) {
      print(e);
    }
  }
}
