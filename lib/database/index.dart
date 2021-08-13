import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gossip/models/conversation.dart';
import 'package:gossip/models/message_model.dart';
import 'package:gossip/models/user_model.dart' show FirestoreUser;

part 'user_db.dart';
part 'conversation_db.dart';
part 'message_db.dart';

class Database {
  late CollectionReference<FirestoreUser> userCol;
  late CollectionReference<Conversation> convCol;
  late CollectionReference<FirestoreMessage> msgCol;

  late final FirebaseFirestore _firestore;
  late final FirebaseAuth _auth;

  Database._() {
    _firestore = FirebaseFirestore.instance;
    _auth = FirebaseAuth.instance;

    userCol = _firestore.collection('users').withConverter<FirestoreUser>(
          fromFirestore: (snapshot, _) =>
              FirestoreUser.fromJson(snapshot.data()!, snapshot.id),
          toFirestore: (model, _) => model.toJson(),
        );
    convCol =
        _firestore.collection('conversations').withConverter<Conversation>(
              fromFirestore: (snapshot, _) {
                return Conversation.fromJson(snapshot.data()!, snapshot.id);
              },
              toFirestore: (model, _) => model.toJson(),
            );
    msgCol = convCol.doc().collection('messages').withConverter(
          fromFirestore: (snapshot, _) {
            return FirestoreMessage.fromJson(snapshot.data()!, snapshot.id);
          },
          toFirestore: (model, _) => model.toJson(),
        );
  }

  static get instance => Database._();
}
