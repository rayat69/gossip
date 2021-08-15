import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gossip/database/index.dart';
import 'package:gossip/mock/conversation.dart';
import 'package:gossip/mock/converters.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class FirestoreUser with _$FirestoreUser, EquatableMixin {
  FirestoreUser._();

  factory FirestoreUser({
    required String id,
    required String email,
    @ConversationReferenceConverter()
        List<DocumentReference<Conversation>>? conversations,
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
  }) = _FirestoreUser;

  factory FirestoreUser.fromJson(
          DocumentSnapshot<Map<String, Object?>> snapshot) =>
      _$FirestoreUserFromJson({'id': snapshot.id, ...snapshot.data()!});

  factory FirestoreUser.fromUser(User user) => FirestoreUser(
        id: user.uid,
        displayName: user.displayName,
        email: user.email!,
        photoUrl: user.photoURL,
        phoneNumber: user.phoneNumber,
        conversations: const [],
      );

  @override
  List<Object?> get props => [displayName, email, photoUrl, phoneNumber];

  @override
  bool? get stringify => true;

  static List<String> _conversationsToJson(
          List<DocumentReference<Conversation>> object) =>
      object.map((e) => e.id).toList();

  static List<DocumentReference<Conversation>> _conversationsFromJson(
          List json) =>
      json.map((e) => Database.instance.convCol.doc(e.toString())).toList();
}
