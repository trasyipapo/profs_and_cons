import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:profs_and_cons/pages/fullreview.dart';
import 'package:profs_and_cons/pages/search.dart';
import 'package:profs_and_cons/styles.dart';
import 'package:profs_and_cons/objects/professor.dart';
import 'package:profs_and_cons/objects/review.dart';
import 'package:profs_and_cons/pages/bookmarks.dart';
import 'package:profs_and_cons/pages/userRevs.dart';
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
  String sortBy = 'Most Voted';

  @override
  Widget build(BuildContext context) {
    Review review;
    return MaterialApp(
        title: 'Professor Reviews Screen',
        home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Color.fromARGB(255, 52, 55, 58),
                onPressed: () {
                  Navigator.pop(context);
                }),
            backgroundColor: Color.fromARGB(255, 248, 249, 255),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(professor.name, style: header),
                    Text(professor.department, style: medText),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    DropdownButton(
                        value: sortBy,
                        icon: Icon(Icons.sort_outlined),
                        items: <String>[
                          'Most Voted',
                          'Least Voted',
                          'Newest',
                          'Oldest',
                          'Highest Rating',
                          'Lowest Rating'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            sortBy = newValue!;
                          });
                        })
                  ],
                )
              ]),
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
              Expanded(
                  child: StreamBuilder<List<Review>>(
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

                          if (sortBy == 'Most Voted') {
                            filteredReviews = filteredReviews
                              ..sort((rev1, rev2) =>
                                  rev2.votes.compareTo(rev1.votes));
                          } else if (sortBy == 'Least Voted') {
                            filteredReviews = filteredReviews
                              ..sort((rev1, rev2) =>
                                  rev1.votes.compareTo(rev2.votes));
                          } else if (sortBy == 'Newest') {
                            filteredReviews = filteredReviews
                              ..sort((rev1, rev2) =>
                                  ("${rev2.yearTaken}${rev2.semesterTaken}")
                                      .toString()
                                      .compareTo(
                                          ("${rev1.yearTaken}${rev1.semesterTaken}")
                                              .toString()));
                          } else if (sortBy == 'Oldest') {
                            filteredReviews = filteredReviews
                              ..sort((rev1, rev2) =>
                                  ("${rev1.yearTaken}${rev1.semesterTaken}")
                                      .toString()
                                      .compareTo(
                                          ("${rev2.yearTaken}${rev2.semesterTaken}")
                                              .toString()));
                          } else if (sortBy == 'Highest Rating') {
                            filteredReviews = filteredReviews
                              ..sort((rev1, rev2) => rev2.overallRating!
                                  .compareTo(rev1.overallRating!));
                          } else if (sortBy == 'Lowest Rating') {
                            filteredReviews = filteredReviews
                              ..sort((rev1, rev2) => rev1.overallRating!
                                  .compareTo(rev2.overallRating!));
                          }

                          if (filteredReviews.length == 0) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      120, 56, 120, 24),
                                  child: Image.asset('assets/empty.png'),
                                ),
                                const Text(
                                    "There are no reviews for this prof yet.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 32,
                                        color: Color.fromARGB(255, 52, 55, 58))),
                                const Text('\n',
                                    style: TextStyle(
                                        fontSize: 5, color: Color.fromARGB(255, 248, 249, 255))),
                                const Text('Be the first to review?',
                                    style: TextStyle(
                                        fontSize: 16, color: Color.fromARGB(255, 52, 55, 58))),
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
                                      List<String> upvoters =
                                          review.upvoters!.split(',');
                                      List<String> downvoters =
                                          review.downvoters!.split(',');

                                      bool isUp = upvoters.any(
                                          (element) => (element == user!.uid));
                                      bool isDown = downvoters.any(
                                          (element) => (element == user!.uid));

                                      if (isDown) {
                                        return Card(
                                            child: InkWell(
                                          child: down(
                                              review,
                                              professor,
                                              context,
                                              review.courses!.split(',')),
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
                                      } else if (isUp) {
                                        return Card(
                                            child: InkWell(
                                          child: up(review, professor, context,
                                              review.courses!.split(',')),
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
                                      } else {
                                        return Card(
                                            child: InkWell(
                                          child: reviewCard(
                                              review,
                                              professor,
                                              context,
                                              review.courses!.split(',')),
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
                                      }
                                    }));
                          }
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      })),
            ]),
          ),
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

