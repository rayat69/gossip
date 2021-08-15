import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gossip/mock/conversation.dart';
import 'package:gossip/mock/message_model.dart';
import 'package:gossip/mock/user_model.dart';
// import 'package:gossip/models/conversation.dart';
// import 'package:gossip/models/message_model.dart';
// import 'package:gossip/models/user_model.dart' show FirestoreUser;
import 'package:gossip/utils/exceptions.dart';
// import 'package:string_validator/string_validator.dart';

part 'user_db.dart';
part 'conversation_db.dart';
part 'message_db.dart';

class Database {
  late CollectionReference<FirestoreUser> userCol;
  late CollectionReference<Conversation> convCol;

  late final FirebaseFirestore _firestore;
  late final FirebaseAuth _auth;
  late final WriteBatch _batch;

  Database._() {
    _firestore = FirebaseFirestore.instance;
    _auth = FirebaseAuth.instance;
    _batch = _firestore.batch();

    final _text = _firestore.collection('test').doc('gossip');

    userCol = _text.collection('users').withConverter<FirestoreUser>(
          fromFirestore: (snapshot, _) => FirestoreUser.fromJson(snapshot),
          // FirestoreUser.fromJson(snapshot.data()!, snapshot.id),
          toFirestore: (model, _) => model.toJson(),
        );
    convCol = _text.collection('conversations').withConverter<Conversation>(
          fromFirestore: (snapshot, _) => Conversation.fromJson(snapshot),
          toFirestore: (model, _) => model.toJson(),
        );
  }

  CollectionReference<FirestoreMessage> msgCol(String convId) => convCol
      .doc(convId)
      .collection('messages')
      .withConverter<FirestoreMessage>(
        fromFirestore: (snapshot, _) {
          return FirestoreMessage.fromJson(snapshot);
        },
        toFirestore: (model, _) => model.toJson(),
      );

  static Database get instance => Database._();
}
