import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gossip/database/index.dart';
import 'package:gossip/models/user_model.dart';

// part 'conversation.g.dart';
// part 'conversation.freezed.dart';

class Conversation with EquatableMixin {
  final String id;
  final List<DocumentReference<FirestoreUser>> users;
  final Timestamp createdAt;
  final ConvType type;
  final String? logo;

  Conversation({
    required this.id,
    required this.users,
    required this.createdAt,
    required this.logo,
    this.type = ConvType.PRIVATE,
  })  : assert(users.length >= 2),
        assert(type == ConvType.GROUP || users.length == 2);

  factory Conversation.fromJson(Map<String, Object?> json, String id) =>
      Conversation(
        id: id,
        users: (json['users'] as List)
            .map((e) => Database.instance.userCol.doc(e.toString()))
            .toList(),
        createdAt: json['createdAt'] as Timestamp,
        type: ConvTypeVal.type(json['type'] as int),
        logo: json['logo'] as String,
      );

  Map<String, Object?> toJson() => {
        'users': users.map((e) => e.id).toList(),
        'createdAt': createdAt,
        'type': type.val,
        'logo': logo,
      };

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [id, users, createdAt, type, logo];
}

enum ConvType { PRIVATE, GROUP }

extension ConvTypeVal on ConvType {
  int get val => this.index;

  static ConvType type(int index) => ConvType.values.elementAt(index);
}
