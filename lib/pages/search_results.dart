import 'package:flutter/material.dart';
import 'package:profs_and_cons/pages/search.dart';
import 'package:profs_and_cons/styles.dart';
import 'package:profs_and_cons/pages/profile.dart';
import 'package:profs_and_cons/pages/bookmarks.dart';
import 'package:profs_and_cons/objects/professor.dart';
import 'package:profs_and_cons/pages/userRevs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Stream<List<Professor>> readProfs() => FirebaseFirestore.instance
    .collection('professors')
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => Professor.fromJson(doc.data())).toList());

class SearchResults extends StatefulWidget {
  String query;
  SearchResults({Key? key, required this.query}) : super(key: key);

  @override
  State<SearchResults> createState() => _SearchResultsState(query: query);
}

class _SearchResultsState extends State<SearchResults> {
  String query;
  _SearchResultsState({required this.query});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Professor Profile Screen',
        home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Color.fromARGB(255, 52, 55, 58),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SearchPage()));
                }),
            backgroundColor: Color.fromARGB(255, 248, 249, 255),
          ),
          body: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    query == ""
                        ? const Text('Showing All Professors', style: header)
                        : const Text('Search results for'),
                    if (query != "") Text(query, style: header),
                    const SizedBox(height: 10),
                    StreamBuilder<List<Professor>>(
                      stream: readProfs(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text(
                              'Something went wrong...${snapshot.error}');
                        } else if (snapshot.hasData) {
                          List<Professor> professors = snapshot.data!;
                          List<Professor> filteredProfs = [];
                          filteredProfs.addAll(professors);
                          filteredProfs.retainWhere((prof) => prof.name
                              .toLowerCase()
                              .contains(query.toLowerCase()));
                          if (filteredProfs.length == 0) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      120, 56, 120, 24),
                                  child: Image.asset('assets/empty.png'),
                                ),
                                const Text(
                                    "Sorry, we couldn't find any matches",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 32,
                                        color: Color.fromARGB(255, 52, 55, 58))),
                                const Text('\n',
                                    style: TextStyle(
                                        fontSize: 5, color: Color.fromARGB(255, 248, 249, 255))),
                                const Text('Please try another keyword',
                                    style: TextStyle(
                                        fontSize: 16, color: Color.fromARGB(255, 52, 55, 58))),
                              ],
                            );
                          } else {
                            return Expanded(
                                child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: filteredProfs.length,
                              itemBuilder: (context, index) {
                                final prof = filteredProfs[index];
                                return Card(
                                    child: ListTile(
                                  title: Text(prof.name, style: resultName),
                                  subtitle: Text(prof.department),
                                  trailing: Text(
                                      prof.overallRating.toStringAsFixed(2),
                                      style: resultsRating),
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => Profile(
                                                  professor: prof,
                                                  query: query,
                                                  prevPage: 1,
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
                    )
                  ])),
          bottomNavigationBar: BottomNavigationBar(
            onTap: (value) {
              if (value == 0) {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Bookmarks()));
              } else if (value == 1) {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SearchPage()));
              } else if (value == 2) {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => OwnReviews()));
              }
            },
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
            selectedItemColor: Colors.grey[600],
          ),
        ));
  }
}
