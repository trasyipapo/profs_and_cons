import 'package:flutter/material.dart';
import 'package:profs_and_cons/pages/login.dart';
import 'package:profs_and_cons/pages/home.dart';
import 'package:profs_and_cons/pages/profile.dart';
import 'package:profs_and_cons/pages/fullreview.dart';
import 'package:profs_and_cons/pages/revlist.dart';
import 'package:profs_and_cons/pages/searchresults.dart';

void main() {
  runApp(MaterialApp(
      theme: ThemeData(fontFamily: 'GoogleSans'),
      initialRoute: '/searchresults',
      routes: {
        '/login': (context) => const Login(),
        '/home': (context) => const Home(),
        '/profile': (context) => const Profile(),
        '/fullreview': (context) => const FullReview(),
        '/revlist': (context) => const RevList(),
        '/searchresults': (context) => const SearchResults(),
      }));
}
