import 'package:flutter/material.dart';
import 'package:profs_and_cons/pages/login.dart';
import 'package:profs_and_cons/pages/home.dart';
import 'package:profs_and_cons/pages/profile.dart';
import 'package:profs_and_cons/pages/fullreview.dart';
import 'package:profs_and_cons/pages/revlist.dart';
import 'package:profs_and_cons/pages/searchresults.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:profs_and_cons/providers/googlesignin.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
          theme: ThemeData(fontFamily: 'GoogleSans'),
          initialRoute: '/login',
          routes: {
            '/login': (context) => const Login(),
            '/home': (context) => const Home(),
            '/profile': (context) => const Profile(),
            '/fullreview': (context) => const FullReview(),
            '/revlist': (context) => const RevList(),
            '/searchresults': (context) => const SearchResults(),
          }));
}
