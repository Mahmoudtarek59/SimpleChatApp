import 'package:firebase_database/firebase_database.dart';

class Item{
  String key;
  String username;
  String body;

  Item(this.username,this.body);

  Item.fromSnapShot(DataSnapshot snapshot):
        key = snapshot.key,
        username = snapshot.value["username"],
        body = snapshot.value["body"];

  toJson(){
    return {
      "username":username,
      "body":body,
    };
  }

}