import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class FirestoreUser with EquatableMixin {
  final String id;
  final String? displayName;
  final String email;
  final String? photoUrl;
  final String? phoneNumber;
  final List<String> conversations;

  FirestoreUser.fromJson(Map<String, Object?> json, String id)
      : id = id,
        displayName = json['displayName'] as String?,
        email = json['email'] as String,
        photoUrl = json['photoUrl'] as String?,
        phoneNumber = json['phoneNumber'] as String?,
        conversations =
            (json['conversations'] as List).map((e) => e.toString()).toList();

  FirestoreUser.fromUser(auth.User user)
      : id = user.uid,
        displayName = user.displayName,
        email = user.email!,
        photoUrl = user.photoURL,
        phoneNumber = user.phoneNumber,
        conversations = [];

  Map<String, Object?> toJson() => {
        'displayName': displayName,
        'email': email,
        'photoUrl': photoUrl,
        'phoneNumber': phoneNumber,
        'conversations': conversations,
      };

  @override
  List<Object?> get props => [displayName, email, photoUrl, phoneNumber];

  @override
  bool? get stringify => true;
}

class User with EquatableMixin {
  final int id;
  final String name;
  final String imageUrl;

  User({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  @override
  List<Object> get props => [id, name, imageUrl];

  @override
  bool get stringify => true;
}
