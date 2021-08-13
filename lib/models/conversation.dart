import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  final List<String> users;
  final Timestamp createdAt;
  final ConvType type;
  final String? logo;
  final String recent;
  final bool unread;

  Conversation({
    required this.users,
    required this.createdAt,
    required this.type,
    required this.logo,
    required this.recent,
    required this.unread,
  }) : assert(users.length >= 2);

  factory Conversation.fromJson(Map<String, Object?> json) => Conversation(
        users: json['users'] as List<String>,
        createdAt:
            Timestamp.fromMillisecondsSinceEpoch(json['createdAt'] as int),
        type: ConvTypeVal.type(json['type'] as int),
        logo: json['logo'] as String,
        recent: json['recent'] as String,
        unread: json['unread'] as bool,
      );

  Map<String, Object?> toJson() => {
        'users': users,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'type': type.val,
        'logo': logo,
        'recent': recent,
        'unread': unread,
      };
}

enum ConvType { GROUP, PRIVATE }

extension ConvTypeVal on ConvType {
  int get val => this.index;

  static ConvType type(int index) => ConvType.values.elementAt(index);
}
