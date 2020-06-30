import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//create a new variable for the loggedInUser, this is hold inside _auth.currentUser()
//every class can access
FirebaseUser loggedInUser; //(await _auth.currentUser()).email

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //Initialize FirebaseAuth:
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Initialize cloud Firestore:
  final Firestore _firestore = Firestore.instance;

  //another variable for our database collection messages
  //get value from TextField
  String messageText; //what we typed in TextField
  //later we save the data to database after press send button:
  //_firestore.collection('messages').add({
  //                        'text': messageText,
  //                        'sender': loggedInUser.email,
  //                      });
  //at the same time we want it to show on the screen every time we have new
  // message, we use StreamBuilder

//  //this to clear the message after send
//  final messageTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  //trigger this method when our state is initialized
  void getCurrentUser() async {
    //this will be null if nobody is currently assigned in
    //but if somebody has registered or logged in, then this will
    // correspond to the current user and we will be able to tap into
    // that user's email an password

    //Future<FirebaseUser> Function()
    //of course this is also an asynchronous method that returns a future
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

//  //we want to be able to send the data and make it show on the screen
//  //and we also need the message that sent by other user to be shown on
//  //the screen. so if we create a method like before, we have to trigger
//  //it somewhere like press a button to see all the new messages sent by
//  //other people. In fact we were basically just pulling our database and
//  //retrieving the chat message every time when new message comes,
//  // it's not effective, we should use stream.
//  void getMessages() async {
//    //Future<QuerySnapshot> getDocuments({Source source})
//    final messages = await _firestore.collection('messages').getDocuments();
//    //List<DocumentSnapshot> get documents
//    //messages.documents is a list
//    for (var message in messages.documents) {
//      print(message.data);
//      //this should return a key value pair with a list like this:
//      //flutter: {text: hello flutter, sender: lu@email.com}
//      //flutter: {text: Hello, sender: Lu}
//      //that's all the data we have in our collection
//    }
//  }

  //we don't need to trigger this method like press a button, it will
  // automatically show new messages
  void messagesStream() async {
    //Stream<QuerySnapshot> snapshots({bool includeMetadataChanges})
    //it's like a list of futures and I am now subscribed to listen for
    // changes to my collection of messages, as soon as there was a
    // change, it's coming out, and I will be notified of any new results.

    //this snapshot is different with the StreamBuilder builder function snapshot
    //here we are dealing with Firebase's query snapshot
    //but down there we've got Flutter's async snapshot because we are working
    //with StreamBuilder
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      //List<DocumentSnapshot> get documents, again it's a list
      for (var message in snapshot.documents) {
        print(message.data);
      }
    }
  }
  //now we can get stream of messages, we need something that can
  // handle a stream and will update our widgets every time a new chat
  // messages comes, in this case we use StreamBuilder, this will turn
  // our snapshots of data into actual widgets, it's able to rebuild
  // every time new data come through, and it does that using set state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
