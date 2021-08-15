import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gossip/mock/converters.dart';

// import './user_model.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';

@freezed
class FirestoreMessage with _$FirestoreMessage, EquatableMixin {
  FirestoreMessage._();

  @Assert('text == null || images == null')
  @Assert('type == MessageType.TEXT && text != null && text.isNotEmpty')
  @Assert('type == MessageType.IMAGE && images != null && images.isNotEmpty')
  factory FirestoreMessage({
    @JsonKey(toJson: toNull, includeIfNull: true) required String id,
    required String sender,
    @TimestampEpochConverter() required Timestamp time,
    required bool isLiked,
    required bool unread,
    @Default(MessageType.TEXT) MessageType type,
    String? text,
    List<String>? images,
  }) = _FirebaseMessage;

  factory FirestoreMessage.newConv(String sender, String id) =>
      _$FirestoreMessageFromJson({
        'id': id,
        'sender': sender,
        'time': Timestamp.now(),
        'isLiked': false,
        'unread': false,
      });

  factory FirestoreMessage.fromJson(
          DocumentSnapshot<Map<String, Object?>> snapshot) =>
      _$FirestoreMessageFromJson({'id': snapshot.id, ...snapshot.data()!});

  @override
  List<Object?> get props => [id, sender, time, text, isLiked, unread];

  @override
  bool? get stringify => true;
}

enum MessageType {
  @JsonValue(0)
  TEXT,
  @JsonValue(1)
  IMAGE,
}

extension MessageTypeVal on MessageType {
  int get val => this.index;

  static MessageType type(int index) => MessageType.values.elementAt(index);
}
