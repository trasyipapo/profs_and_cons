import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:profs_and_cons/pages/profile.dart';
import 'package:profs_and_cons/pages/fullreview.dart';
import 'package:profs_and_cons/pages/search.dart';
import 'package:profs_and_cons/styles.dart';
import 'package:profs_and_cons/objects/reviewcard.dart';
import 'package:profs_and_cons/objects/professor.dart';
import 'package:profs_and_cons/objects/review.dart';
import 'package:profs_and_cons/pages/review_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Stream<List<Review>> readReviews() => FirebaseFirestore.instance
    .collection('reviews')
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => Review.fromJson(doc.data())).toList());

class RevList extends StatefulWidget {
  Professor professor;

  RevList({Key? key, required this.professor}) : super(key: key);

  @override
  State<RevList> createState() => _RevListState(professor: professor);
}

class _RevListState extends State<RevList> {
  Professor professor;
  _RevListState({required this.professor});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Professor Reviews Screen',
        home: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.black87,
                  onPressed: () {
                    Navigator.pop(context);
                    // Navigator.of(context).push(
                    // MaterialPageRoute(builder: (context) => Profile(professor: prof)));
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
              padding: EdgeInsets.all(16),
              child: Column(children: [
                StreamBuilder<List<Review>>(
                    stream: readReviews(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong...${snapshot.error}');
                      } else if (snapshot.hasData) {
                        List<Review> reviews = snapshot.data!;
                        List<Review> filteredReviews = reviews
                            .where((rev) => (rev.profId == professor.id))
                            .toList();
                        if (filteredReviews.length == 0) {
                          return Text('No Reviews Found');
                        } else {
                          return Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              child: ListView.builder(
                                  itemCount: filteredReviews.length,
                                  itemBuilder: (context, index) {
                                    final review = filteredReviews[index];
                                    return Card(
                                        child: InkWell(
                                      child: reviewCard(review),
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    FullReview(
                                                      review: review,
                                                      professor: professor,
                                                    )));
                                      },
                                    ));
                                  }));
                        }
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ]),
            )));
  }
}

Widget reviewCard(Review review) => Container(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  '0',
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
              ratingBar(review.overallRating!),
            ],
          ),
          SizedBox(height: 24),
          Text(
            '${review.title}',
            style: header,
          ),
          SizedBox(height: 24),
          Text(
            review.anonymous ? 'Anonymous Reviewer' : '${review.writer}',
            style: header2,
          ),
          SizedBox(height: 24),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Wrap(spacing: 10, children: [
              DecoratedBox(
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Text('${review.courses}', style: buttonText))),
            ])
          ])
        ]),
      ),
    );

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
