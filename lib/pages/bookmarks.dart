import 'package:flutter/material.dart';
import 'package:profs_and_cons/pages/search.dart';
import 'package:profs_and_cons/styles.dart';
import 'package:profs_and_cons/main.dart';
import 'package:profs_and_cons/pages/profile.dart';
import 'package:profs_and_cons/data/professor_api.dart';
import 'package:profs_and_cons/objects/professor.dart';
import 'package:profs_and_cons/objects/user.dart';
import 'dart:convert';
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchPage()),
                    );
                  }),
              actions: [
                IconButton(
                  icon: Image.asset('assets/appbar-logo.png'),
                  padding: const EdgeInsets.fromLTRB(0, 8.0, 18.0, 8.0),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchPage()),
                    );
                  },
                ),
              ],
              centerTitle: false,
              backgroundColor: Colors.white,
              title: const Text(
                'Profs and Cons',
                textAlign: TextAlign.left,
              ),
            ),
            body: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                                              professor:
                                                                  prof)));
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
                    ]))));
  }
}