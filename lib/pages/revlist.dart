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
import 'package:profs_and_cons/pages/edit_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Stream<List<Review>> readReviews() => FirebaseFirestore.instance
    .collection('reviews')
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => Review.fromJson(doc.data())).toList());
final user = FirebaseAuth.instance.currentUser;

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
    Review review;
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
              padding: const EdgeInsets.all(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(professor.name, style: header),
                    Text(professor.department, style: smallText),
                    Container(
                        padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
                        child: FutureBuilder<bool>(
                          future: exists(professor.id!),
                          builder: (contextF, snapshot) {
                            if (snapshot.data == true) {
                              return editRev(professor, context);
                            } else {
                              return addRev(professor, context);
                            }
                          },
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    StreamBuilder<List<Review>>(
                        stream: readReviews(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text(
                                'Something went wrong...${snapshot.error}');
                          } else if (snapshot.hasData) {
                            List<Review> reviews = snapshot.data!;
                            List<Review> filteredReviews = reviews
                                .where((rev) => (rev.profId == professor.id))
                                .toList();
                            filteredReviews = filteredReviews
                              ..sort((rev1, rev2) =>
                                  rev2.votes.compareTo(rev1.votes));
                            if (filteredReviews.length == 0) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        120, 56, 120, 24),
                                    child:
                                        Image.asset('assets/appbar-logo.png'),
                                  ),
                                  const Text(
                                      "There are no reviews for this prof yet.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 32,
                                          color: Colors.black)),
                                  const Text('\n',
                                      style: TextStyle(
                                          fontSize: 5, color: Colors.white)),
                                  const Text('Be the first to review?',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black)),
                                ],
                              );
                            } else {
                              return SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 500,
                                  child: ListView.builder(
                                      itemCount: filteredReviews.length,
                                      itemBuilder: (context, index) {
                                        final review = filteredReviews[index];
                                        if (review.isUp == null) {
                                          return Card(
                                              child: InkWell(
                                            child: reviewCard(
                                                review, professor, context),
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          FullReview(
                                                            review: review,
                                                            professor:
                                                                professor,
                                                          )));
                                            },
                                          ));
                                        } else if (!(review.isUp!)) {
                                          return Card(
                                              child: InkWell(
                                            child: down(
                                                review, professor, context),
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          FullReview(
                                                            review: review,
                                                            professor:
                                                                professor,
                                                          )));
                                            },
                                          ));
                                        } else {
                                          return Card(
                                              child: InkWell(
                                            child:
                                                up(review, professor, context),
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          FullReview(
                                                            review: review,
                                                            professor:
                                                                professor,
                                                          )));
                                            },
                                          ));
                                        }
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

Widget reviewCard(Review review, Professor prof, context) => Container(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                IconButton(
                    onPressed: () {
                      review.votes += 1;
                      review.isUp = true;
                      review.voter![user!.uid] = true;
                      final collection =
                          FirebaseFirestore.instance.collection('reviews');
                      collection
                          .doc(review.id)
                          .update({
                            'votes': review.votes,
                            'voter': review.voter,
                            'isUp': review.isUp
                          })
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
                      review.votes -= 1;
                      print(review.isUp);
                      review.voter![user!.uid] = false;
                      review.isUp = false;
                      final collection =
                          FirebaseFirestore.instance.collection('reviews');
                      collection
                          .doc(review.id)
                          .update({
                            'votes': review.votes,
                            'voter': review.voter,
                            'isUp': review.isUp
                          })
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
            if (user!.uid == review.writeruid)
              IconButton(
                icon: Icon(Icons.edit),
                disabledColor: Colors.white,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditForm(
                                professor: prof,
                                review: review,
                              )));
                },
              ),
          ])
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

Widget down(Review review, Professor prof, context) => Container(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                IconButton(
                    onPressed: () {
                      review.votes += 2;
                      review.isUp = true;
                      review.voter?[user!.uid] = true;
                      final collection =
                          FirebaseFirestore.instance.collection('reviews');
                      collection
                          .doc(review.id)
                          .update({
                            'votes': review.votes,
                            'voter': review.voter,
                            'isUp': review.isUp
                          })
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
                      print(review.isUp);
                      review.voter?.remove(user!.uid);
                      review.isUp = null;
                      review.votes += 1;
                      final collection =
                          FirebaseFirestore.instance.collection('reviews');
                      collection
                          .doc(review.id)
                          .update({
                            'votes': review.votes,
                            'voter': review.voter,
                            'isUp': review.isUp
                          })
                          .then((_) => debugPrint('Updated'))
                          .catchError(
                              (error) => debugPrint('Update Failed: $error'));
                    },
                    color: Colors.blue,
                    iconSize: 20,
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
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
            if (user!.uid == review.writeruid)
              IconButton(
                icon: Icon(Icons.edit),
                disabledColor: Colors.white,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditForm(
                                professor: prof,
                                review: review,
                              )));
                },
              ),
          ])
        ]),
      ),
    );

Widget up(Review review, Professor prof, context) => Container(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                IconButton(
                    onPressed: () {
                      review.votes -= 1;
                      review.isUp = null;
                      review.voter?.remove(user!.uid);
                      final collection =
                          FirebaseFirestore.instance.collection('reviews');
                      collection
                          .doc(review.id)
                          .update({
                            'votes': review.votes,
                            'voter': review.voter,
                            'isUp': review.isUp
                          })
                          .then((_) => debugPrint('Updated'))
                          .catchError(
                              (error) => debugPrint('Update Failed: $error'));
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
                      print(review.isUp);
                      review.voter?[user!.uid] = false;
                      review.votes -= 2;
                      review.isUp = false;
                      final collection =
                          FirebaseFirestore.instance.collection('reviews');
                      collection
                          .doc(review.id)
                          .update({
                            'votes': review.votes,
                            'voter': review.voter,
                            'isUp': review.isUp
                          })
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
            if (user!.uid == review.writeruid)
              IconButton(
                icon: Icon(Icons.edit),
                disabledColor: Colors.white,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditForm(
                                professor: prof,
                                review: review,
                              )));
                },
              ),
          ])
        ]),
      ),
    );

Review? userReview;

Future<bool> exists(String profId) async {
  bool edit = false;

  var btnChanger = FirebaseFirestore.instance
      .collection('reviews')
      .where('profId', isEqualTo: profId)
      .where('writeruid', isEqualTo: user!.uid);

  await btnChanger.get().then((snapShot) {
    snapShot.docs.forEach((doc) {
      edit = true;
      userReview = Review.fromJson(doc.data());
    });
  });
  return edit;
}

ElevatedButton addRev(Professor professor, BuildContext context) {
  return ElevatedButton(
      style: ButtonStyle(
          padding:
              MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(20)),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          'Add New Review',
          style: TextStyle(fontSize: 20.0),
        )
      ]),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ReviewForm(
                    professor: professor,
                  )),
        );
      });
}

ElevatedButton editRev(Professor professor, BuildContext context) {
  return ElevatedButton(
      style: ButtonStyle(
          padding:
              MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(20)),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.amber)),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          'Edit Review',
          style: TextStyle(fontSize: 20.0),
        )
      ]),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EditForm(
                    professor: professor,
                    review: userReview!,
                  )),
        );
      });
}
