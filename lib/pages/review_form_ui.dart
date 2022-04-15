import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:profs_and_cons/pages/revlist.dart';
import 'package:profs_and_cons/pages/search.dart';
import 'package:profs_and_cons/objects/review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:profs_and_cons/styles.dart';

class ReviewForm extends StatefulWidget {
  @override
  State<ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  bool checked = false;
  String dropdownval = 'Intersession';

  @override
  Widget build(BuildContext context) => Scaffold(
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
      body: Container(
          child: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Juan Dela Cruz", style: header),
                        Text(
                          "Choose the course",
                          style: header2,
                        ),
                        CheckboxListTile(
                            title: Text("CSCI 151"),
                            value: checked,
                            onChanged: (val) {
                              setState(() {
                                checked = true;
                              });
                            }),
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
                        Text(
                          "Add a title",
                          style: header2,
                        ),
                        TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        Text(
                          "Add a description",
                          style: header2,
                        ),
                        TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: <Widget>[
                        // Column(
                        //   children: [
                        Text(
                          "Semester Taken",
                          style: header2,
                        ),
                        DropdownButton(
                            value: dropdownval,
                            items: <String>[
                              'Intersession',
                              '1st Sem',
                              '2nd Sem'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                  value: value, child: Text(value));
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownval = newValue!;
                              });
                            }),
                        //   ],
                        // ),
                        // Column(
                        //   children: [
                        Text(
                          "Year Taken",
                          style: header2,
                        ),
                        TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        //   ],
                        // ),
                        //   ],
                        // ),
                        CheckboxListTile(
                            title: Text("Submit anonymously"),
                            value: checked,
                            onChanged: (val) {
                              setState(() {
                                checked = true;
                              });
                            }),
                        Row(
                          children: [
                            ElevatedButton(
                                onPressed: () {}, child: Text("Delete")),
                            ElevatedButton(
                                onPressed: () {}, child: Text("Submit"))
                          ],
                        )
                      ])))));
}