//        leading: null,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              _auth.signOut(); //easy sign out function
              messagesStream(); //just text to see the data
              Navigator.pop(context); //go back to previous screen
            },
          ),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //stream: where this data come from, in our case it's going
            // to be snapshots which returns a stream, in particular,
            // a stream of query snapshots
            //this QuerySnapshots is a class from firebase which will ultimately
            //contain the chat messages. so now it knows when new data comes
            // in to rebuild itself. and in StreamBuilder quick docs, we will
            // see builder, build strategy is given by [builder]
            //in other words, we need to provide logic for what the stream builder should do.
            //remember the stream builder is interacting with our stream and with each new event like a chat message being sent, our stream builder receives a snapshot. At this point the builder function needs to update the list of messages displayed on the screen. In other words, the builder needs to rebuild all the children of the stream builder namely the column.
            //Widget Function(BuildContext, AsyncSnapshot<QuerySnapshot>) builder
            //this AsyncSnapshot represents the most recent interaction with the stream.
            //our chat message are buried somewhere in this async snapshot and we can get access to it through the builder function.
            //so the builder function takes an anonymous callback and it takes two inputs and returns a widget.
            //in our case, the widget the builder return is going to be a column containing our text widgets.
            //in AsyncSnapshot class documentation, one property is hasData, we use this to check that the snapshot from our stream is not equal to null, our query snapshot from firebase is stored inside our data property.
            MessageStream(firestore: _firestore),
            //this is for editing and send message
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
//                      controller: TextEditingController(),
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      TextEditingController().clear();
                      //messageText+loggedInUser.email
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedInUser.email,
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  const MessageStream({
    Key key,
    @required Firestore firestore,
  })  : _firestore = firestore,
        super(key: key);

  final Firestore _firestore;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      //Stream<QuerySnapshot> snapshots({bool includeMetadataChanges})
      //snapshot represent all the data in our messages collection
      stream: _firestore.collection('messages').snapshots(),
      //our async snapshot actually contains our query snapshot from Firebase
      // ignore: missing_return
      builder: (context, snapshot) {
        //we might have a null value in our very first snapshot before we has a chance to connect to Firebase. If our first snapshot has no data and we are not yet connected to Firebase, then what I'd like to do is to show a spinner, that way user knows to wait for our app.
        //a circular progress indicator is what our modal progress HUD was based on, it made it easy to specify when it should spin and when it should stop spinning.
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        //dynamic data  Containing class: AsyncSnapshot
        //this data type is dynamic, and the reason is because even though we built this stream builder, we didn't tell what type of stream we are going to get.

        //after adding data type in StreamBuilder, it now shows QuerySnapshot data
        //this documents again is List<DocumentSnapshot>
        //the async snapshot contains a query snapshot from Firebase
        //we access the query snapshot through the data property
        //now we are dealing with a query snapshot object so we can use the query snapshot's properties.

        //in summary our async snapshot from the stream builder contains a query snapshot from Firebase, which contains a list of documents snapshots. two layer deep right now, but we need to ge even deeper to get our chat messages

        //when we get our messages from snapshot.data.documents,
        // we know it's a list of document snapshots, so we can then
        //'reverse' on any list, this reverse the order in the list
        final messages = snapshot.data.documents.reversed;
        //firstly we created a list of Text widget, but it doesn't look good
        // we want to change it to a bubble-like message

        List<MessageBubble> messageWidgets = [];
        for (var message in messages) {
          //message.data is the data contained inside a single document snapshot, each document contains two pieces of information with the key/filed text and sender
          //message.data and snapshot.data are two different objects, they just happen to have the same property name called data. The snapshot is an async snapshot from Flutter, and the message is a document snapshot from Firebase.

          final messageWidget = MessageBubble(
            messageText: message.data['text'],
            messageSender: message.data['sender'],
            //based on true or false, we display differently on screen
            isMe: loggedInUser.email == message.data['sender'],
          );
          // lastly we created our list, we then add this list to ListView
          messageWidgets.add(messageWidget);
        }
        //previously we return a Column, but if we get a lof of messages, the screen will not hold it and ven push other part behind the scene
        //we use ListView instead to be able to scroll infinitely
        //and because we have StreamBuilder and Container which contain
        //TextField and send button in the same Column, everything
        // disappears and we will get error 'Vertical viewport was
        // given unbounded height'.
        //so we need to wrap ListView in Expanded Widget.
        return Expanded(
          child: ListView(
            //we need ListView to scroll down to the bottom every time it updates
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            children: messageWidgets,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key key,
    @required this.messageText,
    @required this.messageSender,
    @required this.isMe,
  }) : super(key: key);

  final messageText;
  final messageSender;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        //columns will automatically fit its size to it's children
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            messageSender,
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
            elevation: 5.0,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
              child: Text(
                '$messageText',
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black54,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
