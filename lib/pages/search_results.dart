import 'dart:html';

import 'package:flutter/material.dart';
import 'package:profs_and_cons/pages/search.dart';
import 'package:profs_and_cons/styles.dart';
import 'package:profs_and_cons/main.dart';
import 'package:profs_and_cons/pages/profile.dart';
import 'package:profs_and_cons/data/professor_api.dart';
import 'package:profs_and_cons/objects/professor.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

List<Professor> professors = [];

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
                  icon: const Icon(Icons.search),
                  color: Colors.black87,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchPage()),
                    );
                  }),
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
                      const Text('Search results for'),
                      Text(query, style: header),
                      const SizedBox(height: 10),
                      StreamBuilder<List<Professor>>(
                        stream: readProfs(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('Something went wrong...');
                          } else if (snapshot.hasData) {
                            List<Professor> professors = snapshot.data!;
                            List<Professor> filteredProfs = [];
                            filteredProfs.addAll(professors);
                            filteredProfs.retainWhere((prof) => prof.name
                                .toLowerCase()
                                .contains(query.toLowerCase()));
                            if (filteredProfs.length == 0) {
                              return const Text('No results found');
                            } else {
                              return ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: filteredProfs.length,
                                itemBuilder: (context, index) {
                                  final prof = filteredProfs[index];
                                  return Card(
                                      child: ListTile(
                                    title: Text(prof.name),
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Profile(professor: prof)));
                                    },
                                  ));
                                },
                              );
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
