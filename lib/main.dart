import 'package:flutter/material.dart';
import 'package:profs_and_cons/pages/login.dart';
import 'package:profs_and_cons/pages/home.dart';
import 'package:profs_and_cons/pages/profiles.dart';

void main() {
  runApp(MaterialApp(initialRoute: '/profiles', routes: {
    '/login': (context) => const Login(),
    '/home': (context) => const Home(),
    '/profiles': (context) => const Profiles(),
  }));
}
