import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:gossip/database/index.dart';
import 'package:gossip/models/user_model.dart';

class Conversation with EquatableMixin {
  final String id;
  final List<DocumentReference<FirestoreUser>> users;
  final Timestamp createdAt;
  final ConvType type;
  final String? logo;

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [id, users, createdAt, type, logo];

  Conversation({
    required this.id,
    required this.users,
    required this.createdAt,
    required this.type,
    required this.logo,
  }) : assert(users.length >= 2);

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
}

enum ConvType { GROUP, PRIVATE }

extension ConvTypeVal on ConvType {
  int get val => this.index;

  static ConvType type(int index) => ConvType.values.elementAt(index);
}
