import 'package:flutter/material.dart';
import 'package:profs_and_cons/pages/bookmarks.dart';
import 'package:profs_and_cons/pages/search.dart';
import 'package:profs_and_cons/pages/profile.dart';
// import 'package:profs_and_cons/pages/fullreview.dart';
// import 'package:profs_and_cons/pages/revlist.dart';
//import 'package:profs_and_cons/pages/searchresults.dart';
import 'package:profs_and_cons/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Profs and Cons';

  @override
  Widget build(BuildContext context){
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(primarySwatch: Colors.red, fontFamily: 'GoogleSans'),
      home: LoginPage(),
    );
  }
}