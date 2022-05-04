//current working file

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:profs_and_cons/pages/search.dart';
import 'package:profs_and_cons/objects/review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:profs_and_cons/pages/userRevs.dart';
import 'package:profs_and_cons/styles.dart';
import 'package:profs_and_cons/objects/professor.dart';
import 'package:profs_and_cons/objects/checkboxformfield.dart';
import 'package:profs_and_cons/objects/ratingformfield.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReviewForm extends StatefulWidget {
  Professor professor;

  ReviewForm({Key? key, required this.professor}) : super(key: key);

  @override
  State<ReviewForm> createState() => _ReviewFormState(professor: professor);
}

class _ReviewFormState extends State<ReviewForm> {
  Professor professor;
  _ReviewFormState({required this.professor});

  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  Review review = Review();

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    review.profId = professor.id;
    review.writer = user!.displayName!;
    review.writeruid = user!.uid;

    return Scaffold(
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
        backgroundColor: Colors.white,
      ),
      body: _form(),
    );
  }

  Widget _form() {
    List<String> courses = professor.courses.split(", ");
    List<FormBuilderFieldOption<dynamic>> courseList = [];
    for (String course in courses) {
      courseList
          .add(FormBuilderFieldOption(child: Text(course), value: course));
    }
    // final courses =
    //     coursesList.map((course) => CheckBoxState(title: course)).toList();
    List<dynamic> semesters = [];
    semesters.add({"id": 0, "name": "Intersession"});
    semesters.add({"id": 1, "name": "1st Sem"});
    semesters.add({"id": 2, "name": "2nd Sem"});
    //CheckBoxState anonymous = CheckBoxState(title: "Submit Anonymously");

    return Form(
      key: globalKey,
      child: ListView(children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
            Text(
              professor.name,
              style: header,
            ),
            Text(professor.department, style: smallText),
            Text(
              "Choose the course",
              style: header2,
            ),
            FormBuilderCheckboxGroup(
              name: 'Courses',
              options: courseList,
              validator: (onValidateVal) {
                if (onValidateVal == null) {
                  return "Please select at least one course";
                }
                return null;
              },
              onSaved: (onSavedVal) {
                review.courses = onSavedVal?.join(',');
              },
            ),
            SizedBox(height: 10),
            Text(
              "Rate your prof",
              style: header2,
            ),
            RatingFormField(
                title: Text(
                  "     • Teaching Skill",
                  style: formText,
                ),
                onSaved: (onSavedVal) {
                  review.teachingRating = onSavedVal;
                },
                validator: (onValidateVal) {
                  if (onValidateVal == 0.0) {
                    return "Please give a valid rating";
                  }
                  return null;
                }),
            RatingFormField(
                title: Text(
                  "     • Personality",
                  style: formText,
                ),
                onSaved: (onSavedVal) {
                  review.personalityRating = onSavedVal;
                },
                validator: (onValidateVal) {
                  if (onValidateVal == 0) {
                    return "Please give a valid rating";
                  }
                  return null;
                }),
            RatingFormField(
                title: Text(
                  "     • Grading",
                  style: formText,
                ),
                onSaved: (onSavedVal) {
                  review.gradingRating = onSavedVal;
                },
                validator: (onValidateVal) {
                  if (onValidateVal == 0) {
                    return "Please give a valid rating";
                  }
                  return null;
                }),
            RatingFormField(
                title: Text(
                  "     • Workload",
                  style: formText,
                ),
                onSaved: (onSavedVal) {
                  review.workloadRating = onSavedVal;
                },
                validator: (onValidateVal) {
                  if (onValidateVal == 0) {
                    return "Please give a valid rating";
                  }
                  return null;
                }),
            RatingFormField(
                title: Text(
                  "     • Leniency",
                  style: formText,
                ),
                onSaved: (onSavedVal) {
                  review.leniencyRating = onSavedVal;
                },
                validator: (onValidateVal) {
                  if (onValidateVal == 0) {
                    return "Please give a valid rating";
                  }
                  return null;
                }),
            RatingFormField(
                title: Text(
                  "     • Attendance",
                  style: formText,
                ),
                onSaved: (onSavedVal) {
                  review.attendanceRating = onSavedVal;
                },
                validator: (onValidateVal) {
                  if (onValidateVal == 0) {
                    return "Please give a valid rating";
                  }
                  return null;
                }),
            RatingFormField(
                title: Text(
                  "     • Feedback",
                  style: formText,
                ),
                onSaved: (onSavedVal) {
                  review.feedbackRating = onSavedVal;
                },
                validator: (onValidateVal) {
                  if (onValidateVal == 0) {
                    return "Please give a valid rating";
                  }
                  return null;
                }),
            RatingFormField(
                title: Text(
                  "     • Overall",
                  style: formText,
                ),
                onSaved: (onSavedVal) {
                  review.overallRating = onSavedVal;
                },
                validator: (onValidateVal) {
                  if (onValidateVal == 0) {
                    return "Please give a valid rating";
                  }
                  return null;
                }),
            FormHelper.inputFieldWidgetWithLabel(
                context, "title", "Add a title", "", (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return 'Please add a title';
              }
              return null;
            }, (onSavedVal) {
              review.title = onSavedVal;
            },
                initialValue: review.title ?? "",
                borderColor: Colors.black,
                borderRadius: 2,
                fontSize: 16,
                labelFontSize: 16,
                paddingLeft: 0,
                paddingRight: 0),
            FormHelper.inputFieldWidgetWithLabel(
                context,
                "description",
                "Add a description",
                "Talk about your experience!", (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return 'Please add a details to support your ratings';
              }
              return null;
            }, (onSavedVal) {
              debugPrint('$onSavedVal');
              review.description = onSavedVal;
            },
                initialValue: review.description ?? "",
                borderColor: Colors.black,
                borderRadius: 2,
                fontSize: 16,
                labelFontSize: 16,
                hintColor: Colors.grey,
                paddingLeft: 0,
                paddingRight: 0,
                isMultiline: true),
            Row(
              children: [
                Expanded(
                  child: FormHelper.dropDownWidgetWithLabel(
                    context,
                    "Semester Taken",
                    "Select Semester",
                    "",
                    semesters,
                    (onChangedVal) {
                      review.semesterTaken = onChangedVal! ?? "";
                    },
                    (onValidateVal) {
                      if (onValidateVal == null) {
                        return 'Please select a semester';
                      }
                      return null;
                    },
                    borderColor: Colors.black,
                    borderRadius: 2,
                    labelFontSize: 16,
                    paddingLeft: 0,
                    paddingRight: 0,
                  ),
                ),
                Expanded(
                  child: FormHelper.inputFieldWidgetWithLabel(
                    context,
                    "yearTaken",
                    "Latest A.Y. Taken",
                    "2019",
                    (onValidateVal) {
                      if (onValidateVal.isEmpty) {
                        return 'Please state the latest academic year you took the course';
                      }
                      else if(!RegExp(r"^(19|20)\d{2}$").hasMatch(onValidateVal)) {
                        return 'Options: 1900-2999';
                      }
                      return null;
                    },
                    (onSavedVal) {
                      review.yearTaken = onSavedVal;
                    },
                    initialValue: review.yearTaken ?? "",
                    borderColor: Colors.black,
                    borderRadius: 2,
                    fontSize: 16,
                    labelFontSize: 16,
                    hintColor: Colors.grey,
                    paddingLeft: 0,
                    paddingRight: 0,
                  ),
                ),
              ],
            ),
            FormBuilderCheckbox(
              name: 'anonymous',
              initialValue: false,
              title: Text('Submit anonymously'),
              onSaved: (onSavedVal) {
                review.anonymous = onSavedVal!;
              },
              validator: (onValidateVal) {},
            ),
            Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.all(5),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel"),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        foregroundColor: MaterialStateProperty.all(Colors.grey),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(2.0),
                                    side: BorderSide(color: Colors.grey)))),
                  ),
                )),
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (globalKey.currentState!.validate()) {
                              globalKey.currentState!.save();
                              String message;
                              try {
                                await createReview(review);
                                message = "Successfully submitted review!";
                              } catch (e) {
                                message =
                                    "An error occured while submitting review";
                              }
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //     SnackBar(content: Text(message)));
                              Navigator.pop(context);
                            }
                          },
                          child: Text("Submit"),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.blue),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2.0),
                                      side: BorderSide(color: Colors.blue)))),
                        ))),
              ],
            )
          ]),
        )
      ]),
    );
  }

  Future createReview(Review rev) async {
    final docReview = FirebaseFirestore.instance.collection('reviews').doc();
    rev.id = docReview.id;
    // update profname and dep
    final profTester = FirebaseFirestore.instance
        .collection('professors')
        .where('id', isEqualTo: rev.profId);
    String? department, name = '';
    await profTester.get().then((snapShot) {
      snapShot.docs.forEach((doc) {
        name = doc['name'];
        department = doc['department'];
      });
    });
    rev.profName = name;
    rev.department = department;
    // end of update profname and dep
    final json = rev.toJson();
    await docReview.set(json);
//
    // final profTester = FirebaseFirestore.instance
    //     .collection('professors')
    //     .where('id', isEqualTo: rev.profId);
    // String? department, name = '';
    // await profTester.get().then((snapShot) {
    //   snapShot.docs.forEach((doc) {
    //     name = doc['name'];
    //     department = doc['department'];
    //     print(name.toString() + "INSIDE SNAPSHOT");
    //   });
    // });

    // rev.profName = name;
    // rev.department = department;
//////////////////////////////////////
    // final json2 = rev.toJson();
    // await docReview.set(json2);
//
    // final revTester = FirebaseFirestore.instance
    //     .collection('users')
    //     .where('uid', isEqualTo: user!.uid);

    final tester = FirebaseFirestore.instance
        .collection('reviews')
        .where('profId', isEqualTo: rev.profId);

    double attend = 0,
        feedback = 0,
        grading = 0,
        leniency = 0,
        overall = 0,
        personality = 0,
        teaching = 0,
        workload = 0;
    int total = 0;

    // String? pastReviews = "";

    await tester.get().then((snapShot) {
      snapShot.docs.forEach((doc) {
        attend = attend + doc["attendanceRating"];
        feedback += doc["feedbackRating"];
        grading += doc["gradingRating"];
        leniency += doc["leniencyRating"];
        overall += doc["overallRating"];
        personality += doc["personalityRating"];
        teaching += doc["teachingRating"];
        workload += doc["workloadRating"];
        total += 1;
      });
    });
    // await revTester.get().then((snapShot) {
    //   snapShot.docs.forEach((doc) {
    //     pastReviews = doc["ownReviews"];
    //   });
    // });

    attend /= total;
    feedback /= total;
    grading /= total;
    leniency /= total;
    overall /= total;
    personality /= total;
    teaching /= total;
    workload /= total;

    // if (pastReviews == "") {
    //   pastReviews = rev.id.toString();
    // } else {
    //   pastReviews = pastReviews! + ',' + rev.id.toString();
    // }
    // rev.profName = name;
    // rev.department = department;
    // // final json2 = rev.toJson();
    // // await docReview.set(json2);
    // print(name.toString() + 'OUTSIDE');

    final updateProf = FirebaseFirestore.instance.collection('professors');
    updateProf
        .doc(rev.profId)
        .update({
          'attendanceRating': num.parse(attend.toStringAsFixed(2)),
          'feedbackRating': num.parse(feedback.toStringAsFixed(2)),
          'gradingRating': num.parse(grading.toStringAsFixed(2)),
          'leniencyRating': num.parse(leniency.toStringAsFixed(2)),
          'overallRating': num.parse(overall.toStringAsFixed(2)),
          'personalityRating': num.parse(personality.toStringAsFixed(2)),
          'teachingRating': num.parse(teaching.toStringAsFixed(2)),
          'workloadRating': num.parse(workload.toStringAsFixed(2)),
        })
        .then((_) => debugPrint('Updated'))
        .catchError((error) => debugPrint('Update Failed: $error'));

    // final addtouser = FirebaseFirestore.instance.collection('users');
    // addtouser
    //     .doc(user!.uid)
    //     .update({
    //       'ownReviews': pastReviews,
    //     })
    //     .then((_) => debugPrint('Updated own reviews'))
    //     .catchError((error) => debugPrint('Update Failed: $error'));

    // final updateRev = FirebaseFirestore.instance.collection('reviews');
    // updateRev
    //     .doc(rev.profId)
    //     .update({
    //       'profName': name,
    //       'department': department,
    //     })
    //     .then((_) => debugPrint('Updated revs'))
    //     .catchError((error) => debugPrint('Update Failed: $error'));
  }
}
