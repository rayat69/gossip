import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gossip/database/index.dart';
import 'package:gossip/mock/converters.dart';
import 'package:gossip/mock/user_model.dart';

part 'conversation.freezed.dart';
part 'conversation.g.dart';

@freezed
class Conversation with _$Conversation, EquatableMixin {
  Conversation._();

  @Assert(
    'users.length >= 2',
    'There must be atleast 2 users in a conversation',
  )
  @Assert(
    'type == ConvType.GROUP || users.length == 2',
    'Private conversations can only have 2 users',
  )
  factory Conversation({
    @JsonKey(toJson: toNull, includeIfNull: true) required String id,
    @UserReferenceConverter()
        required List<DocumentReference<FirestoreUser>> users,
    @TimestampEpochConverter() required Timestamp createdAt,
    String? logo,
    @Default(ConvType.PRIVATE) ConvType type,
  }) = _Conversation;

  factory Conversation.fromJson(
          DocumentSnapshot<Map<String, Object?>> snapshot) =>
      _$ConversationFromJson({
        'id': snapshot.id,
        ...snapshot.data()!,
      });

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [id, users, createdAt, type, logo];

  static List<String> _usersToJson(
          List<DocumentReference<FirestoreUser>> object) =>
      object.map((e) => e.id).toList();

  static List<DocumentReference<FirestoreUser>> _usersFromJson(
          List<String> json) =>
      json.map((e) => Database.instance.userCol.doc(e)).toList();
}

enum ConvType {
  @JsonValue(0)
  PRIVATE,
  @JsonValue(1)
  GROUP,
}

extension ConvTypeVal on ConvType {
  int get val => this.index;

  static ConvType type(int index) => ConvType.values.elementAt(index);
}
