import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:profs_and_cons/provider/google_sign_in.dart';
import 'package:profs_and_cons/widget/login_widget.dart';
import 'package:profs_and_cons/pages/search.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: ChangeNotifierProvider(
          create: (context) => GoogleSignInProvider(),
          child: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SearchPage();
                } else {
                  return LoginWidget();
                }
              }),
        ),
      );
}
