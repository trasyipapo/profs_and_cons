import 'package:flutter/material.dart';
import 'package:profs_and_cons/pages/bookmarks.dart';
import 'package:profs_and_cons/pages/userRevs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:profs_and_cons/pages/temp_addprof.dart';
import 'package:profs_and_cons/objects/professor.dart';
import 'package:profs_and_cons/pages/search_results.dart';

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

  List<Professor> profs = [];

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

  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    String displayName = user!.displayName!;
    final nameSplit = displayName.split(' ');
    final firstName =
        nameSplit[0][0].toUpperCase() + nameSplit[0].substring(1).toLowerCase();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(6.0, 0, 150.0, 0),
          child: Image.asset('assets/home-logo.png'),
        ),
        leadingWidth: 500,
      ),
      body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/bg-image.png"), fit: BoxFit.cover)),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Spacer(),
            Container(
                padding: const EdgeInsets.fromLTRB(25, 50, 25, 25),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hello,\n' + firstName + '!',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 32,
                                color: Color.fromARGB(255, 248, 249, 255))),
                        const Text('\n',
                            style: TextStyle(fontSize: 5, color: Color.fromARGB(255, 248, 249, 255))),
                        const Text('Let\'s search for your profs',
                            style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 248, 249, 255)))
                      ],
                    ))),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: TextField(
                  textInputAction: TextInputAction.search,
                  controller: myController,
                  onSubmitted: (String query) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SearchResults(query: query)));
                  },
                  cursorColor: Color.fromARGB(255, 74, 117, 182),
                  cursorHeight: 20,
                  cursorWidth: 2,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color.fromARGB(255, 52, 55, 58),
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 248, 249, 255),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Color.fromARGB(255, 74, 117, 182), width: 2.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: "Search",
                  )),
            ),
            const Spacer(),

            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong...${snapshot.error}');
                  } else if (snapshot.hasData) {
                    print(snapshot.data['isAdmin']);
                    return Visibility(
                      visible: snapshot.data['isAdmin'] == true,
                      child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(255, 239, 108, 108),
                                minimumSize: const Size.fromHeight(50)),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddProf()),
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
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ])),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (onTappedBar) {
          if (onTappedBar == 0) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Bookmarks()));
          } else if (onTappedBar == 1) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => SearchPage()));
          } else if (onTappedBar == 2) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => OwnReviews()));
          }
        },
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.bookmark),
            label: 'Bookmarks',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Color.fromARGB(255, 74, 117, 182),
      ),
    );
  }
}

Future queryData(String queryString) async {
  return FirebaseFirestore.instance
      .collection('professors')
      .where('name', isGreaterThanOrEqualTo: queryString)
      .get();
}
