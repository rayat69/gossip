import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gossip/database/index.dart';
import 'package:gossip/router/path.dart';
import 'package:gossip/screens/auth/auth_screen.dart';
import 'package:gossip/screens/chat/chat_screen.dart';
import 'package:gossip/screens/home/home_screen.dart';
import 'package:provider/provider.dart';

class MainRouterDelegate extends RouterDelegate<MainPath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<MainPath> {
  late StreamSubscription<User?> _state;
  User? _user;
  String? selectedChatId;

  MainRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    _state = FirebaseAuth.instance.authStateChanges().listen((user) async {
      print(user);
      _user = user;
      try {
        if (user != null) {
          if (!await Database.instance.userExists(user.uid)) {
            Database.instance.addUser(user);
          }
        }
      } catch (e) {
        print(e);
      }
      notifyListeners();
    }, onError: (e) {
      print(e);
    });
  }

  bool get isLoggedIn => _user != null;

  void handleChatPagePush(String id) {
    selectedChatId = id;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: this,
      child: Navigator(
        key: navigatorKey,
        pages: [
          if (!isLoggedIn)
            MaterialPage(
              key: ValueKey('auth'),
              child: AuthScreen(),
            ),
          if (isLoggedIn) ...[
            MaterialPage(
              key: ValueKey('home'),
              child: HomeScreen(),
            ),
            if (selectedChatId != null)
              MaterialPage(
                key: ValueKey('chat-$selectedChatId'),
                child: ChatScreen(id: selectedChatId!),
              ),
          ],
        ],
        onPopPage: (route, result) {
          if (!route.didPop(result)) return false;

          final page = route.settings as Page;
          print('popped');
          print(page);
          if (page.key == ValueKey('chat-$selectedChatId')) {
            selectedChatId = null;
            notifyListeners();
          }

          return true;
        },
      ),
    );
  }

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Future<void> setNewRoutePath(MainPath config) async {
    if (!config.isAuth && _user != null) {
      if (config.isChat) {
        selectedChatId = config.userId;
      }
    }
  }

  @override
  MainPath? get currentConfiguration {
    if (isLoggedIn) {
      if (selectedChatId == null) {
        return MainPath.home();
      } else {
        return MainPath.chat(selectedChatId!);
      }
    } else {
      return MainPath.auth();
    }
  }

  @override
  void dispose() {
    _state.cancel();
    super.dispose();
  }
}
