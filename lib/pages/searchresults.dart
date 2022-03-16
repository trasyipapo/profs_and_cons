import 'package:flutter/material.dart';
import 'package:profs_and_cons/pages/home.dart';
import 'package:profs_and_cons/styles.dart';
import 'package:profs_and_cons/main.dart';
import 'package:profs_and_cons/pages/profile.dart';
import 'package:profs_and_cons/data/professor_api.dart';
import 'package:profs_and_cons/models/professor.dart';
import 'dart:convert';

List<Professor> professors = [];

class SearchResults extends StatefulWidget {
  const SearchResults({Key? key}) : super(key: key);

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getData() async {
    ProfessorApi.getProfessor().then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        professors = list.map((model) => Professor.fromJson(model)).toList();
      });
    });
  }

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
                    Navigator.pushNamed(context, '/profile');
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
                      const Text('Juan', style: header),
                      const SizedBox(height: 10),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: professors.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Profile()));
                                },
                                child: Card(
                                    child: ListTile(
                                        title: Text(
                                            professors[index].firstName +
                                                " " +
                                                professors[index].lastName,
                                            style: resultName),
                                        subtitle:
                                            Text(professors[index].department),
                                        trailing: Text(
                                            professors[index]
                                                .overallRating
                                                .toStringAsFixed(2),
                                            style: resultsRating))));
                          })
                    ]))));
  }
}
