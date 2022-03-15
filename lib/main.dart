import 'package:flutter/material.dart';
import 'package:profs_and_cons/pages/login.dart';
import 'package:profs_and_cons/pages/home.dart';
import 'package:profs_and_cons/pages/fullreview.dart';

void main() {
  runApp(MaterialApp(initialRoute: '/login', routes: {
    '/login': (context) => const Login(),
    '/home': (context) => const Home(),
    '/fullreview': (context) => const FullReview(),
  }));
}
