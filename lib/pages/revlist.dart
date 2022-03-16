import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:profs_and_cons/pages/home.dart';
import 'package:profs_and_cons/styles.dart';
import 'package:profs_and_cons/objects/reviewcard.dart';

class RevList extends StatefulWidget {
  const RevList({Key? key}) : super(key: key);

  @override
  State<RevList> createState() => _RevListState();
}

class _RevListState extends State<RevList> {
  final filters = ['FILTER', 'FILTER 2', 'FILTER 3'];
  String? value = 'FILTER'; // TO BE FIXED

  List<ReviewCard> reviews = [
    ReviewCard(
        reviewHead: 'Great!',
        reviewer: 'Anonymous',
        counter: 24,
        stars: 5,
        courseCode: '2323'),
    ReviewCard(
        reviewHead: 'Run!!!',
        reviewer: 'Anonymous din',
        counter: 2424,
        stars: 1,
        courseCode: '232323'),
  ];

  Widget reviewTemplate(review) {
    return Card(
        margin: const EdgeInsets.all(5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(review.counter.toString()),
                Text(review.stars.toString())
              ],
            ),
            Text(review.reviewHead),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [Text(review.courseCode), Text(review.courseCode)],
            ),
          ],
        ));
  }

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
                Column(
                    children: reviews
                        .map((review) => reviewTemplate(review))
                        .toList())
                // reviewCard,
              ],
            ),
          ),
        ));
  }
}
// Column(
//                 children:
//                     reviews.map((review) => reviewTemplate(review)).toList())

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
            value: instance.value,
            items: instance.filters.map(buildMenuItem).toList(),
            onChanged: (value) => value = value) // TO BE FIXED
      ],
    ));

Widget reviewButton = Container(
    margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
    padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
    child: ElevatedButton(
        style: ButtonStyle(
            padding:
                MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(20)),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
          Text(
            'Add new review',
            style: TextStyle(fontSize: 20.0),
          )
        ]),
        onPressed: () {}));

// Widget reviewCard = Container(
//     color: Colors.blue,
//     width: 325, // HARDCODED TO BE FIXED
//     // padding: const EdgeInsets.all(50),
//     margin: const EdgeInsets.all(5),
//     child: Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [counter, stars],
//         ),
//         reviewHead,
//         Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [courseCode, courseCode],
//         ),
//       ],
//     ));

// Widget courseCode = Container(
//   color: const Color.fromARGB(255, 255, 30, 0),
//   child: const Text('courseCode'),
//   width: 50,
//   margin: const EdgeInsets.all(10),
// );

// Widget counter = Container(
//   color: const Color.fromARGB(225, 97, 247, 60),
//   child: const Text('counter'),
//   width: 50,
//   margin: const EdgeInsets.all(10),
// );

// Widget stars = Container(
//   alignment: Alignment.topLeft,
//   color: Colors.yellow,
//   width: 35,
//   margin: const EdgeInsets.all(5),
//   child: const Text('stars'),
// );

// Widget reviewHead = Container(
//   alignment: Alignment.topLeft,
//   color: const Color.fromARGB(255, 216, 59, 255),
//   margin: const EdgeInsets.all(5),
//   child: const Text('reviewHead'),
// );
