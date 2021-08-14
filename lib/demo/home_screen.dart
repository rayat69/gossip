import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gossip/models/message_model.dart';
import 'package:gossip/widgets/drawer.dart';
import 'package:gossip/widgets/search_delegate.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: HomeDrawer(),
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).primaryColor,
          ),
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: MainSearchDelegate(),
                );
              },
              icon: Icon(CupertinoIcons.search),
            ),
          ],
          elevation: 0.0,
          toolbarHeight: kToolbarHeight + 80.0,
          bottom: TabBar(
            isScrollable: true,
            unselectedLabelColor: Colors.white60,
            labelColor: Colors.white,
            labelStyle: Theme.of(context).textTheme.headline5?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
            labelPadding: const EdgeInsets.only(left: 24.0, right: 24.0),
            enableFeedback: false,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 0.1,
            tabs: [
              Tab(text: 'Messages'),
              Tab(text: 'Online'),
              Tab(text: 'Group'),
            ],
          ),
        ),
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).primaryColor,
        body: Container(
          margin: const EdgeInsets.only(top: 24.0),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Colors.amber[50],
            borderRadius: BorderRadius.vertical(top: Radius.circular(40.0)),
          ),
          child: Column(
            children: [
              Container(
                height: 180.0,
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0)
                          .copyWith(right: 8.0, bottom: 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'Favourite contacts',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.more_horiz,
                              color: Colors.grey[600],
                              size: 32.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ChatList(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 12.0),
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(40.0)),
                  ),
                  child: ListView.separated(
                    padding: const EdgeInsets.only(right: 16.0),
                    itemCount: chats.length,
                    // itemExtent: 100,
                    // semanticChildCount: chats.length,
                    clipBehavior: Clip.antiAlias,
                    itemBuilder: (context, i) {
                      final chat = chats[i];
                      final message = chat.sender == currentUser
                          ? 'You: ${chat.text}'
                          : chat.text;

                      return Container(
                        height: 92,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: chat.unread ? Colors.red[50] : null,
                          borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(24.0)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipOval(
                              child: Image(
                                image: AssetImage(chat.sender.imageUrl),
                                height: 56,
                                width: 56,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 4.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(chat.sender.name),
                                    Text(
                                      message,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(chat.time),
                                  if (chat.unread)
                                    Material(
                                      color: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
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
                      );
                    },
                    separatorBuilder: (_, i) => SizedBox(height: 8.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatList extends StatefulWidget {
  const ChatList({
    Key? key,
  }) : super(key: key);

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: favorites.length,
      itemBuilder: (context, i) {
        final user = favorites[i];
        return Container(
          // height: double.infinity,
          width: 80.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // mainAxisSize: MainAxisSize.max,
            children: [
              ClipOval(
                child: Image(
                  image: AssetImage(user.imageUrl),
                  height: 60,
                  width: 60,
                ),
              ),
              Center(
                child: Text(user.name),
              )
            ],
          ),
        );
      },
    );
  }
}