Widget reviewCard(
        Review review, Professor prof, context, List<String> revCourses) =>
    Container(
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

                      if (review.upvoters == "") {
                        review.upvoters = review.upvoters! + user!.uid;
                      } else {
                        review.upvoters = review.upvoters! + ',' + user!.uid;
                      }
                      //
                      final collection =
                          FirebaseFirestore.instance.collection('reviews');
                      collection
                          .doc(review.id)
                          .update({
                            'votes': review.votes,
                            'upvoters': review.upvoters,
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

                      if (review.downvoters == "") {
                        review.downvoters = review.downvoters! + user!.uid;
                      } else {
                        review.downvoters =
                            review.downvoters! + ',' + user!.uid;
                      }
                      final collection =
                          FirebaseFirestore.instance.collection('reviews');
                      collection
                          .doc(review.id)
                          .update({
                            'votes': review.votes,
                            'downvoters': review.downvoters,
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
                review.semesterTaken! == '1'
                    ? 'Intersession'
                    : review.semesterTaken! == '2'
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
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            SizedBox(
              width: 239, //HARDCODED -- TO FIX
              height: 25,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: revCourses.length,
                itemBuilder: (BuildContext context, int position) {
                  return Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 239, 108, 108),
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: Text(
                                revCourses[position],
                                style: buttonText,
                              ))));
                },
              ),
            ),
          ])
        ]),
      ),
    );

Widget down(Review review, Professor prof, context, List<String> revCourses) =>
    Container(
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

                      // add to upvoters
                      if (review.upvoters == "") {
                        review.upvoters = review.upvoters! + user!.uid;
                      } else {
                        review.upvoters = review.upvoters! + ',' + user!.uid;
                      }
                      // remove from downvoters
                      List<String> result = review.downvoters!.split(',');
                      print(result);

                      result = result
                          .where((element) => (element != user!.uid))
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
                      review.votes += 1;
                      // remove from downvoters
                      List<String> result = review.downvoters!.split(',');
                      print(result);

                      result = result
                          .where((element) => (element != user!.uid))
                          .toList();
                      print(result);
                      final collection =
                          FirebaseFirestore.instance.collection('reviews');
                      collection
                          .doc(review.id)
                          .update({
                            'votes': review.votes,
                            'downvoters': result.join(','),
                          })
                          .then((_) => debugPrint('Updated'))
                          .catchError(
                              (error) => debugPrint('Update Failed: $error'));
                    },
                    color: Color.fromARGB(255, 74, 117, 182),
                    iconSize: 20,
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.arrow_downward)),
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
                review.semesterTaken! == '1'
                    ? 'Intersession'
                    : review.semesterTaken! == '2'
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
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            SizedBox(
              width: 239, //HARDCODED -- TO FIX
              height: 25,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: revCourses.length,
                itemBuilder: (BuildContext context, int position) {
                  return Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 239, 108, 108),
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: Text(
                                revCourses[position],
                                style: buttonText,
                              ))));
                },
              ),
            ),
          ])
        ]),
      ),
    );

Widget up(Review review, Professor prof, context, List<String> revCourses) =>
    Container(
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

                      // remove from upvoters
                      List<String> result = review.upvoters!.split(',');
                      result = result
                          .where((element) => (element != user!.uid))
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
                          .catchError(
                              (error) => debugPrint('Update Failed: $error'));
                    },
                    color: Color.fromARGB(255, 74, 117, 182),
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

                      // add to downvoters
                      if (review.downvoters == "") {
                        review.downvoters = review.downvoters! + user!.uid;
                      } else {
                        review.downvoters =
                            review.downvoters! + ',' + user!.uid;
                      }
                      // remove from upvoters
                      List<String> result = review.upvoters!.split(',');
                      print(result);

                      result = result
                          .where((element) => (element != user!.uid))
                          .toList();
                      final collection =
                          FirebaseFirestore.instance.collection('reviews');
                      collection
                          .doc(review.id)
                          .update({
                            'votes': review.votes,
                            'upvoters': result.join(','),
                            'downvoters': review.downvoters,
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
                review.semesterTaken! == '1'
                    ? 'Intersession'
                    : review.semesterTaken! == '2'
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
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            SizedBox(
              width: 239, //HARDCODED -- TO FIX
              height: 25,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: revCourses.length,
                itemBuilder: (BuildContext context, int position) {
                  return Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 239, 108, 108),
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: Text(
                                revCourses[position],
                                style: buttonText,
                              ))));
                },
              ),
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
          backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 74, 117, 182))),
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

RatingBar ratingBar(double rating) {
  return RatingBar(
      initialRating: rating,
      itemSize: 20,
      ignoreGestures: true,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      ratingWidget: RatingWidget(
          full: const Icon(Icons.star, color: Color.fromARGB(255, 74, 117, 182)),
          half: const Icon(
            Icons.star_half,
            color: Color.fromARGB(255, 74, 117, 182),
          ),
          empty: const Icon(
            Icons.star,
            color: Color.fromARGB(255, 52, 55, 58),
          )),
      onRatingUpdate: (value) {}
      );
}
