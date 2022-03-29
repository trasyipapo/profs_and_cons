import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:profs_and_cons/pages/profile.dart';
import 'package:profs_and_cons/pages/fullreview.dart';
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
        reviewHead: 'Great organizational...',
        reviewer: 'Simon Garcia',
        counter: 24,
        stars: 5,
        courseCode: ['CSCI 42']),
    ReviewCard(
        reviewHead: 'Run!!!',
        reviewer: 'Anonymous',
        counter: 17,
        stars: 1,
        courseCode: ['CSCI 42', 'CSCI 115']),
  ];

  List rainbow = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple
  ];

  Widget reviewTemplate(review) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
        child: ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const FullReview()));
            },
            style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(245, 255, 255, 255),
                onPrimary: Colors.black,
                elevation: 5,
                padding: const EdgeInsets.all(0)),
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          IconButton(
                              onPressed: () {},
                              color: Colors.grey,
                              iconSize: 10,
                              padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                              constraints: const BoxConstraints(),
                              icon: const Icon(Icons.arrow_upward)),
                          Text(
                            review.counter.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 10,
                                color: Colors.grey),
                          ),
                          IconButton(
                              onPressed: () {},
                              color: Colors.grey,
                              iconSize: 10,
                              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                              constraints: const BoxConstraints(),
                              icon: const Icon(Icons.arrow_downward)),
                        ]),
                        ratingBar(review.stars),
                      ],
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 5),
                        child: Row(children: [
                          Text(review.reviewHead,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ])),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                        child: Row(children: [
                          Text(review.reviewer,
                              style: const TextStyle(
                                fontSize: 8,
                                color: Colors.grey,
                              )),
                        ])),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            for (var i = 0; i < review.courseCode.length; i++)
                              // for (var i in review.courseCode)
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                  child: Container(
                                      color: rainbow[i % 6],
                                      padding: const EdgeInsets.all(5),
                                      child: Text(
                                        review.courseCode[i],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white),
                                      )))
                          ],
                        )
                      ], // TO BE FIXED (ONLY ONE COLOR PALANG PWEDE)
                    ),
                  ],
                ))));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Professor Reviews Screen',
        home: Scaffold(
          // appBar: AppBar(
          //   leading: IconButton(
          //       icon: const Icon(Icons.search),
          //       color: Colors.black87,
          //       onPressed: () {
          //         Navigator.push(context,
          //             MaterialPageRoute(builder: (context) => const Home()));
          //       }),
          //   centerTitle: false,
          //   backgroundColor: Colors.white,
          //   title: const Text(
          //     'Profs and Cons',
          //     textAlign: TextAlign.left,
          //   ),
          // ),
          appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Colors.black87,
                onPressed: () {
                  Navigator.pop(context);
                }),
            actions: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8.0, 18.0, 8.0),
                child: Image.asset('assets/appbar-logo.png'),
              ),
            ],
            centerTitle: false,
            backgroundColor: Colors.white,
            title: const Text(
              'Profs and Cons',
              textAlign: TextAlign.left,
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              profInfo,
              Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(children: [
                    reviewButton,
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: reviews
                            .map((review) => reviewTemplate(review))
                            .toList())
                  ]))
            ],
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
            value: instance.value,
            items: instance.filters.map(buildMenuItem).toList(),
            onChanged: (value) => value = value) // TO BE FIXED
      ],
    ));

Widget reviewButton = Container(
    margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
    child: ElevatedButton(
        style: ButtonStyle(
            padding:
                MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(10)),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
          Text(
            'Add new review',
            style: TextStyle(fontSize: 20.0),
          )
        ]),
        onPressed: () {}));

RatingBar ratingBar(double rating) {
  return RatingBar(
      initialRating: rating,
      itemSize: 20,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      ratingWidget: RatingWidget(
          full: const Icon(Icons.star, color: Colors.blue),
          half: const Icon(
            Icons.star_half,
            color: Colors.blue,
          ),
          empty: const Icon(
            Icons.star,
            color: Colors.black38,
          )),
      onRatingUpdate: (value) {}
      //   setState(() {
      //     _ratingValue = value;
      // }
      );
}
