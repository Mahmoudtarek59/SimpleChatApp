import 'package:flutter/material.dart';
import 'package:flutterapp/ChatRoom.dart';
import './GoogleSignIn.dart' as google;

class GoogleLogin extends StatefulWidget{
  @override
  _GoogleState createState() => new _GoogleState();
}

class _GoogleState extends State<GoogleLogin>{

  String _status;

  @override
  void initState() {
    _status = 'Not Authenticated';
  }

  void _login() async{
    String value = await google.userSignin();
    if(google.auth){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>new ChatRoom(google.username)));
    }
    setState(()=>_status=value);
  }

  void _logout() async{
    String value = await google.userSignOut();
    setState(()=>_status=value);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        padding: new EdgeInsets.all(32.0),
        child: new Center(
          child: new Column(
            children: <Widget>[
              Expanded(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: new FlutterLogo(
                    style: FlutterLogoStyle.horizontal,
                  ),
                ),
              ),
              Spacer(),
              new Text("${_status}"),
              new RaisedButton(onPressed: _login,child: new Row(
                children: <Widget>[
                  new Icon(Icons.assignment_ind),
                  new Padding(padding: new EdgeInsets.only(left: 30.0),
                    child: new Text("Google SignIn",),),
                ],
              ),
              ),
              new RaisedButton(onPressed: _logout,child: new Row(
                children: <Widget>[
                  new Icon(Icons.keyboard_arrow_left),
                  new Padding(padding: new EdgeInsets.only(left: 30.0),
                    child: new Text("Google SignOut",),),
                ],
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
