import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:profs_and_cons/objects/user.dart';
import 'package:profs_and_cons/pages/bookmarks.dart';
import 'package:profs_and_cons/pages/userRevs.dart';
import 'package:profs_and_cons/pages/revlist.dart';
import 'package:profs_and_cons/styles.dart';
import 'package:profs_and_cons/objects/professor.dart';
import 'package:profs_and_cons/pages/search.dart';
import 'package:profs_and_cons/pages/search_results.dart';

Future<bool> saved(String uid, String profId) async {
  DocumentSnapshot docSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();

  // Get data from docs and convert map to List
  String user = docSnapshot.data().toString();
  return user.contains(profId);
}

Future<UserFire> getUser(String uid) async {
  DocumentSnapshot<Map<String, dynamic>> docSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();

  // Get data from docs and convert map to List
  UserFire user = UserFire.fromJson(docSnapshot.data());
  return user;
}

class Profile extends StatefulWidget {
  Professor professor;
  String? query;
  String currentUser = FirebaseAuth.instance.currentUser!.uid;
  int prevPage;

  Profile(
      {Key? key, required this.professor, this.query, required this.prevPage})
      : super(key: key);

  @override
  State<Profile> createState() => _ProfileState(
      professor: professor,
      currentUser: currentUser,
      query: query,
      prevPage: prevPage);
}

class _ProfileState extends State<Profile> {
  Professor professor;
  String currentUser;
  String? query;
  int prevPage;

  _ProfileState(
      {required this.professor,
      required this.currentUser,
      this.query,
      required this.prevPage});

  @override
  Widget build(BuildContext context) {
    List<String> courses = professor.courses.split(", ");
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.black87,
            onPressed: () {
              if (prevPage == 1) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SearchResults(query: query!)));
              } else if (prevPage == 2) {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Bookmarks()));
              }
            }),
        backgroundColor: Colors.white,
      ),
      body: Container(
          constraints: const BoxConstraints.expand(),
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('professors')
                  .doc(professor.id)
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong...${snapshot.error}');
                } else if (snapshot.hasData) {
                  print(professor.name);
                  print(snapshot.data);
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  Text(professor.department, style: smallText),
                                ],
                              ),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                        snapshot.data['overallRating']
                                            .toString(),
                                        style: overallRating),
                                    const Text('Overall Rating',
                                        style: bodyText)
                                  ])
                            ],
                          )),
                      Container(
                          padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
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
                                SizedBox(width: 10),
                                FutureBuilder<bool>(
                                  future: saved(currentUser, professor.id!),
                                  builder: (contextF, snapshot) {
                                    if (snapshot.data == true) {
                                      if (query != null)
                                        return marked(currentUser, professor,
                                            prevPage, query!, context);
                                      else
                                        return marked(currentUser, professor,
                                            prevPage, null, context);
                                    } else {
                                      if (query != null)
                                        return unmarked(currentUser, professor,
                                            prevPage, query!, context);
                                      else
                                        return unmarked(currentUser, professor,
                                            prevPage, null, context);
                                    }
                                  },
                                )
                              ])),
                      Container(
                          padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
                          child: Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Text(
                                  'Courses Taught:',
                                  style: header2,
                                )
                              ],
                            ),
                            const Padding(padding: EdgeInsets.all(5)),
                            SizedBox(
                              width: 333, //HARDCODED -- TO FIX
                              height: 25,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: courses.length,
                                itemBuilder:
                                    (BuildContext context, int position) {
                                  return Container(
                                      margin:
                                          const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                      child: DecoratedBox(
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 5, 10, 5),
                                              child: Text(
                                                courses[position],
                                                style: buttonText,
                                              ))));
                                },
                              ),
                            )
                          ])),
                      // averageRatings => replaced with this thing below
                      Container(
                          padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Average Ratings', style: header2),
                                Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        32, 10, 32, 0),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('Teaching Skill'),
                                              ratingBar(snapshot
                                                  .data['teachingRating']
                                                  .toDouble())
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('Personality'),
                                              ratingBar(snapshot
                                                  .data['personalityRating']
                                                  .toDouble())
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('Grading'),
                                              ratingBar(snapshot
                                                  .data['gradingRating']
                                                  .toDouble())
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('Workload'),
                                              ratingBar(snapshot
                                                  .data['workloadRating']
                                                  .toDouble())
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('Leniency'),
                                              ratingBar(snapshot
                                                  .data['leniencyRating']
                                                  .toDouble())
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('Attendance'),
                                              ratingBar(snapshot
                                                  .data['attendanceRating']
                                                  .toDouble())
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('Feedback'),
                                              ratingBar(snapshot
                                                  .data['feedbackRating']
                                                  .toDouble())
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
                                MaterialPageRoute(
                                    builder: (context) => RevList(
                                          professor: professor,
                                        )),
                              );
                            },
                          ))
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          if (value == 0) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Bookmarks()));
          } else if (value == 1) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => SearchPage()));
          } else if (value == 2) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => OwnReviews()));
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

ElevatedButton unmarked(String uid, Professor prof, int prevPage, String? query,
    BuildContext context) {
  return ElevatedButton(
      style: ButtonStyle(
          padding:
              MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(20)),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [Icon(Icons.bookmark)]),
      onPressed: () async {
        try {
          UserFire user = await getUser(uid);
          user.favorites = user.favorites! + prof.id! + ",";
          await updateUser(user);
          Navigator.of(context).push(CustomPageRoute(
              builder: (context) => Profile(
                    professor: prof,
                    prevPage: prevPage,
                    query: query!,
                  )));
        } catch (e) {}
      });
}

ElevatedButton marked(String uid, Professor prof, int prevPage, String? query,
    BuildContext context) {
  return ElevatedButton(
      style: ButtonStyle(
          padding:
              MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(20)),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.amber)),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [Icon(Icons.bookmark_added)]),
      onPressed: () async {
        try {
          UserFire user = await getUser(uid);
          List<String> faves = user.favorites!.split(",");
          faves.remove(prof.id!);
          user.favorites = faves.join(",");
          await updateUser(user);
          Navigator.of(context).push(CustomPageRoute(
              builder: (context) => Profile(
                    professor: prof,
                    prevPage: prevPage,
                    query: query!,
                  )));
        } catch (e) {}
      });
}

class CustomPageRoute extends MaterialPageRoute {
  CustomPageRoute({builder}) : super(builder: builder);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 0);
}

Future updateUser(UserFire user) async {
  final collection = FirebaseFirestore.instance.collection('users');
  await collection
      .doc(user.uid)
      .update({'favorites': user.favorites})
      .then((_) => debugPrint('Updated'))
      .catchError((error) => debugPrint('Update Failed: $error'));
}
