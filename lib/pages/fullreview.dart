import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:profs_and_cons/objects/professor.dart';
import 'package:profs_and_cons/pages/revlist.dart' as revl;
import 'package:profs_and_cons/pages/search.dart';
import 'package:profs_and_cons/styles.dart';
import 'package:profs_and_cons/objects/review.dart';
import 'package:profs_and_cons/pages/bookmarks.dart';
import 'package:profs_and_cons/pages/userRevs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:profs_and_cons/pages/edit_form.dart';

Stream<List<Review>> readReviews() => FirebaseFirestore.instance
    .collection('reviews')
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => Review.fromJson(doc.data())).toList());

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
    List<String> revCourses = review.courses!.split(',');
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
            backgroundColor: Colors.white,
          ),
          body: StreamBuilder<List<Review>>(
              stream: readReviews(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong...${snapshot.error}');
                } else if (snapshot.hasData) {
                  List<Review> reviews = snapshot.data!;
                  List<Review> filteredReviews =
                      reviews.where((rev) => (rev.id == review.id)).toList();
//
                  List<String> upvoters =
                      filteredReviews[0].upvoters!.split(',');
                  List<String> downvoters =
                      filteredReviews[0].downvoters!.split(',');

                  bool isUp =
                      upvoters.any((element) => (element == revl.user!.uid));
                  bool isDown =
                      downvoters.any((element) => (element == revl.user!.uid));
                  //
                  return Container(
                    constraints: const BoxConstraints.expand(),
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            padding: const EdgeInsets.fromLTRB(25, 32, 25, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(professor.name, style: header),
                                    Text(professor.department,
                                        style: smallText),
                                  ],
                                ),
                              ],
                            )),
                        if (isUp)
                          Card(
                              child: upvotedReviewDetails(filteredReviews[0],
                                  professor, context, revCourses))
                        else if (isDown)
                          Card(
                              child: downvotedReviewDetails(filteredReviews[0],
                                  professor, context, revCourses))
                        else
                          Card(
                              child: reviewDetails(filteredReviews[0],
                                  professor, context, revCourses))
                      ],
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
          bottomNavigationBar: BottomNavigationBar(
            onTap: (value) {
              if (value == 0) {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Bookmarks()));
              } else if (value == 1) {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SearchPage()));
              } else if (value == 2) {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => OwnReviews()));
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: new Icon(Icons.bookmark),
                label: 'Bookmarks',
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            selectedItemColor: Colors.grey[600],
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

