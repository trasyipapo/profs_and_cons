import 'package:flutter/material.dart';
import 'package:profs_and_cons/pages/search.dart';
import 'package:profs_and_cons/styles.dart';
import 'package:profs_and_cons/pages/profile.dart';
import 'package:profs_and_cons/objects/professor.dart';
import 'package:profs_and_cons/objects/user.dart';
import 'package:profs_and_cons/pages/userRevs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final user = FirebaseAuth.instance.currentUser;

Stream<List<Professor>> getProfs(List<String> bookmarks) => FirebaseFirestore
    .instance
    .collection('professors')
    .where('id', whereIn: bookmarks)
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => Professor.fromJson(doc.data())).toList());

class Bookmarks extends StatefulWidget {
  Bookmarks({
    Key? key,
  }) : super(key: key);

  @override
  State<Bookmarks> createState() => _BookmarksState();
}

class _BookmarksState extends State<Bookmarks> {
  _BookmarksState();

  int _currentIndex = 0;
  final List<Widget> _children = [
    Bookmarks(),
    SearchPage(),
    Bookmarks(),
  ];

  int onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
    return _currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Professor Profile Screen',
        home: Scaffold(
          // appBar: AppBar(
          //   // leading: IconButton(
          //   //     icon: const Icon(Icons.arrow_back),
          //   //     color: Colors.black87,
          //   //     onPressed: () {
          //   //       Navigator.of(context).push(
          //   //           MaterialPageRoute(builder: (context) => SearchPage()));
          //   //     }),
          //   backgroundColor: Colors.white,
          // ),
          body: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 70,
                    ),
                    const Text('Bookmarks of'),
                    Text(user!.displayName!, style: header),
                    const SizedBox(height: 10),
                    FutureBuilder<UserFire>(
                        future: getUser(user!.uid),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            UserFire? userObject = snapshot.data;
                            List<String> bookmarks =
                                userObject!.favorites!.split(",");
                            return StreamBuilder<List<Professor>>(
                              stream: getProfs(bookmarks),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Text(
                                      'Something went wrong...${snapshot.error}');
                                } else if (snapshot.hasData) {
                                  List<Professor> professors = snapshot.data!;
                                  if (professors.length == 0) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              120, 56, 120, 24),
                                          child: Image.asset(
                                              'assets/appbar-logo.png'),
                                        ),
                                        const Text(
                                            "Sorry, you don't have any bookmarks yet",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 32,
                                                color: Colors.black)),
                                        const Text('\n',
                                            style: TextStyle(
                                                fontSize: 5,
                                                color: Colors.white)),
                                        const Text(
                                            'Search for profs to bookmark them!',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black)),
                                      ],
                                    );
                                  } else {
                                    return Expanded(
                                        child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: professors.length,
                                      itemBuilder: (context, index) {
                                        final prof = professors[index];
                                        return Card(
                                            child: ListTile(
                                          title: Text(prof.name,
                                              style: resultName),
                                          subtitle: Text(prof.department),
                                          trailing: Text(
                                              prof.overallRating
                                                  .toStringAsFixed(2),
                                              style: resultsRating),
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Profile(
                                                          professor: prof,
                                                          prevPage: 2,
                                                        )));
                                          },
                                        ));
                                      },
                                    ));
                                  }
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            );
                          } else {
                            return Text("Error.");
                          }
                        })
                  ])),
          bottomNavigationBar: BottomNavigationBar(
            onTap: (onTappedBar) {
              if (onTappedBar == 0) {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Bookmarks()));
              } else if (onTappedBar == 1) {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SearchPage()));
              } else if (onTappedBar == 2) {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => OwnReviews()));
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
            selectedItemColor: Colors.blue,
          ),
        ));
  }
}
