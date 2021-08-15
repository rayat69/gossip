import 'package:flutter/material.dart';
import 'package:gossip/database/index.dart';
import 'package:gossip/mock/conversation.dart';
// import 'package:gossip/models/message_model.dart';
import 'package:gossip/screens/home/widgets/item.dart';

class ChatList extends StatelessWidget {
  late final Stream<List<Conversation>> _chatListStream;

  ChatList({
    Key? key,
  }) : super(key: key) {
    _chatListStream = Database.instance.getConversationStreamByUser();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Conversation>>(
      stream: _chatListStream,
      initialData: [],
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
        }
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(
              child: Text('Start a new conversation'),
            );
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasData) {
              final data = snapshot.data!;
              if (data.length == 0) {
                return Text('Start a new conversation.');
              }
              return _chatList(context, data);
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Center(child: Text(snapshot.error.toString()));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          default:
            return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  ListView _chatList(BuildContext context, List<Conversation> chats) {
    return ListView.separated(
      padding: const EdgeInsets.only(right: 16.0),
      itemCount: chats.length,
      // itemExtent: 100,
      // semanticChildCount: chats.length,
      clipBehavior: Clip.antiAlias,
      itemBuilder: (context, i) {
        final chat = chats[i];
        final message = 'Hi dude!';

        return ConversationItem(chat: chat, message: message);
      },
      separatorBuilder: (_, i) => SizedBox(height: 8.0),
    );
  }
}
