import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Profs and Cons'),
        ),
        body: Column(
          children: [welcomeUser],
        ),
      ),
    );
  }
}

Widget welcomeUser = Container(
    padding: const EdgeInsets.all(32),
    child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Welcome Atenean!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                )),
            Text('Are you ready to start the sem?',
                style: TextStyle(fontSize: 16))
          ],
        )));
