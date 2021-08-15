import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gossip/database/index.dart';
import 'package:gossip/mock/conversation.dart';
import 'package:gossip/models/message_model.dart';
import 'package:gossip/screens/chat/widgets/chats.dart';

// keytool -list -v -alias androiddebugkey -keystore C:\Users\rayat\.android\debug.keystore
class ChatScreen extends StatefulWidget {
  final String id;
  const ChatScreen({Key? key, required this.id}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin<ChatScreen> {
  // late ValueNotifier<List<Message>> _messages;
  late List<Message> _messages;
  late AnimationController _controller;
  late ScrollController _scroll;
  late FocusNode _focusNode;
  late TextEditingController _input;
  late String _id;

  final _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    _id = widget.id;
    _messages = messages;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
    _scroll = ScrollController(debugLabel: 'scroll');
    _focusNode = FocusNode(debugLabel: 'focus-input');
    _input = TextEditingController();

    _input.addListener(() {
      if (_input.text.isEmpty && _controller.isCompleted) {
        _controller.reverse();
      }
      if (_input.text.isNotEmpty && _controller.isDismissed) {
        _controller.forward();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // _messages.dispose();
    _input.dispose();
    _scroll.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(james.name),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          splashRadius: 20.0,
          icon: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Chip(
              label: Text(chats.where((chat) => chat.unread).length.toString()),
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            splashRadius: 20.0,
            icon: Icon(
              Icons.more_horiz,
              color: Colors.white,
              size: 32.0,
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        margin: const EdgeInsets.only(top: 24.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(40.0)),
          color: Colors.white,
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomScrollView(
                controller: _scroll,
                reverse: true,
                slivers: [
                  SliverToBoxAdapter(
                    child: Center(
                      child: FutureBuilder<Conversation>(
                        future: Database.instance.getConversationById(_id),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            print(snapshot.error);
                          }
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              return Text('Start a new conversation');
                            case ConnectionState.waiting:
                              return CircularProgressIndicator();
                            case ConnectionState.active:
                            case ConnectionState.done:
                              if (snapshot.hasData) {
                                final data = snapshot.data!;
                                return SizedBox(
                                  height: 200,
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(data.logo!),
                                        backgroundColor: Colors.pink,
                                      ),
                                      Text('data.title'),
                                    ],
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                print(snapshot.error);
                                return Text(snapshot.error.toString());
                              } else {
                                return CircularProgressIndicator();
                              }
                            default:
                              return CircularProgressIndicator();
                          }
                        },
                      ),
                    ),
                  ),
                  ChatsSliver(
                    listKey: _listKey,
                    messages: _messages,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: DecoratedBox(
                      // height: 44.0,
                      decoration: BoxDecoration(
                        color: Colors.amber[50],
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      // padding: const EdgeInsets.all(2.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              // _controller.isDismissed
                              //     ? _controller.forward()
                              //     : _controller.reverse();
                            },
                            icon: Icon(Icons.emoji_emotions_outlined),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _input,
                              // scrollController: _scroll,
                              maxLines: 4,
                              minLines: 1,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              decoration: InputDecoration.collapsed(
                                hintText: 'Type your message...',
                              ),
                              focusNode: _focusNode,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // _sendMessage();
                            },
                            icon: Transform.rotate(
                              angle: -pi / 4,
                              child: Icon(Icons.attachment),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // if (!_controller.isDismissed)
                SizeTransition(
                  sizeFactor: _controller,
                  axis: Axis.horizontal,
                  child: IconButton(
                    onPressed: () {
                      _sendMessage();
                      print('sent');
                    },
                    icon: Icon(Icons.send),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_input.text.isEmpty) {
      return;
    }
    _messages.insert(
        0,
        Message(
          sender: currentUser,
          time: '5:45 PM',
          text: _input.text,
          isLiked: false,
          unread: false,
        ));
    _listKey.currentState?.insertItem(0);
    _scroll.animateTo(
      0,
      duration: Duration(milliseconds: 250),
      curve: Curves.linear,
    );
    // _focusNode.unfocus();
    _input.clear();
  }
}
