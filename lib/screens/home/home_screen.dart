import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:gossip/models/message_model.dart';
import 'package:gossip/router/delegate.dart';
import 'package:gossip/widgets/drawer.dart';
import 'package:gossip/widgets/search_delegate.dart';
import 'package:provider/provider.dart';
import './widgets/chat_list.dart';

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
              onPressed: () async {
                try {
                  final id = await showSearch<String?>(
                    context: context,
                    delegate: MainSearchDelegate(),
                  );
                  if (id != null) {
                    print(id);
                    context.read<MainRouterDelegate>().handleChatPagePush(id);
                  }
                } catch (e) {}
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
                      child: ListView.builder(
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
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 12.0),
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(40.0)),
                  ),
                  child: ChatList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
