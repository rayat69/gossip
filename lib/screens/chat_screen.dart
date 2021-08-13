import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gossip/models/message_model.dart';

// keytool -list -v -alias androiddebugkey -keystore C:\Users\rayat\.android\debug.keystore
class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

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

  final _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
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
          icon: Chip(
            label: Text(chats.where((chat) => chat.unread).length.toString()),
            backgroundColor: Colors.white,
            labelStyle: TextStyle(
              color: Theme.of(context).primaryColor,
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
              child: AnimatedList(
                initialItemCount: messages.length, key: _listKey,
                controller: _scroll,
                reverse: true,
                // separatorBuilder: (_, i) => divider!,
                itemBuilder: (context, i, animation) {
                  final msg = _messages[i];
                  final isMe = msg.sender == currentUser;

                  final message = Container(
                    margin: isMe
                        ? const EdgeInsets.only(left: 72.0, top: 10, bottom: 10)
                        : const EdgeInsets.only(
                            right: 72.0, top: 10, bottom: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 16.0),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.amber[50] : Colors.red[50],
                      borderRadius: isMe
                          ? BorderRadius.horizontal(left: Radius.circular(24.0))
                          : BorderRadius.horizontal(
                              right: Radius.circular(24.0)),
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
                    alignment:
                        isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: FadeTransition(
                      opacity: animation,
                      child: message,
                    ),
                  );
                },
                // itemCount: messages.length,
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
    final time = DateTime.now();
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

  static final _tween = Tween<double>(begin: 1.0, end: 0.85);
}
