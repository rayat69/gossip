import 'package:flutter/material.dart';
import 'package:gossip/models/message_model.dart';

class ChatsSliver extends StatelessWidget {
  const ChatsSliver({
    Key? key,
    required GlobalKey<AnimatedListState> listKey,
    required List<Message> messages,
  })  : _listKey = listKey,
        _messages = messages,
        super(key: key);

  final GlobalKey<AnimatedListState> _listKey;
  final List<Message> _messages;

  @override
  Widget build(BuildContext context) {
    return SliverAnimatedList(
      initialItemCount: messages.length, key: _listKey,
      // separatorBuilder: (_, i) => divider!,
      itemBuilder: (context, i, animation) {
        final msg = _messages[i];
        final isMe = msg.sender == currentUser;

        final message = Container(
          margin: isMe
              ? const EdgeInsets.only(left: 72.0, top: 10, bottom: 10)
              : const EdgeInsets.only(right: 72.0, top: 10, bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
          decoration: BoxDecoration(
            color: isMe ? Colors.amber[50] : Colors.red[50],
            borderRadius: isMe
                ? BorderRadius.horizontal(left: Radius.circular(24.0))
                : BorderRadius.horizontal(right: Radius.circular(24.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(msg.time),
              SizedBox(height: 4.0),
              Text(msg.text),
            ],
          ),
        );
        return ScaleTransition(
          scale: animation,
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: FadeTransition(
            opacity: animation,
            child: message,
          ),
        );
      },
      // itemCount: messages.length,
    );
  }
}
