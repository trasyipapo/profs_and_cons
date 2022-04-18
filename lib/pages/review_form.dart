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
                        validator: (onValidateVal) {
                          if (onValidateVal == false) {
                            return "Please select a course";
                          }
                          return null;
                        });
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
                    "Year Taken",
                    "2019-2020",
                    (onValidateVal) {
                      if (onValidateVal.isEmpty) {
                        return 'Please state the school year you took the course';
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
                      globalKey.currentState!.reset();
                    },
                    child: Text("Clear"),
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

  Future createReview(Review rev) async {
    final docReview = FirebaseFirestore.instance.collection('reviews').doc();
    rev.id = docReview.id;
    final json = rev.toJson();
    await docReview.set(json);
  }
}
