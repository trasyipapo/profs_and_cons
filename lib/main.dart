import 'package:flutter/material.dart';
import 'package:profs_and_cons/pages/login.dart';
import 'package:profs_and_cons/pages/home.dart';
import 'package:profs_and_cons/pages/profile.dart';
import 'package:profs_and_cons/pages/revlist.dart';

void main() {
  runApp(MaterialApp(initialRoute: '/profile', routes: {
    '/login': (context) => const Login(),
    '/home': (context) => const Home(),
    '/profile': (context) => const Profile(),
    '/revlist': (context) => const RevList(),
  }));
}
