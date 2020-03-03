import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import './customVariable/Item.dart';

class ChatRoom extends StatefulWidget {
  ChatRoom(this.username);
  final String username;
  @override
  _ChatRoomState createState() => new _ChatRoomState(username);
}

class _ChatRoomState extends State<ChatRoom> {
  _ChatRoomState(this.username);
  final String username;

  List<Item> items = List();
  Item item;
  DatabaseReference itemRef;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    item = new Item("","");
    final FirebaseDatabase database =FirebaseDatabase.instance;
    itemRef = database.reference().child("chat");
    itemRef.onChildAdded.listen(_onChildAdded);
    itemRef.onChildChanged.listen(_onChildChanged);
  }

  _onChildAdded(Event event){
    setState(() {
      items.add(Item.fromSnapShot(event.snapshot));
    });
  }

  _onChildChanged(Event event){
    var old = items.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      items[items.indexOf(old)] = Item.fromSnapShot(event.snapshot);
    });
  }

  void Submit(){
    final FormState formState=formKey.currentState;
    if (formState.validate()) {
      formState.save();
      formState.reset();
      itemRef.push().set(item.toJson());
    }
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: new AppBar(
        title: new Text("CustomRoom"),
      ),
      resizeToAvoidBottomPadding: false,
      body: new Column(
        children: <Widget>[
          new Flexible(

            child: new FirebaseAnimatedList(
              query: itemRef,
              itemBuilder: (BuildContext context,DataSnapshot snapshot,Animation<double> animation, int index){
                return new ListTile(
                  leading: new Icon(Icons.message),
                  title: new Text(items[index].username,style: new TextStyle(fontSize: 14)),
                  subtitle: new Text(items[index].body,style: new TextStyle(fontSize: 20),),
                );
              },
            ),
          ),


          new Flexible(
            flex: 0,
            child: new Center(
              child: new Form(
                key: formKey,
                child: new Padding(padding: EdgeInsets.all(10.0),
                child: new Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    new Expanded(
                      child: new TextFormField(
                        decoration: new InputDecoration(
                            hintText: 'Type a message',
                            contentPadding: new EdgeInsets.only(left: 10.0)
                        ),
                        autofocus: true,
                        initialValue: '',
                        onSaved: (val) {
                          item.username=username;
                          item.body = val;
                        },
                        validator: (val) => val == "" ? val : null,
                      ),
                    ),
                    new IconButton(
                      icon: new Icon(Icons.send),
                      onPressed: Submit,
                    ),
                  ],
                ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
