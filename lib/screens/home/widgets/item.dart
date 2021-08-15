import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gossip/mock/conversation.dart';
import 'package:gossip/mock/user_model.dart';
import 'package:gossip/router/delegate.dart';
import 'package:provider/provider.dart';

class ConversationItem extends StatelessWidget {
  const ConversationItem({
    Key? key,
    required this.chat,
    required this.message,
  }) : super(key: key);

  final Conversation chat;
  final String message;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<MainRouterDelegate>().handleChatPagePush(chat.id);
      },
      child: Container(
        height: 92,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.horizontal(right: Radius.circular(24.0)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: Image(
                image: NetworkImage(chat.logo!),
                height: 56,
                width: 56,
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(chat.title),
                    _title,
                    Text(
                      message,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('5:30 pm'),
                  if (false)
                    Material(
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14.0, vertical: 4.0),
                        child: Text(
                          'NEW',
                          style: TextStyle(
                            fontSize: 10.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get _title {
    if (chat.type == ConvType.PRIVATE) {
      final friend = chat.users.firstWhere(
          (element) => element.id != FirebaseAuth.instance.currentUser!.uid);
      final friendData = friend.get().then((snapshot) => snapshot.data());
      return FutureBuilder<FirestoreUser?>(
        future: friendData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!.displayName ?? snapshot.data!.email);
          } else {
            return Text('Wtf!');
          }
        },
      );
    } else {
      return Text('Mock Group');
    }
  }
}
