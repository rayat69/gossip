import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gossip/router/delegate.dart';
import 'package:gossip/router/parser.dart';
import 'package:provider/provider.dart';

// import 'package:gossip/screens/chat_screen.dart';
// import 'package:gossip/screens/home_screen.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    final app = await Firebase.initializeApp();
    // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    // FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);

    runApp(MultiProvider(
      providers: [
        FutureProvider<FirebaseApp>(
          create: (_) => Future(() => app),
          initialData: app,
          catchError: (_, e) {
            print(e);
            return app;
          },
        ),
      ],
      child: MyApp(),
    ));
  } catch (e, s) {
    print(e);
    print(s);
  }
}

class MyApp extends StatelessWidget {
  final _routerDelegate = MainRouterDelegate();
  final _routeInfoParser = MainRouteInfoParser();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: MaterialApp.router(
        title: 'Gossip - Chat App',
        theme: ThemeData(
          primaryColor: Colors.red,
          fontFamily: GoogleFonts.poppins().fontFamily,
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        routerDelegate: _routerDelegate,
        routeInformationParser: _routeInfoParser,
        // home: AuthScreen(),
      ),
    );
  }
}
