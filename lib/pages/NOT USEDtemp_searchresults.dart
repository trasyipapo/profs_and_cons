import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:profs_and_cons/objects/professor.dart';
import 'package:profs_and_cons/pages/profile.dart';
import 'package:profs_and_cons/pages/search.dart';

class TempSearchResults extends StatefulWidget {
  @override
  State<TempSearchResults> createState() => _TempSearchResultsState();
}

class _TempSearchResultsState extends State<TempSearchResults> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          backgroundColor: Colors.transparent,
          title: const Text(
            'Profs and Cons',
            textAlign: TextAlign.left,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  print("You clicked search");
                  showSearch(context: context, delegate: MySearchDelegate());
                },
                icon: const Icon(Icons.search))
          ],
        ),
//         body: StreamBuilder<List<Professor>>(
//           stream: readProfs(),
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               return Text('Something went wrong...');
//             } else if (snapshot.hasData) {
//               final professors = snapshot.data!;

//               return ListView(children: professors.map(buildProf).toList());
//             } else {
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//           },
//         ),
      );
}

class MySearchDelegate extends SearchDelegate {
  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SearchPage()),
          );
        },
      );

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              if (query.isEmpty) {
                close(context, null);
              } else {
                query = '';
              }
            })
      ];

  @override
  Widget buildResults(BuildContext context) => StreamBuilder<List<Professor>>(
        stream: readProfs(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong...');
          } else if (snapshot.hasData) {
            List<Professor> professors = snapshot.data!;
            List<Professor> filteredProfs = [];
            filteredProfs.addAll(professors);
            filteredProfs.retainWhere((prof) =>
                prof.name.toLowerCase().contains(query.toLowerCase()));

            return ListView.builder(
              itemCount: filteredProfs.length,
              itemBuilder: (context, index) {
                final prof = filteredProfs[index];
                return Card(
                    child: ListTile(
                  title: Text(prof.name),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Profile(professor: prof)));
                  },
                ));
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );

  @override
  Widget buildSuggestions(BuildContext context) =>
      StreamBuilder<List<Professor>>(
        stream: readProfs(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong...');
          } else if (snapshot.hasData) {
            List<Professor> professors = snapshot.data!;
            List<Professor> filteredProfs = [];
            filteredProfs.addAll(professors);
            filteredProfs.retainWhere((prof) =>
                prof.name.toLowerCase().contains(query.toLowerCase()));

            return ListView.builder(
              itemCount: filteredProfs.length,
              itemBuilder: (context, index) {
                final prof = filteredProfs[index];
                return Card(
                    child: ListTile(
                  title: Text(prof.name),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Profile(professor: prof)));
                  },
                ));
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );

  Stream<List<Professor>> readProfs() => FirebaseFirestore.instance
      .collection('professors')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Professor.fromJson(doc.data())).toList());

  // Widget buildProf(Professor prof) => ListTile(
  //       title: Text(prof.name),
  //       // onTap: () {
  //       //   Navigator.push(context,
  //       //       MaterialPageRoute(builder: (context) => const Profile()));
  //       // },
  //     );
}
