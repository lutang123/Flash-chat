import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';

import 'screens/chat_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/welcome_screen.dart';

void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
//      theme: ThemeData.dark().copyWith(
//        textTheme: TextTheme(
//          body1: TextStyle(color: Colors.black54),
//        ),
//      ),
      //WelcomeScreen.id refers to 'welcome_screen'
      //in this case if we spell wrong, we will get an error saying undefined name
      // if it's all just string, we can type any string but
      // not we will not get error warning if we type wrong but our app will crash.
      initialRoute: WelcomeScreen.id,
      //routes expects map object that has a string as a key and a
      // route builder as an object, so we have to supply the
      // current context, and also which screen or which stateful
      // widget should be by creating an anonymous function that
      // takes a context, and the current context as an input and
      // returns the next screen.
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },
    );
  }
}
