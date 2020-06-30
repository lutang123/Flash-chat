import 'package:flutter/material.dart';
import 'package:flash_chat/welcome_button.dart';
import '../constants.dart';
import 'chat_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  //Initialize FirebaseAuth:
  //we will use this auth object to authenticate users, it has many associated
  //methods like sign-in with email and password.
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //modal_progress_hud
  bool _saving = false;

  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: _saving, //false at the beginning
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              //we need the image to be able to handle different size screen
              //so we wrap it in Flexible, meaning now it's 200px height, but
              //if it can't fit, it can be flexible and be smaller, e.g. when
              //keyboard pops up, it became smaller
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
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration:
                    kInputDecoration.copyWith(hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              WelcomeButton(
                buttonText: 'register',
                buttonColor: Colors.blueAccent,
                onPressed: () async {
                  //when user press the button, start spinning
                  setState(() {
                    _saving = true;
                  });
                  //there are a lot more fancier ways to deal with error
                  try {
                    //Future<AuthResult> Function({String email, String password}
                    //this user gets saved into the authentication objects
                    // as a current user.we can tap into this currentUser() in chatScreen
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    if (newUser != null) {
                      //navigate to chat screen
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                    //after loggedIn/register, stop spinning
                    setState(() {
                      _saving = false;
                    });
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
