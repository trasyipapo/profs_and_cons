//current working file

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:profs_and_cons/pages/search.dart';
import 'package:profs_and_cons/objects/review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:profs_and_cons/styles.dart';
import 'package:profs_and_cons/objects/professor.dart';
import 'package:profs_and_cons/objects/checkboxformfield.dart';
import 'package:profs_and_cons/objects/ratingformfield.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:profs_and_cons/pages/revlist.dart';

class EditForm extends StatefulWidget {
  Professor professor;
  Review review;

  EditForm({Key? key, required this.professor, required this.review})
      : super(key: key);

  @override
  State<EditForm> createState() =>
      _EditFormState(professor: professor, review: review);
}

class _EditFormState extends State<EditForm> {
  Professor professor;
  Review review;
  _EditFormState({required this.professor, required this.review});

  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
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
            Text(
              "Choose the course",
              style: header2,
            ),
            Container(
              //width: 333,
              height: 50, //need to fix layout to show all courses
              child: ListView.builder(
                  //scrollDirection: Axis.horizontal,
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    return CheckboxFormField(
                        title: Text(courses[index]),
                        onSaved: (onSavedVal) {
                          if (onSavedVal == true) {
                            review.courses = review.courses! +
                                " " +
                                courses[
                                    index]; //errors if review courses is a list for some reason
                          }
                        },
                        validator: (onValidateVal) {});
                  }),
            ),
            Text(
              "Rate your prof",
              style: header2,
            ),
            RatingFormField(
                title: Text(
                  "     • Teaching Skill",
                  style: formText,
                ),
                initialValue: review.teachingRating!,
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
                initialValue: review.personalityRating!,
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
                initialValue: review.gradingRating!,
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
                initialValue: review.workloadRating!,
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
                initialValue: review.leniencyRating!,
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
                initialValue: review.attendanceRating!,
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
                initialValue: review.feedbackRating!,
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
                initialValue: review.overallRating!,
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
                    "${semesters[int.parse(review.semesterTaken!)]['id']}",
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
                    "2019-2020",
                    (onValidateVal) {
                      if (onValidateVal.isEmpty) {
                        return 'Please state the latest academic year you took the course';
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
            CheckboxFormField(
                title: Text('Submit anonymously'),
                initialValue: review.anonymous,
                onSaved: (onSavedVal) {
                  review.anonymous = onSavedVal!;
                },
                validator: (onValidateVal) {}),
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
                                await updateReview(review);
                                message = "Successfully submitted review!";
                              } catch (e) {
                                message =
                                    "An error occured while submitting review";
                              }
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //     SnackBar(content: Text(message)));
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => RevList(
                              //             professor: professor,
                              //           )),
                              // );
                              Navigator.pop(context);
                            }
                          },
                          child: Text("Update"),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2.0),
                                      side: BorderSide(color: Colors.red)))),
                        ))),
              ],
            )
          ]),
        )
      ]),
    );
  }

  Future updateReview(Review rev) async {
    final collection = FirebaseFirestore.instance.collection('reviews');
    collection
        .doc(rev.id)
        .update({
          'courses': rev.courses,
          'teachingRating': rev.teachingRating,
          'personalityRating': rev.personalityRating,
          'gradingRating': rev.gradingRating,
          'workloadRating': rev.workloadRating,
          'leniencyRating': rev.leniencyRating,
          'attendanceRating': rev.attendanceRating,
          'feedbackRating': rev.feedbackRating,
          'overallRating': rev.overallRating,
          'title': rev.title,
          'description': rev.description,
          'semesterTaken': rev.semesterTaken,
          'yearTaken': rev.yearTaken,
          'anonymous': rev.anonymous,
        })
        .then((_) => debugPrint('Updated'))
        .catchError((error) => debugPrint('Update Failed: $error'));
  }
}
