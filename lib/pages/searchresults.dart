import 'package:flutter/material.dart';
import 'package:profs_and_cons/pages/home.dart';
import 'package:profs_and_cons/styles.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchResults extends StatelessWidget {
  const SearchResults({Key? key}) : super(key: key);

  final titles = const ["Juan Bernardo", "Juan Dela Cruz", "Juan Garcia"];
  // final subtitles = const [
  //   "Here is list 1 subtitle",
  //   "Here is list 2 subtitle",
  //   "Here is list 3 subtitle"
  // ];
  final ratings = const ["4.2", "2.1", "3.9"];
  @override
  Widget build(BuildContext context) {
    getData();
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

  Future<dynamic> getData() async {
    var url = 'https://profsandcons.000webhostapp.com/allprofs.php';
    http.Response response = await http.get(Uri.parse(url));
    var data = json.decode(response.body);
    print(data[1]["first_name"] + " " + data[1]["last_name"]);
    print("HELLO WORLD");
  }

  // @override
  // void initState() {
  //   getData();
  // }
}
