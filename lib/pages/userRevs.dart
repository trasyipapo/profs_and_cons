import 'package:flutter/material.dart';
import 'package:profs_and_cons/pages/edit_form.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:profs_and_cons/objects/review.dart';
import 'package:profs_and_cons/pages/fullreview.dart';
import 'package:profs_and_cons/pages/search.dart';
import 'package:profs_and_cons/styles.dart';
import 'package:profs_and_cons/pages/bookmarks.dart';
import 'package:profs_and_cons/pages/profile.dart';
import 'package:profs_and_cons/objects/professor.dart';
import 'package:profs_and_cons/objects/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:profs_and_cons/widget/logout_button.dart';

final user = FirebaseAuth.instance.currentUser;

Stream<List<Review>> getRevs() => FirebaseFirestore.instance
    .collection('reviews')
    .where('writeruid', isEqualTo: user!.uid)
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => Review.fromJson(doc.data())).toList());

class OwnReviews extends StatefulWidget {
  OwnReviews({Key? key}) : super(key: key);

  @override
  State<OwnReviews> createState() => _OwnReviewsState();
}

class _OwnReviewsState extends State<OwnReviews> {
  _OwnReviewsState();

  int _currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Professor Profile Screen',
        home: Scaffold(
          body: Padding(
              padding: EdgeInsets.zero,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 62),
                    Container(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(color: Colors.grey[200]),
                        child: Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                maxRadius: 30,
                                backgroundImage: NetworkImage(user!.photoURL!),
                              ),
                              title: Text(
                                user!.displayName!,
                                style: userProfile,
                              ),
                              subtitle: Text(
                                user!.email!,
                                style: bodyText,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Center(
                              // padding: EdgeInsets.all(5),
                              child: LogOutButton(),
                            ),
                          ],
                        )),
                    Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 25),
                        child: const Text(
                          'My Reviews',
                          style: userProfileHeader,
                        )),
                    FutureBuilder<UserFire>(
                        future: getUser(user!.uid),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            UserFire? userObject = snapshot.data;
                            // List<String> ownReviewsList =
                            //     userObject!.ownReviews!.split(",");
                            // print(ownReviewsList);
                            return StreamBuilder<List<Review>>(
                              stream: getRevs(),
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
                                              'assets/empty.png'),
                                        ),
                                        const Text(
                                            "Sorry, you don't have any reviews yet",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 32,
                                                color: Color.fromARGB(255, 52, 55, 58))),
                                        const Text('\n',
                                            style: TextStyle(
                                                fontSize: 5,
                                                color: Color.fromARGB(255, 248, 249, 255))),
                                        const Text(
                                            'Search for professors then write reviews for them!',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Color.fromARGB(255, 52, 55, 58))),
                                      ],
                                    );
                                  } else {
                                    return Expanded(
                                        child: ListView.builder(
                                      padding: const EdgeInsets.fromLTRB(
                                          25, 0, 25, 25),
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: reviews.length,
                                      itemBuilder: (context, index) {
                                        final rev = reviews[index];

                                        Professor prof = Professor(
                                            name: rev.profName.toString(),
                                            department:
                                                rev.department.toString(),
                                            courses: rev.courses.toString());
                                        List<String> courseslist =
                                            rev.courses!.split(',');
                                        return Card(
                                            child: InkWell(
                                          child: tempcard(
                                              rev, prof, context, courseslist),
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        FullReview(
                                                          review: rev,
                                                          professor: prof,
                                                        )));
                                          },
                                        ));
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
                            return const Text("Error.");
                          }
                        })
                  ])),
          bottomNavigationBar: BottomNavigationBar(
            onTap: (value) {
              _currentIndex = value;
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
            currentIndex: _currentIndex,
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
            selectedItemColor: Color.fromARGB(255, 74, 117, 182),
          ),
        ));
  }
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
      //   setState(() {
      //     _ratingValue = value;
      // }
      );
}

Widget tempcard(
        Review review, Professor prof, context, List<String> revCourses) =>
    Container(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Text(
                  review.profName.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 15,
                      color: Colors.grey),
                ),
              ]),
              ratingBar(review.overallRating!.toDouble()),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            '${review.title}',
            style: header,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Text(
                review.anonymous ? 'Anonymous Reviewer' : '${review.writer}',
                style: smallText,
              ),
              const SizedBox(
                height: 24,
                width: 2,
              ),
              const Icon(
                Icons.brightness_1,
                size: 3,
                color: Colors.grey,
              ),
              Text(
                review.semesterTaken! == '0'
                    ? 'Intersession'
                    : review.semesterTaken! == '1'
                        ? '1st Sem'
                        : '2nd Sem',
                style: smallText,
              ),
              const SizedBox(width: 2),
              const Icon(
                Icons.brightness_1,
                size: 3,
                color: Colors.grey,
              ),
              Text('${review.yearTaken}', style: smallText),
            ],
          ),
          Row(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                SizedBox(
                  width: 265, //HARDCODED -- TO FIX 239
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
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Text(
                                    revCourses[position],
                                    style: buttonText,
                                  ))));
                    },
                  ),
                ),
              ]),
              // here
              IconButton(
                  icon: Icon(Icons.edit),
                  disabledColor: Color.fromARGB(255, 248, 249, 255),
                  onPressed: () {
                    user!.uid != review.writeruid
                        ? null
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditForm(
                                      professor: prof,
                                      review: review,
                                    )));
                  })

              //
            ],
          ),
        ]),
      ),
    );

// Future getProf(Review rev) async {
//   final docReview = FirebaseFirestore.instance.collection('reviews').doc();
//   rev.id = docReview.id;
//   final json = rev.toJson();
//   await docReview.set(json);

//   final tester = FirebaseFirestore.instance
//       .collection('professors')
//       .where('id', isEqualTo: rev.profId);

//   String? name, department;

//   await tester.get().then((snapShot) {
//     snapShot.docs.forEach((doc) {
//       name = doc['name'];
//       department = doc['department'];
//     });
//   });

//   department = department;
//   name = name;

//   print(department);
//   print(name);
// }
