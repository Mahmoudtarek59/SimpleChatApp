import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:io';


final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn =new GoogleSignIn();
String _status;
String username;
bool auth;

Future<String> userSignin() async{
  GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  if(googleUser != null){
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );
    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user =await authResult.user;

    if(user !=null && user.isAnonymous == false && user.getIdToken()!=null){
      auth =true;
      username=user.displayName;
      _status = 'Signed In Successfully';
    }else{
      auth =false;
      _status = 'Google Signin Failed';
    }
  }else{
    auth =false;
    _status = 'Google Signin Failed';
  }

  return _status.toString();
}

Future<String> userSignOut() async{
  await _googleSignIn.signOut();
  _status="Signed Out";
  auth =true;
  return _status;
}
