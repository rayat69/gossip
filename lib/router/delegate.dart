import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gossip/router/path.dart';
import 'package:gossip/screens/auth_screen.dart';
import 'package:gossip/screens/chat_screen.dart';
import 'package:gossip/screens/home_screen.dart';

class MainRouterDelegate extends RouterDelegate<MainPath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<MainPath> {
  late StreamSubscription<User?> _state;
  User? _user;
  String? _selectedChatId;

  MainRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    _state = FirebaseAuth.instance.authStateChanges().listen((user) {
      print(user);
      _user = user;
      notifyListeners();
    }, onError: (e) {
      print(e);
    });
  }

  bool get isLoggedIn => _user != null;

  @override
  Widget build(BuildContext context) {
    return Navigator(
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
          if (_selectedChatId != null)
            MaterialPage(
              key: ValueKey('chat'),
              child: ChatScreen(),
            ),
        ],
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;

        final page = route.settings as Page;
        print('popped');
        print(page);

        return true;
      },
    );
  }

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  void _handleChatPage(String id) {
    _selectedChatId = id;
    notifyListeners();
  }

  @override
  Future<void> setNewRoutePath(MainPath config) async {
    if (!config.isAuth && _user != null) {
      if (config.isChat) {
        _selectedChatId = config.userId;
      }
    }
  }

  @override
  MainPath? get currentConfiguration {
    if (isLoggedIn) {
      if (_selectedChatId == null) {
        return MainPath.home();
      } else {
        return MainPath.chat(_selectedChatId!);
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
