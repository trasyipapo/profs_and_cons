import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:profs_and_cons/objects/professor.dart';
import 'package:profs_and_cons/pages/revlist.dart';
import 'package:profs_and_cons/pages/search.dart';
import 'package:profs_and_cons/styles.dart';
import 'package:profs_and_cons/objects/review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:profs_and_cons/pages/edit_form.dart';

class FullReview extends StatefulWidget {
  Review review;
  Professor professor;
  FullReview({Key? key, required this.review, required this.professor})
      : super(key: key);

  @override
  State<FullReview> createState() =>
      _FullReviewState(review: review, professor: professor);
}

class _FullReviewState extends State<FullReview> {
  Review review;
  Professor professor;
  _FullReviewState({required this.review, required this.professor});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Full Review Screen',
        home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Colors.black87,
                onPressed: () {
                  Navigator.pop(context);
                }),
            actions: [
              IconButton(
                icon: Image.asset('assets/appbar-logo.png'),
                padding: const EdgeInsets.fromLTRB(0, 8.0, 18.0, 8.0),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchPage()),
                  );
                },
              ),
            ],
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
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    padding: const EdgeInsets.fromLTRB(25, 32, 25, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text(professor.name, style: header)],
                    )),
                Card(child: reviewDetails(review, professor, context))
              ],
            ),
          ),
        ));
  }
}

// Widget profName = Container(
//     padding: const EdgeInsets.fromLTRB(25, 32, 25, 0),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [const Text(professor.name, style: header)],
//     ));

Widget reviewDetails(Review review, Professor prof, context) => Container(
    padding: const EdgeInsets.fromLTRB(25, 32, 25, 32),
    child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            StatefulBuilder(
              builder: (context, setState) => Row(children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        review.votes += 1;
                      });
                      final collection =
                          FirebaseFirestore.instance.collection('reviews');
                      collection
                          .doc(review.id)
                          .update({'votes': review.votes})
                          .then((_) => debugPrint('Updated'))
                          .catchError(
                              (error) => debugPrint('Update Failed: $error'));
                    },
                    color: Colors.grey,
                    iconSize: 20,
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.arrow_upward)),
                Text(
                  review.votes.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 15,
                      color: Colors.grey),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        review.votes -= 1;
                      });
                      final collection =
                          FirebaseFirestore.instance.collection('reviews');
                      collection
                          .doc(review.id)
                          .update({'votes': review.votes})
                          .then((_) => debugPrint('Updated'))
                          .catchError(
                              (error) => debugPrint('Update Failed: $error'));
                    },
                    color: Colors.grey,
                    iconSize: 20,
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.arrow_downward)),
              ]),
            ),
            ratingBar(review.overallRating!)
          ]),
          SizedBox(height: 24),
          Text('${review.title}', style: header2),
          SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.start,
            spacing: 5,
            children: [
              Text(review.anonymous ? 'Anonymous Reviewer' : '${review.writer}',
                  style: smallText),
              Text(
                  review.semesterTaken! == '0'
                      ? 'Intersession'
                      : review.semesterTaken! == '1'
                          ? '1st Sem'
                          : '2nd Sem',
                  style: smallText),
              Text('${review.yearTaken}', style: smallText),
            ],
          ),
          SizedBox(height: 15),
          Text(
            '${review.description}',
            style: bodyText,
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Teaching Skill'),
              ratingBar(review.teachingRating!)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Personality'),
              ratingBar(review.personalityRating!)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text('Grading'), ratingBar(review.gradingRating!)],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Workload'),
              ratingBar(review.workloadRating!)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Leniency'),
              ratingBar(review.leniencyRating!)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Attendance'),
              ratingBar(review.attendanceRating!)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Feedback'),
              ratingBar(review.feedbackRating!)
            ],
          ),
          SizedBox(height: 15),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Wrap(spacing: 10, children: [
              DecoratedBox(
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Text('${review.courses}', style: buttonText))),
            ]),
            IconButton(
              icon: Icon(Icons.edit),
              disabledColor: Colors.white,
              onPressed: () {
                user!.displayName! != review.writer
                    ? null
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditForm(
                                  professor: prof,
                                  review: review,
                                )));
              },
            ),
          ]),
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
