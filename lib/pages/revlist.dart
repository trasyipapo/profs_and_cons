import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:profs_and_cons/pages/home.dart';
import 'package:profs_and_cons/styles.dart';

class RevList extends StatefulWidget {
  const RevList({Key? key}) : super(key: key);

  @override
  State<RevList> createState() => _RevListState();
}

class _RevListState extends State<RevList> {
  final filters = ['Filter 1', 'Filter 2'];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Professor Reviews Screen',
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
          body: Container(
            constraints: const BoxConstraints.expand(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                profInfo,
                reviewButton,
              ],
            ),
          ),
        ));
  }
}

DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
      value: item,
      child: Text(item),
    );

var instance = _RevListState();
Widget profInfo = Container(
    padding: const EdgeInsets.fromLTRB(25, 32, 25, 0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Juan Dela Cruz', style: header),
        DropdownButton<String>(
            items: instance.filters.map(buildMenuItem).toList(),
            onChanged: onChanged)
      ],
    ));

Widget reviewButton = Container(
    padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
    child: ElevatedButton(
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(20)),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
          Text(
            'Add new review',
            style: TextStyle(fontSize: 20.0),
          )
        ]),
        onPressed: () {}));

void onChanged(String? value) {}
