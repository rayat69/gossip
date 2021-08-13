import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import './user_model.dart';

class FirestoreMessage {
  final String id;
  final String sender;
  final Timestamp time;
  final String text;
  final bool isLiked;
  final bool unread;

  factory FirestoreMessage.newConv(String sender, String id) =>
      FirestoreMessage(
        id: id,
        sender: sender,
        time: Timestamp.now(),
        text: '',
        isLiked: false,
        unread: false,
      );

  FirestoreMessage({
    required this.id,
    required this.sender,
    required this.time,
    required this.text,
    required this.isLiked,
    required this.unread,
  });

  factory FirestoreMessage.fromJson(Map<String, Object?> json, String id) =>
      FirestoreMessage(
        id: id,
        sender: json['sender'] as String,
        time: Timestamp.fromMillisecondsSinceEpoch(json['time'] as int),
        text: json['text'] as String,
        isLiked: json['isLiked'] as bool,
        unread: json['unread'] as bool,
      );

  Map<String, Object?> toJson() => {
        'sender': sender,
        'time': time.millisecondsSinceEpoch,
        'text': text,
        'isLiked': isLiked,
        'unread': unread,
      };
}

class Message with EquatableMixin {
  final User sender;
  final String time;
  final String text;
  final bool isLiked;
  final bool unread;

  Message({
    required this.sender,
    required this.time,
    required this.text,
    required this.isLiked,
    required this.unread,
  });

  @override
  bool? get stringify => true;

  @override
  List<Object> get props => [sender, time, text, isLiked, unread];
}

// YOU - current user
final User currentUser = User(
  id: 0,
  name: 'Current User',
  imageUrl: 'assets/images/greg.jpg',
);

// USERS
final User greg = User(
  id: 1,
  name: 'Greg',
  imageUrl: 'assets/images/greg.jpg',
);
final User james = User(
  id: 2,
  name: 'James',
  imageUrl: 'assets/images/james.jpg',
);
final User john = User(
  id: 3,
  name: 'John',
  imageUrl: 'assets/images/john.jpg',
);
final User olivia = User(
  id: 4,
  name: 'Olivia',
  imageUrl: 'assets/images/olivia.jpg',
);
final User sam = User(
  id: 5,
  name: 'Sam',
  imageUrl: 'assets/images/sam.jpg',
);
final User sophia = User(
  id: 6,
  name: 'Sophia',
  imageUrl: 'assets/images/sophia.jpg',
);
final User steven = User(
  id: 7,
  name: 'Steven',
  imageUrl: 'assets/images/steven.jpg',
);

// FAVORITE CONTACTS
List<User> favorites = [sam, steven, olivia, john, greg];

// EXAMPLE CHATS ON HOME SCREEN
List<Message> chats = [
  Message(
    sender: james,
    time: '5:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: olivia,
    time: '4:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: john,
    time: '3:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: false,
  ),
  Message(
    sender: sophia,
    time: '2:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: steven,
    time: '1:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: false,
  ),
  Message(
    sender: sam,
    time: '12:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: false,
  ),
  Message(
    sender: greg,
    time: '11:30 AM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: false,
  ),
];

// EXAMPLE MESSAGES IN CHAT SCREEN
List<Message> messages = [
  // Message(
  //   sender: currentUser,
  //   time: '5:45 PM',
  //   text: 'Nothing much. Doing the usual 😅',
  //   isLiked: false,
  //   unread: true,
  // ),
  Message(
    sender: james,
    time: '5:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: true,
    unread: true,
  ),
  Message(
    sender: currentUser,
    time: '4:30 PM',
    text: 'Just walked my doge. She was super duper cute. The best pupper!!',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: james,
    time: '3:45 PM',
    text: 'How\'s the doggo🐶?',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: james,
    time: '3:15 PM',
    text: 'All the food',
    isLiked: true,
    unread: true,
  ),
  Message(
    sender: currentUser,
    time: '2:30 PM',
    text: 'Nice! What kind of food did you eat?',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: james,
    time: '2:00 PM',
    text: 'I ate so much food today 😋.',
    isLiked: false,
    unread: true,
  ),
];
