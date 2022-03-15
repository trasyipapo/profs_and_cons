import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:profs_and_cons/pages/home.dart';
import 'package:profs_and_cons/styles.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                profInfo,
                reviewButton,
                coursesTaught,
                averageRatings,
                seeReviewButton
              ],
            ),
          ),
        ));
  }
}

Widget profInfo = Container(
    padding: const EdgeInsets.fromLTRB(25, 32, 25, 0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Juan Dela Cruz', style: header),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: const [
          Text('4.5', style: overallRating),
          Text('Overall Rating', style: bodyText)
        ])
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

Widget coursesTaught = Container(
    padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Courses Taught', style: header2),
      const SizedBox(height: 10),
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Wrap(spacing: 10, children: [
          DecoratedBox(
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(5)),
              child: const Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Text('CSCI 115', style: buttonText))),
          DecoratedBox(
              decoration: BoxDecoration(
                  color: Colors.yellow, borderRadius: BorderRadius.circular(5)),
              child: const Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Text('CSCI 42', style: buttonText))),
          DecoratedBox(
              decoration: BoxDecoration(
                  color: Colors.green, borderRadius: BorderRadius.circular(5)),
              child: const Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Text(
                    'CSCI 21',
                    style: buttonText,
                  )))
        ])
      ])
    ]));

Widget averageRatings = Container(
    padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Average Ratings', style: header2),
      Padding(
          padding: const EdgeInsets.fromLTRB(32, 10, 32, 0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [const Text('Teaching Skill'), ratingBar(4)],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [const Text('Personality'), ratingBar(3)],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [const Text('Grading'), ratingBar(4)],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [const Text('Workload'), ratingBar(3)],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [const Text('Leniency'), ratingBar(5)],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [const Text('Attendance'), ratingBar(4)],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [const Text('Feedback'), ratingBar(4)],
                )
              ]))
    ]));

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

Widget seeReviewButton = Container(
    margin: const EdgeInsets.fromLTRB(25, 10, 25, 32),
    child: TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(20)),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
        Text(
          'See reviews',
          style: TextStyle(fontSize: 15.0),
        ),
        SizedBox(width: 5),
        Icon(
          Icons.keyboard_arrow_right_sharp,
          size: 20,
        ),
      ]),
      onPressed: () {},
    ));