Widget reviewDetails(
        Review review, Professor prof, context, List<String> revCourses) =>
    Container(
        padding: const EdgeInsets.fromLTRB(25, 32, 25, 32),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          review.votes += 1;
                          if (review.upvoters == "") {
                            review.upvoters = review.upvoters! + revl.user!.uid;
                          } else {
                            review.upvoters =
                                review.upvoters! + ',' + revl.user!.uid;
                          }
                          final collection =
                              FirebaseFirestore.instance.collection('reviews');
                          collection
                              .doc(review.id)
                              .update({
                                'votes': review.votes,
                                'upvoters': review.upvoters
                              })
                              .then((_) => debugPrint('Updated'))
                              .catchError((error) =>
                                  debugPrint('Update Failed: $error'));
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
                          review.votes -= 1;
                          if (review.downvoters == "") {
                            review.downvoters =
                                review.downvoters! + revl.user!.uid;
                          } else {
                            review.downvoters =
                                review.downvoters! + ',' + revl.user!.uid;
                          }
                          final collection =
                              FirebaseFirestore.instance.collection('reviews');
                          collection
                              .doc(review.id)
                              .update({
                                'votes': review.votes,
                                'downvoters': review.downvoters
                              })
                              .then((_) => debugPrint('Updated'))
                              .catchError((error) =>
                                  debugPrint('Update Failed: $error'));
                        },
                        color: Colors.grey,
                        iconSize: 20,
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.arrow_downward)),
                  ],
                ),
                ratingBar(review.overallRating!.toDouble())
              ]),
              SizedBox(height: 24),
              Text('${review.title}', style: header2),
              SizedBox(height: 10),
              Wrap(
                alignment: WrapAlignment.start,
                spacing: 5,
                children: [
                  Text(
                      review.anonymous
                          ? 'Anonymous Reviewer'
                          : '${review.writer}',
                      style: smallText),
                  Text(
                      review.semesterTaken! == '1'
                          ? 'Intersession'
                          : review.semesterTaken! == '2'
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
                  ratingBar(review.teachingRating!.toDouble())
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Personality'),
                  ratingBar(review.personalityRating!.toDouble())
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Grading'),
                  ratingBar(review.gradingRating!.toDouble())
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Workload'),
                  ratingBar(review.workloadRating!.toDouble())
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Leniency'),
                  ratingBar(review.leniencyRating!.toDouble())
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Attendance'),
                  ratingBar(review.attendanceRating!.toDouble())
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Feedback'),
                  ratingBar(review.feedbackRating!.toDouble())
                ],
              ),
              SizedBox(height: 15),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                SizedBox(
                  width: 286, //HARDCODED -- TO FIX
                  height: 25,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: revCourses.length,
                    itemBuilder: (BuildContext context, int position) {
                      return Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                          child: DecoratedBox(
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Text(
                                    revCourses[position],
                                    style: buttonText,
                                  ))));
                    },
                  ),
                ),
                if (revl.user!.uid == review.writeruid)
                  IconButton(
                    icon: Icon(Icons.edit),
                    disabledColor: Colors.white,
                    onPressed: () {
                      revl.user!.uid != review.writeruid
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

Widget upvotedReviewDetails(
        Review review, Professor prof, context, List<String> revCourses) =>
    Container(
        padding: const EdgeInsets.fromLTRB(25, 32, 25, 32),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          review.votes -= 1;
                          // remove from upvoters
                          List<String> result = review.upvoters!.split(',');
                          result = result
                              .where((element) => (element != revl.user!.uid))
                              .toList();
                          final collection =
                              FirebaseFirestore.instance.collection('reviews');
                          collection
                              .doc(review.id)
                              .update({
                                'votes': review.votes,
                                'upvoters': result.join(','),
                              })
                              .then((_) => debugPrint('Updated'))
                              .catchError((error) =>
                                  debugPrint('Update Failed: $error'));
                        },
                        color: Colors.blue,
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
                          review.votes -= 2;
                          // remove from upvoters
                          List<String> result = review.upvoters!.split(',');
                          result = result
                              .where((element) => (element != revl.user!.uid))
                              .toList();
                          // add to downvoters
                          if (review.downvoters == "") {
                            review.downvoters =
                                review.downvoters! + revl.user!.uid;
                          } else {
                            review.downvoters =
                                review.downvoters! + ',' + revl.user!.uid;
                          }
                          final collection =
                              FirebaseFirestore.instance.collection('reviews');
                          collection
                              .doc(review.id)
                              .update({
                                'votes': review.votes,
                                'downvoters': review.downvoters,
                                'upvoters': result.join(',')
                              })
                              .then((_) => debugPrint('Updated'))
                              .catchError((error) =>
                                  debugPrint('Update Failed: $error'));
                        },
                        color: Colors.grey,
                        iconSize: 20,
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.arrow_downward)),
                  ],
                ),
                ratingBar(review.overallRating!.toDouble())
              ]),
              SizedBox(height: 24),
              Text('${review.title}', style: header2),
              SizedBox(height: 10),
              Wrap(
                alignment: WrapAlignment.start,
                spacing: 5,
                children: [
                  Text(
                      review.anonymous
                          ? 'Anonymous Reviewer'
                          : '${review.writer}',
                      style: smallText),
                  Text(
                      review.semesterTaken! == '1'
                          ? 'Intersession'
                          : review.semesterTaken! == '2'
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
                  ratingBar(review.teachingRating!.toDouble())
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Personality'),
                  ratingBar(review.personalityRating!.toDouble())
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Grading'),
                  ratingBar(review.gradingRating!.toDouble())
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Workload'),
                  ratingBar(review.workloadRating!.toDouble())
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Leniency'),
                  ratingBar(review.leniencyRating!.toDouble())
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Attendance'),
                  ratingBar(review.attendanceRating!.toDouble())
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Feedback'),
                  ratingBar(review.feedbackRating!.toDouble())
                ],
              ),
              SizedBox(height: 15),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                SizedBox(
                  width: 286, //HARDCODED -- TO FIX
                  height: 25,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: revCourses.length,
                    itemBuilder: (BuildContext context, int position) {
                      return Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                          child: DecoratedBox(
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Text(
                                    revCourses[position],
                                    style: buttonText,
                                  ))));
                    },
                  ),
                ),
                if (revl.user!.uid == review.writeruid)
                  IconButton(
                    icon: Icon(Icons.edit),
                    disabledColor: Colors.white,
                    onPressed: () {
                      revl.user!.uid != review.writeruid
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

Widget downvotedReviewDetails(
        Review review, Professor prof, context, List<String> revCourses) =>
    Container(
        padding: const EdgeInsets.fromLTRB(25, 32, 25, 32),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          review.votes += 2;
                          // add to upvoters
                          if (review.upvoters == "") {
                            review.upvoters = review.upvoters! + revl.user!.uid;
                          } else {
                            review.upvoters =
                                review.upvoters! + ',' + revl.user!.uid;
                          }
                          // remove from downvoters
                          List<String> result = review.downvoters!.split(',');
                          result = result
                              .where((element) => (element != revl.user!.uid))
                              .toList();
                          final collection =
                              FirebaseFirestore.instance.collection('reviews');
                          collection
                              .doc(review.id)
                              .update({
                                'votes': review.votes,
                                'upvoters': review.upvoters,
                                'downvoters': result.join(','),
                              })
                              .then((_) => debugPrint('Updated'))
                              .catchError((error) =>
                                  debugPrint('Update Failed: $error'));
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
                          review.votes += 1;
                          // remove from downvoters
                          List<String> result = review.downvoters!.split(',');
                          result = result
                              .where((element) => (element != revl.user!.uid))
                              .toList();
                          final collection =
                              FirebaseFirestore.instance.collection('reviews');
                          collection
                              .doc(review.id)
                              .update({
                                'votes': review.votes,
                                'downvoters': result.join(','),
                              })
                              .then((_) => debugPrint('Updated'))
                              .catchError((error) =>
                                  debugPrint('Update Failed: $error'));
                        },
                        color: Colors.blue,
                        iconSize: 20,
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.arrow_downward)),
                  ],
                ),
                ratingBar(review.overallRating!.toDouble())
              ]),
              SizedBox(height: 24),
              Text('${review.title}', style: header2),
              SizedBox(height: 10),
              Wrap(
                alignment: WrapAlignment.start,
                spacing: 5,
                children: [
                  Text(
                      review.anonymous
                          ? 'Anonymous Reviewer'
                          : '${review.writer}',
                      style: smallText),
                  Text(
                      review.semesterTaken! == '1'
                          ? 'Intersession'
                          : review.semesterTaken! == '2'
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
                  ratingBar(review.teachingRating!.toDouble())
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Personality'),
                  ratingBar(review.personalityRating!.toDouble())
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Grading'),
                  ratingBar(review.gradingRating!.toDouble())
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Workload'),
                  ratingBar(review.workloadRating!.toDouble())
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Leniency'),
                  ratingBar(review.leniencyRating!.toDouble())
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Attendance'),
                  ratingBar(review.attendanceRating!.toDouble())
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Feedback'),
                  ratingBar(review.feedbackRating!.toDouble())
                ],
              ),
              SizedBox(height: 15),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                SizedBox(
                  width: 286, //HARDCODED -- TO FIX
                  height: 25,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: revCourses.length,
                    itemBuilder: (BuildContext context, int position) {
                      return Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                          child: DecoratedBox(
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Text(
                                    revCourses[position],
                                    style: buttonText,
                                  ))));
                    },
                  ),
                ),
                if (revl.user!.uid == review.writeruid)
                  IconButton(
                    icon: Icon(Icons.edit),
                    disabledColor: Colors.white,
                    onPressed: () {
                      revl.user!.uid != review.writeruid
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
      ignoreGestures: true,
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
