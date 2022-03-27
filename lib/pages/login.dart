import 'package:flutter/material.dart';
import 'package:profs_and_cons/pages/search.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Welcome to Flutter',
        home: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            centerTitle: false,
            backgroundColor: Colors.transparent,
            title: const Text(
              'Profs and Cons',
              textAlign: TextAlign.left,
            ),
          ),
          body: Container(
            constraints: const BoxConstraints.expand(),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/bg-image.png"),
                    fit: BoxFit.cover)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                welcomeUser,
                Container(
                    margin: EdgeInsets.all(25),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.all(20)),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red)),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            ImageIcon(AssetImage("assets/google-g.png"),
                                size: 20),
                            SizedBox(width: 15),
                            Text(
                              'Continue with Google',
                              style: TextStyle(fontSize: 20.0),
                            )
                          ]),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Home()),
                        );
                      },
                    ))
              ],
            ),
          ),
        ));
  }
}

Widget welcomeUser = Container(
    padding: const EdgeInsets.all(32),
    child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('''Welcome,
Atenean!''',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 34,
                    color: Colors.white)),
            Text('''

Are you ready to start the sem?''',
                style: TextStyle(fontSize: 16, color: Colors.white))
          ],
        )));

Widget loginButton = Container(
    margin: EdgeInsets.all(25),
    child: ElevatedButton(
      style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(20)),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
        ImageIcon(AssetImage("assets/google-g.png"), size: 20),
        SizedBox(width: 15),
        Text(
          'Continue with Google',
          style: TextStyle(fontSize: 20.0),
        )
      ]),
      onPressed: () {},
    ));
