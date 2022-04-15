import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart';
import 'package:profs_and_cons/pages/revlist.dart';
import 'package:profs_and_cons/pages/search.dart';
import 'package:profs_and_cons/objects/review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:profs_and_cons/styles.dart';
import 'package:profs_and_cons/objects/professor.dart';
import 'package:profs_and_cons/objects/checkboxstate.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

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
  Review review = Review(anonymous: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.black87,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const RevList()));
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
    List<String> coursesList = professor.courses.split(", ");
    final courses =
        coursesList.map((course) => CheckBoxState(title: course)).toList();
    List<dynamic> semesters = [];
    semesters.add({"id": 0, "name": "Intersession"});
    semesters.add({"id": 1, "name": "1st Sem"});
    semesters.add({"id": 2, "name": "2nd Sem"});
    CheckBoxState anonymous = CheckBoxState(title: "Submit Anonymously");

    return Form(
      key: globalKey,
      child: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
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
            height:
                50, //hardcoded for now, might have to change if there's a lot of courses
            child: ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  return buildCheckbox(courses[index]);
                  // CheckboxListTile(
                  //     controlAffinity: ListTileControlAffinity.leading,
                  //     title: Text(courses[index]),
                  //     value: checked,
                  //     onChanged: (val) {
                  //       setState(() {
                  //         checked = val!;
                  //       });
                  //     });
                }),
          ),
          Text(
            "Rate your prof",
            style: header2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "     • Teaching Skill",
                style: formText,
              ),
              RatingBar.builder(
                minRating: 1,
                itemSize: 30,
                itemBuilder: (context, _) =>
                    Icon(Icons.star, color: Colors.blue),
                onRatingUpdate: (rating) {},
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "     • Personality",
                style: formText,
              ),
              RatingBar.builder(
                minRating: 1,
                itemSize: 30,
                itemBuilder: (context, _) =>
                    Icon(Icons.star, color: Colors.blue),
                onRatingUpdate: (rating) {},
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "     • Grading",
                style: formText,
              ),
              RatingBar.builder(
                minRating: 1,
                itemSize: 30,
                itemBuilder: (context, _) =>
                    Icon(Icons.star, color: Colors.blue),
                onRatingUpdate: (rating) {},
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "     • Workload",
                style: formText,
              ),
              RatingBar.builder(
                minRating: 1,
                itemSize: 30,
                itemBuilder: (context, _) =>
                    Icon(Icons.star, color: Colors.blue),
                onRatingUpdate: (rating) {},
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "     • Leniency",
                style: formText,
              ),
              RatingBar.builder(
                minRating: 1,
                itemSize: 30,
                itemBuilder: (context, _) =>
                    Icon(Icons.star, color: Colors.blue),
                onRatingUpdate: (rating) {},
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "     • Attendance",
                style: formText,
              ),
              RatingBar.builder(
                minRating: 1,
                itemSize: 30,
                itemBuilder: (context, _) =>
                    Icon(Icons.star, color: Colors.blue),
                onRatingUpdate: (rating) {},
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "     • Feedback",
                style: formText,
              ),
              RatingBar.builder(
                minRating: 1,
                itemSize: 30,
                itemBuilder: (context, _) =>
                    Icon(Icons.star, color: Colors.blue),
                onRatingUpdate: (rating) {},
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "     • Overall",
                style: formText,
              ),
              RatingBar.builder(
                minRating: 1,
                itemSize: 30,
                itemBuilder: (context, _) =>
                    Icon(Icons.star, color: Colors.blue),
                onRatingUpdate: (rating) {},
              )
            ],
          ),
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
                    this.review.semesterTaken = onChangedVal! ?? "";
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
          buildCheckbox(anonymous),
          // CheckboxListTile(
          //     controlAffinity: ListTileControlAffinity.leading,
          //     title: Text("Submit anonymously"),
          //     value: checked,
          //     onChanged: (val) {
          //       setState(() {
          //         checked = val!;
          //       });
          //     }),
          Row(
            children: [
              Expanded(
                  child: Padding(
                padding: EdgeInsets.all(5),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text("Clear"),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      foregroundColor: MaterialStateProperty.all(Colors.grey),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2.0),
                              side: BorderSide(color: Colors.grey)))),
                ),
              )),
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: ElevatedButton(
                        onPressed: () {},
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
      )),
    );
  }

  Widget buildCheckbox(CheckBoxState checkbox) => CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      title: Text(checkbox.title),
      value: checkbox.value,
      onChanged: (bool? value) {
        setState(() => checkbox.value = value!);
        debugPrint('${checkbox.value}');
      });
}
