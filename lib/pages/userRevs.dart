import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:profs_and_cons/objects/review.dart';
import 'package:profs_and_cons/pages/fullreview.dart';
import 'package:profs_and_cons/pages/search.dart';
import 'package:profs_and_cons/styles.dart';
import 'package:profs_and_cons/main.dart';
import 'package:profs_and_cons/pages/profile.dart';
import 'package:profs_and_cons/data/professor_api.dart';
import 'package:profs_and_cons/objects/professor.dart';
import 'package:profs_and_cons/objects/user.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final user = FirebaseAuth.instance.currentUser;

Stream<List<Review>> getRevs(List<String> ownReviewsList) =>
    FirebaseFirestore.instance
        .collection('reviews')
        .where('id', whereIn: ownReviewsList)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Review.fromJson(doc.data())).toList());

class OwnReviews extends StatefulWidget {
  OwnReviews({
    Key? key,
  }) : super(key: key);

  @override
  State<OwnReviews> createState() => _OwnReviewsState();
}

class _OwnReviewsState extends State<OwnReviews> {
  _OwnReviewsState();
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchPage()),
                    );
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
            body: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('OwnReviews of'),
                      Text(user!.displayName!, style: header),
                      const SizedBox(height: 10),
                      FutureBuilder<UserFire>(
                          future: getUser(user!.uid),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              UserFire? userObject = snapshot.data;
                              List<String> ownReviewsList =
                                  userObject!.ownReviews!.split(",");
                              print(ownReviewsList);
                              return StreamBuilder<List<Review>>(
                                stream: getRevs(ownReviewsList),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Text(
                                        'Something went wrong...${snapshot.error}');
                                  } else if (snapshot.hasData) {
                                    List<Review> reviews = snapshot.data!;
                                    if (reviews.isEmpty) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                120, 56, 120, 24),
                                            child: Image.asset(
                                                'assets/appbar-logo.png'),
                                          ),
                                          const Text(
                                              "Sorry, you don't have any reviews yet",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 32,
                                                  color: Colors.black)),
                                          const Text('\n',
                                              style: TextStyle(
                                                  fontSize: 5,
                                                  color: Colors.white)),
                                          const Text(
                                              'Search for professors then write reviews for them!',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black)),
                                        ],
                                      );
                                    } else {
                                      return Expanded(
                                          child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: reviews.length,
                                        itemBuilder: (context, index) {
                                          final rev = reviews[index];
                                          return reviewCard(rev, context);
                                        },
                                      ));
                                    }
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
                              );
                            } else {
                              return Text("Error.");
                            }
                          })
                    ]))));
  }
}

Widget reviewCard(Review review, context) => Container(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Text(
                  review.votes.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 15,
                      color: Colors.grey),
                ),
              ]),
              ratingBar(review.overallRating!.toDouble()),
            ],
          ),
          SizedBox(height: 24),
          Text(
            '${review.title}',
            style: header,
          ),
          SizedBox(height: 24),
          Row(children: [
            Text(
                review.semesterTaken! == '0'
                    ? 'Intersession'
                    : review.semesterTaken! == '1'
                        ? '1st Sem'
                        : '2nd Sem',
                style: header2),
            SizedBox(width: 2),
            Icon(
              Icons.brightness_1,
              size: 5,
            ),
            SizedBox(width: 2),
            Text('${review.yearTaken}', style: header2),
          ]),
          Text(
            review.anonymous ? 'Anonymous Reviewer' : '${review.writer}',
            style: smallText,
          ),
          SizedBox(height: 24),
        ]),
      ),
    );

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
