import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gossip/database/index.dart';
import 'package:gossip/mock/user_model.dart';
import 'package:gossip/mock/conversation.dart';

class TimestampEpochConverter implements JsonConverter<Timestamp, Timestamp> {
  const TimestampEpochConverter();

  @override
  Timestamp fromJson(Timestamp json) => json;

  @override
  Timestamp toJson(Timestamp object) => object;
}

class IdConverter implements JsonConverter<String, Null> {
  const IdConverter();

  @override
  String fromJson(Null json) => 'id';

  @override
  Null toJson(String object) => null;
}

class UserReferenceConverter
    implements
        JsonConverter<List<DocumentReference<FirestoreUser>>, List<String>> {
  const UserReferenceConverter();

  @override
  List<DocumentReference<FirestoreUser>> fromJson(List<String> json) {
    return json
        .map((e) => Database.instance.userCol.doc(e.toString()))
        .toList();
  }

  @override
  List<String> toJson(List<DocumentReference<FirestoreUser>> object) {
    return object.map((e) => e.id).toList();
  }
}

class ConversationReferenceConverter
    implements
        JsonConverter<List<DocumentReference<Conversation>>?, List<String>?> {
  const ConversationReferenceConverter();

  @override
  List<DocumentReference<Conversation>>? fromJson(List<String>? json) {
    return json
        ?.map((e) => Database.instance.convCol.doc(e.toString()))
        .toList();
  }

  @override
  List<String>? toJson(List<DocumentReference<Conversation>>? object) {
    return object?.map((e) => e.id).toList();
  }
}

Null toNull(_) => null;
