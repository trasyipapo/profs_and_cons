import 'package:flutter/material.dart';
import 'package:profs_and_cons/provider/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:profs_and_cons/pages/temp_addprof.dart';
import 'package:profs_and_cons/pages/temp_searchresults.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final myController = TextEditingController();

  void _printLatestValue() {
    print('You typed: ${myController.text}');
  }

  String _searchLatestValue() {
    return (myController.text);
  }

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    myController.addListener(_printLatestValue);
  }

  @override
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
              const Spacer(),
              Container(
                  padding: const EdgeInsets.all(32),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hello,\n' + user!.displayName! + '!',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                  color: Colors.white)),
                          const Text('Let\'s search for your profs',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white))
                        ],
                      ))),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  onSubmitted: (String str) {
                    var profQuery = _searchLatestValue(); //prints
                    showSearch(
                        context: context,
                        delegate: MySearchDelegate(),
                        query: profQuery);
                  },
                  // onSubmitted: (String str) {
                  //   _printLatestValue();
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const SearchResults()),
                  //   );
                  //   //print whats there
                  // },
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
              const Spacer(),
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        minimumSize: const Size.fromHeight(50)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TempSearchResults()),
                      );
                    },
                    child: const Text(
                      'Search Professors',
                      style: TextStyle(
                          fontFamily: 'GoogleSans',
                          fontWeight: FontWeight.normal,
                          fontSize: 20),
                    ),
                  )),
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        minimumSize: const Size.fromHeight(50)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddProf()),
                      );
                    },
                    child: const Text(
                      'Add Professor',
                      style: TextStyle(
                          fontFamily: 'GoogleSans',
                          fontWeight: FontWeight.normal,
                          fontSize: 20),
                    ),
                  )),
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
                    child: const Text(
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

// class Home extends StatefulWidget {
//   const Home({Key? key}) : super(key: key);

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   final myController = TextEditingController();
//   @override
//   void _printLatestValue() {
//     print('Second text field: ${myController.text}');
//   }

//   @override
//   void initState() {
//     super.initState();

//     // Start listening to changes.
//     myController.addListener(_printLatestValue);
//   }

//   void dispose() {
//     // Clean up the controller when the widget is removed from the
//     // widget tree.
//     myController.dispose();
//     super.dispose();
//   }

// }

Future queryData(String queryString) async {
  return FirebaseFirestore.instance
      .collection('professors')
      .where('name', isGreaterThanOrEqualTo: queryString)
      .get();
}