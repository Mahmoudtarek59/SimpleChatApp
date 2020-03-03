import 'package:flutter/material.dart';
import 'GoogleSignIn/googleaccount.dart';

void main(){
  runApp(new MyApp());}

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Navigation",
      theme: ThemeData.dark(),
      home: new GoogleLogin(),
    );
  }
}
