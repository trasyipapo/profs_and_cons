import 'package:flutter/material.dart';
import 'package:profs_and_cons/pages/search.dart';
import 'package:profs_and_cons/styles.dart';
import 'package:profs_and_cons/main.dart';
import 'package:profs_and_cons/pages/profile.dart';
import 'package:profs_and_cons/data/professor_api.dart';
import 'package:profs_and_cons/objects/professor.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:profs_and_cons/pages/search.dart';

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
                  color: Colors.black87,
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SearchPage()));
                  }),
              backgroundColor: Colors.white,
            ),
            body: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Search results for'),
                      Text(query, style: header),
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
                                    child:
                                        Image.asset('assets/appbar-logo.png'),
                                  ),
                                  const Text(
                                      "Sorry, we couldn't find any matches",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 32,
                                          color: Colors.black)),
                                  const Text('\n',
                                      style: TextStyle(
                                          fontSize: 5, color: Colors.white)),
                                  const Text('Please try another keyword',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black)),
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
                    ]))));
  }
}
