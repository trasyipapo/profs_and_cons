import 'package:flutter/material.dart';
import 'package:profs_and_cons/pages/searchresults.dart';
import 'package:profs_and_cons/provider/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final myController = TextEditingController();
  @override
  void _printLatestValue() {
    print('Second text field: ${myController.text}');
  }

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    myController.addListener(_printLatestValue);
  }

  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Spacer(),
              Container(
                  padding: const EdgeInsets.all(32),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hello,\n' + user!.displayName! + '!',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                  color: Colors.white)),
                          Text('''

Let's search for your profs''',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white))
                        ],
                      ))),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  onSubmitted: (String str) {
                    _printLatestValue();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchResults()),
                    );
                    //print whats there
                  },
                  controller: myController,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(25.0)))),
                ),
              ),
              Spacer(),
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        minimumSize: const Size.fromHeight(50)),
                    onPressed: () {
                      final provider = Provider.of<GoogleSignInProvider>(
                          context,
                          listen: false);
                      provider.logout();
                    },
                    child: Text(
                      'Logout',
                      style: TextStyle(
                          fontFamily: 'GoogleSans',
                          fontWeight: FontWeight.normal,
                          fontSize: 20),
                    ),
                  ))
            ])));
  }
}
