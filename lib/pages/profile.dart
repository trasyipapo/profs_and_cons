import 'package:flutter/material.dart';
import 'package:profs_and_cons/pages/home.dart';
import 'package:profs_and_cons/styles.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Professor Profile Screen',
        home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.search),
                color: Colors.black87,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Home()));
                }),
            centerTitle: false,
            backgroundColor: Colors.white,
            title: const Text(
              'Profs and Cons',
              textAlign: TextAlign.left,
            ),
          ),
          body: Container(
            constraints: const BoxConstraints.expand(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [profInfo, reviewButton, classesTaught],
            ),
          ),
        ));
  }
}

Widget profInfo = Container(
    padding: const EdgeInsets.all(32),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Juan Dela Cruz', style: header),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: const [
          Text('4.5', style: overallRating),
          Text('Overall Rating', style: bodyText)
        ])
      ],
    ));

Widget reviewButton = Container(
    padding: const EdgeInsets.all(32),
    child: ElevatedButton(
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(20)),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
          Text(
            'Add new review',
            style: TextStyle(fontSize: 20.0),
          )
        ]),
        onPressed: () {}));
