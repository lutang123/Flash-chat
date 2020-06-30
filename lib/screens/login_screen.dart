import 'package:flutter/material.dart';
import 'package:flash_chat/welcome_button.dart';
import 'package:flash_chat/constants.dart';
import 'chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../constants.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Initialize FirebaseAuth:
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration:
                    kInputDecoration.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kInputDecoration.copyWith(
                      hintText: 'Enter your password'),
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              WelcomeButton(
                buttonText: 'Log In',
                buttonColor: Colors.lightBlueAccent,
                onPressed: () async {
                  //there are a lot more fancier ways to deal with error
                  try {
                    //Future<AuthResult> Function({String email, String password}
                    //this user gets saved into the authentication objects
                    // as a current user.we can tap into this currentUser() in chatScreen
                    final user = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                    if (user != null) {
                      //navigate to chat screen
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                  } catch (e) {
                    print(e);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
