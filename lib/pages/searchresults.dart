import 'package:flutter/material.dart';
import 'package:profs_and_cons/pages/home.dart';
import 'package:profs_and_cons/styles.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

List<Professor> professors = [];
List titles = [];
List ratings = [];

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

  // final titles = const ["Juan Bernardo", "Juan Dela Cruz", "Juan Garcia"];
  @override
  Widget build(BuildContext context) {
    // getData();
    print("hellaehlhelhe");
    print(titles);
    // print("HELLO" + data[0]["middle_name"]);
    return MaterialApp(
        title: 'Professor Profile Screen',
        home: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  icon: const Icon(Icons.search),
                  color: Colors.black87,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Home()));
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
                          itemCount: titles.length,
                          itemBuilder: (context, index) {
                            return Card(
                                child: ListTile(
                                    title:
                                        Text(titles[index], style: resultName),
                                    // subtitle: Text(subtitles[index]),
                                    trailing: Text(ratings[index],
                                        style: resultsRating)));
                          })
                    ]))));
  }

  Future getData() async {
    // titles = [];
    // ratings = [];

    var url = 'https://profsandcons.000webhostapp.com/allprofs.php';
    http.Response response = await http.get(Uri.parse(url));
    var data = json.decode(response.body);
    professors =
        await data.map<Professor>((json) => Professor.fromJson(json)).toList();
    print(data[1]["first_name"] + " " + data[1]["overall_ave"]);
    // print(professors[0].firstName);
    for (var i = 0; i < professors.length; i++) {
      print(professors[i].firstName);
      titles.add(professors[i].firstName + " " + professors[i].lastName);
      ratings.add(professors[i].overallRating);
    }
    print(titles);
    print("HELLO WORLD");
  }
}

class Professor {
  int id;
  String firstName;
  String lastName;
  String overallRating;

  Professor(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.overallRating});

  factory Professor.fromJson(Map<String, dynamic> json) {
    return Professor(
      id: int.parse(json['professor_id']),
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      overallRating: json['overall_ave'] as String,
    );
  }
}
