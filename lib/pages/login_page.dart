import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:profs_and_cons/provider/google_sign_in.dart';
import 'package:profs_and_cons/widget/login_widget.dart';
import 'package:profs_and_cons/pages/search.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:profs_and_cons/objects/user.dart';
import 'dart:async';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: ChangeNotifierProvider(
          create: (context) => GoogleSignInProvider(),
          child: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  User? currentUser = FirebaseAuth.instance.currentUser;
                  var uid = currentUser!.uid;
                  checkAddUser(uid);
                  return SearchPage();
                } else {
                  return LoginWidget();
                }
              }),
        ),
      );
}

Future createUser(UserFire user) async {
  print("Created User");
  final docUser = FirebaseFirestore.instance.collection('users');
  final json = user.toJson();
  await docUser.doc(user.uid).set(json);
}

Future checkAddUser(String uid) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .where("uid", isEqualTo: uid)
      .get();

  // Get data from docs and convert map to List
  final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

  if (allData.length == 0) {
    UserFire newUser = UserFire(uid: uid.toString());
    createUser(newUser);
    return true;
  } else {
    return false;
  }
}
