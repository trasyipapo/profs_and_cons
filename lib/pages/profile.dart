import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
//import 'package:profs_and_cons/models/professor.dart';
//import 'package:profs_and_cons/objects/reviewcard.dart';
//import 'package:profs_and_cons/pages/home.dart';
import 'package:profs_and_cons/pages/revlist.dart';
import 'package:profs_and_cons/styles.dart';
import 'package:profs_and_cons/objects/professor.dart';
import 'package:profs_and_cons/pages/search.dart';

class Profile extends StatefulWidget {
  Professor professor;

  Profile({Key? key, required this.professor}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState(professor: professor);
}

class _ProfileState extends State<Profile> {
  Professor professor;
  _ProfileState({required this.professor});

  List courses = <String>["Test", "Test1"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.search),
            color: Colors.black87,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchPage()));
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
            Container(
                padding: const EdgeInsets.fromLTRB(25, 32, 25, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(professor.name, style: header),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(professor.overallRating.toString(),
                              style: overallRating),
                          const Text('Overall Rating', style: bodyText)
                        ])
                  ],
                )),
            reviewButton,
            coursesTaught, // replacing now
            // ListView(children: [],),
            // averageRatings => replaced with this thing below
            Container(
                padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Average Ratings', style: header2),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(32, 10, 32, 0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Teaching Skill'),
                                    ratingBar(professor.teachingRating)
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Personality'),
                                    ratingBar(professor.personalityRating)
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Grading'),
                                    ratingBar(professor.gradingRating)
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Workload'),
                                    ratingBar(professor.workloadRating)
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Leniency'),
                                    ratingBar(professor.leniencyRating)
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Attendance'),
                                    ratingBar(professor.attendanceRating)
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Feedback'),
                                    ratingBar(professor.feedbackRating)
                                  ],
                                )
                              ]))
                    ])),
            Container(
                margin: const EdgeInsets.fromLTRB(25, 10, 25, 32),
                child: TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.all(20)),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RevList()),
                    );
                  },
                ))
          ],
        ),
      ),
    );
  }
}

// Widget profInfo = Container(
//     padding: const EdgeInsets.fromLTRB(25, 32, 25, 0),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         const Text('Juan Dela Cruz', style: header),
//         Column(crossAxisAlignment: CrossAxisAlignment.end, children: const [
//           Text('4.5', style: overallRating),
//           Text('Overall Rating', style: bodyText)
//         ])
//       ],
//     ));

Widget reviewButton = Container(
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

// Widget averageRatings = Container(
//     padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
//     child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       const Text('Average Ratings', style: header2),
//       Padding(
//           padding: const EdgeInsets.fromLTRB(32, 10, 32, 0),
//           child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [const Text('Teaching Skill'), ratingBar(4)],
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [const Text('Personality'), ratingBar(3)],
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [const Text('Grading'), ratingBar(4)],
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [const Text('Workload'), ratingBar(3)],
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [const Text('Leniency'), ratingBar(5)],
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [const Text('Attendance'), ratingBar(4)],
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [const Text('Feedback'), ratingBar(4)],
//                 )
//               ]))
//     ]));

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

// Widget seeReviewButton = Container(
//     margin: const EdgeInsets.fromLTRB(25, 10, 25, 32),
//     child: TextButton(
//       style: ButtonStyle(
//         padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(20)),
//       ),
//       child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
//         Text(
//           'See reviews',
//           style: TextStyle(fontSize: 15.0),
//         ),
//         SizedBox(width: 5),
//         Icon(
//           Icons.keyboard_arrow_right_sharp,
//           size: 20,
//         ),
//       ]),
//       onPressed: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => const RevList()),
//         );
//       },
//     ));
