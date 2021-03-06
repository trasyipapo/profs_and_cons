import 'dart:async';
import 'package:flutter/material.dart';
import 'package:profs_and_cons/objects/review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:profs_and_cons/styles.dart';
import 'package:profs_and_cons/objects/professor.dart';
import 'package:profs_and_cons/objects/ratingformfield.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

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
            color: Color.fromARGB(255, 52, 55, 58),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: Color.fromARGB(255, 248, 249, 255),
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
    List<dynamic> semesters = [];
    semesters.add({"id": 1, "name": "Intersession"});
    semesters.add({"id": 2, "name": "1st Sem"});
    semesters.add({"id": 0, "name": "2nd Sem"});

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
            SizedBox(height: 10),
            Text(
              "Choose the course",
              style: header2,
            ),
            FormBuilderCheckboxGroup(
              name: 'Courses',
              options: courseList,
              initialValue: review.courses?.split(','),
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
            SizedBox(height: 15),
            Text(
              "Rate your prof",
              style: header2,
            ),
            SizedBox(height: 15),
            RatingFormField(
                title: Text(
                  "     ??? Teaching Skill",
                  style: formText,
                ),
                initialValue: review.teachingRating!.toDouble(),
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
                  "     ??? Personality",
                  style: formText,
                ),
                initialValue: review.personalityRating!.toDouble(),
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
                  "     ??? Grading",
                  style: formText,
                ),
                initialValue: review.gradingRating!.toDouble(),
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
                  "     ??? Workload",
                  style: formText,
                ),
                initialValue: review.workloadRating!.toDouble(),
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
                  "     ??? Leniency",
                  style: formText,
                ),
                initialValue: review.leniencyRating!.toDouble(),
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
                  "     ??? Attendance",
                  style: formText,
                ),
                initialValue: review.attendanceRating!.toDouble(),
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
                  "     ??? Feedback",
                  style: formText,
                ),
                initialValue: review.feedbackRating!.toDouble(),
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
                  "     ??? Overall",
                  style: formText,
                ),
                initialValue: review.overallRating!.toDouble(),
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
                borderColor: Color.fromARGB(255, 52, 55, 58),
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
                borderColor: Color.fromARGB(255, 52, 55, 58),
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
                    borderColor: Color.fromARGB(255, 52, 55, 58),
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
                    "Latest Year Taken",
                    "2019",
                    (onValidateVal) {
                      if (onValidateVal.isEmpty) {
                        return 'Please state the latest year you took the course';
                      } else if (!RegExp(r"^(19|20)\d{2}$")
                          .hasMatch(onValidateVal)) {
                        return 'Options: 1900-2999';
                      }
                      return null;
                    },
                    (onSavedVal) {
                      review.yearTaken = onSavedVal;
                    },
                    initialValue: review.yearTaken ?? "",
                    borderColor: Color.fromARGB(255, 52, 55, 58),
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
              initialValue: review.anonymous,
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
                            MaterialStateProperty.all(Color.fromARGB(255, 248, 249, 255)),
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
                              Navigator.pop(context);
                            }
                          },
                          child: Text("Update"),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Color.fromARGB(255, 74, 117, 182)),
                              foregroundColor:
                                  MaterialStateProperty.all(Color.fromARGB(255, 248, 249, 255)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2.0),
                                      side: BorderSide(color: Color.fromARGB(255, 74, 117, 182))))),
                        ))),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            globalKey.currentState!.save();
                            String message;
                            try {
                              await deleteReview(review);
                              message = "Successfully deleted review!";
                            } catch (e) {
                              message =
                                  "An error occured while deleting review";
                            }
                            Navigator.pop(context);
                          },
                          child: Text("Delete Review"),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Color.fromARGB(255, 239, 108, 108)),
                              foregroundColor:
                                  MaterialStateProperty.all(Color.fromARGB(255, 248, 249, 255)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2.0),
                                      side: BorderSide(color: Color.fromARGB(255, 239, 108, 108))))),
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
    await collection
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

    await updateRating(rev);
  }

  Future deleteReview(Review rev) async {
    final deleteRev = FirebaseFirestore.instance.collection('reviews');
    deleteRev
        .doc(rev.id)
        .delete()
        .then((_) => debugPrint('Deleted'))
        .catchError((error) => debugPrint('Delete Failed: $error'));

    await updateRating(rev);
  }

  Future updateRating(Review rev) async {
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

    attend /= total;
    feedback /= total;
    grading /= total;
    leniency /= total;
    overall /= total;
    personality /= total;
    teaching /= total;
    workload /= total;

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
  }
}
