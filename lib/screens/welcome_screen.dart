//flutter's own package
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
//our own different files
import 'package:flash_chat/welcome_button.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
//imported animation
import 'package:animated_text_kit/animated_text_kit.dart';

////Firebase packages:
////1. register account and create a project on firebase
////2. add two apps (Andoid and iOS separately to the project) and
////   finish configurations
////3.add firebase package to our project with FlutterFire plugins.

////   Firebase core is the must have for all firebase package

//import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

////after adding all the packages in .yaml file, we need to stop all the
//// process and re-start our app for Andoid.

////And for iOS, we should update CocoaPods first:
////$ pod repo update
////$sudo gem install cocoapods
////$ pod setup
////finally re-run on iOS device
//
////Adding a new DocumentReference:
//
////Firestore.instance.collection('books').document()
////    .setData({ 'title': 'title', 'author': 'author' });

class WelcomeScreen extends StatefulWidget {
  // static is a modifier, meaning this variable will not change
  //when we use this variable we don't have to initialize the class to
  //create a new object. This variable is now associate with the class.
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

// we have to use the key word with and specify that this class welcome
// screen state can act as a single ticker provider.
// it can be multiple ticker provider too.
//it's like we're upskilling our welcome screen state with a new ability,
// the ability to act as a ticker.
//This mixin only supports vending a single ticker. If you might have
// multiple [AnimationController] objects over the lifetime of the [State],
// use a full [TickerProviderStateMixin] instead.
//unlike inheriting from a class, Mixins enables class with different
// add-on capabilities
//so now we enable our welcome screen state to act as the ticker provider.
class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  // we not initialize the class yet,
  // we just say this a variable called controller, it's going to hold
  // data type of type AnimationController
  // we initialize it when our state object gets initialized
  AnimationController controller;

  //in order to use curve, we have to create another variable
  Animation animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      //for every ticker, it will increase that number, that number usually
      // goes from 0 to 1. so in one second we might get 60 ticks on our
      // ticker, in which case our controller will animate from 0 to 1
      // in 60 steps.
      duration: Duration(seconds: 1),
      //this is the value upperBound; when applying curved animation,
      // this can not be greater than one, because curves are drawn
      // from 0 to 1. default is 1.0
      upperBound: 1.0,
      //{TickerProvider vsync}  Type: TickerProvider
      //Creates an animation controller.
      //value is the initial value of the animation
      //usually the ticker provider is going to be our state object.
      //vsync is looking for a ticker, this is where we provide the
      // current welcome screen state object as the value for the vsync
      //when we want to reference the object made from the class in
      // the class's own code, we use the keyword 'this'
      // this line of code is to say: who's going to provide the ticker
      // for my animation controller, it's going to be the very object
      // that get created from the class which now has the capabilities to
      // act as a ticker because we've add that min in to the class declaration.
      vsync: this, //this refers to _WelcomeScreenState, that's our ticker
    );

//    //initialize animation to a new curved animation which expects two
//    required properties. 1. parent is what will we apply this curve to, so
//    our existing animation comes from this controller
//    //2. curve means what kind of curve we want to apply to our animation.
//    animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);

    //here we created an animation for ColorTween, every tween has a begin
    // and end, and it changes in between.
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);

    //TickerFuture forward({double from})
    controller.forward();

//    //pass by a callback that listens for the status of the animation
//    //when the value is 1, status is completed
//    //when the value is 0, status is dismissed
    animation.addStatusListener((status) {
//    //controller.forward() first, and then create a if else statement to
//    //using the status, and we can make the animation keep going back
//    and forwards until dispose;
//      if (status == AnimationStatus.completed) {
//        controller.reverse(from: 1.0);
//      } else if (status == AnimationStatus.dismissed) {
//        controller.forward();
//      }
      print('Animation status: $status');
    });

    //this is just to see what is the different on controller and animation
    controller.addStatusListener((status) {
      print('controller status: $status');
    });
    //I/flutter (20764): Animation status: AnimationStatus.completed
    //I/flutter (20764): controller status: AnimationStatus.completed

    //it's same as controller.addListener
    animation.addListener(() {
//      setState(() {});
      print('controller.value from animation: ${controller.value}');
      print('animation.value from animation: ${animation.value}');
    });
    //controller.value from animation: 0.206758
    //I/flutter (20764): animation.value from animation: Color(0xff8097a2)
    //I/flutter (20764): controller.value: 0.206758
    //I/flutter (20764): animation.value: Color(0xff8097a2)

    // if we wanted to see what the controller is doing, we have to add a
    // listener, and the listener takes a callback, now we can listen to
    // the value of the controller which is the actual animation.
    controller.addListener(() {
      //to change anything on the screen, we have to rebuild our screen
      // by calling the building method, we don't have to do anything inside
      // because our values are already changing with the controller.value
      setState(() {});
      print('controller.value: ${controller.value}');
      print('animation.value: ${animation.value}');
    });
  } // the end of init state

  //whenever we use animation, we have to dispose it when we go to other pages
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //when we add animation, we don't use controller.value.
      backgroundColor: animation.value, //value is Color value
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          // we use Hero widget with a tag to make our logo as a
                          // shared element transit. in this case, the only change is
                          // the height
                          Hero(
                            tag: 'logo',
                            child: Container(
                              child: Image.asset('images/logo.png'),
                              height: 60,
                            ),
                          ),
                          Flexible(
                            child: TypewriterAnimatedTextKit(
                              //this code shows from 0% to 100%.
                              //with ColorTween animation, this stays at 0.
//                  text: ['${controller.value.toInt() * 100}%'],
                              text: ['Flash Chat'],
                              textStyle: TextStyle(
                                fontSize: 45.0,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            WelcomeButton(
              buttonColor: Colors.lightBlueAccent,
              buttonText: 'Log in',
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            WelcomeButton(
              buttonColor: Colors.blueAccent,
              buttonText: 'register',
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}

//as a shared element transit, being an image or icon or whatever it maybe,
// has to be present on both pages, it will have a continuous transition as
// user navigates from page 1 to page 2.

//1. ticker: every time the ticker ticks, it triggers a new set state so
// that we can render something different.
//2. AnimationController: tell the animation to start, stop, go forwards
// and reverse, loop back, how long etc.
//3. Animation Value: we can change things such as height or the size of
// a component
