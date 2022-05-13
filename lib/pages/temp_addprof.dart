import 'dart:async';
import 'package:profs_and_cons/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:profs_and_cons/objects/professor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProf extends StatefulWidget {
  @override
  State<AddProf> createState() => _AddProfState();
}

class _AddProfState extends State<AddProf> {
  // final controllerId = TextEditingController();
  final controllerName = TextEditingController();
  final controllerDep = TextEditingController();
  final controllerCourses = TextEditingController();
  // final controlleroverallRating = TextEditingController();
  // final controllerteachingRating = TextEditingController();
  // final controllerpersonalityRating = TextEditingController();
  // final controllergradingRating = TextEditingController();
  // final controllerworkloadRating = TextEditingController();
  // final controllerleniencyRating = TextEditingController();
  // final controllerattendanceRating = TextEditingController();
  // final controllerfeedbackRating = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.search),
                color: Color.fromARGB(255, 52, 55, 58),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SearchPage()));
                })),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            // TextField(
            //   controller: controllerId,
            //   decoration: const InputDecoration(
            //     border: OutlineInputBorder(),
            //     hintText: 'Professor ID',
            //   ),
            // ),
            // const SizedBox(
            //   height: 24,
            // ),
            TextField(
              controller: controllerName,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Name',
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            TextField(
              controller: controllerDep,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Department',
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            TextField(
              controller: controllerCourses,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Courses',
              ),
            ),
            // TextField(
            //   controller: controlleroverallRating,
            //   decoration: const InputDecoration(
            //     border: OutlineInputBorder(),
            //     hintText: 'Overall',
            //   ),
            // ),
            // TextField(
            //   controller: controllerteachingRating,
            //   decoration: const InputDecoration(
            //     border: OutlineInputBorder(),
            //     hintText: 'Teaching',
            //   ),
            // ),
            // TextField(
            //   controller: controllerpersonalityRating,
            //   decoration: const InputDecoration(
            //     border: OutlineInputBorder(),
            //     hintText: 'Personality',
            //   ),
            // ),
            // TextField(
            //   controller: controllergradingRating,
            //   decoration: const InputDecoration(
            //     border: OutlineInputBorder(),
            //     hintText: 'Grading',
            //   ),
            // ),
            // TextField(
            //   controller: controllerworkloadRating,
            //   decoration: const InputDecoration(
            //     border: OutlineInputBorder(),
            //     hintText: 'Workload',
            //   ),
            // ),
            // TextField(
            //   controller: controllerleniencyRating,
            //   decoration: const InputDecoration(
            //     border: OutlineInputBorder(),
            //     hintText: 'Leniency',
            //   ),
            // ),
            // TextField(
            //   controller: controllerattendanceRating,
            //   decoration: const InputDecoration(
            //     border: OutlineInputBorder(),
            //     hintText: 'Attendance',
            //   ),
            // ),
            // TextField(
            //   controller: controllerfeedbackRating,
            //   decoration: const InputDecoration(
            //     border: OutlineInputBorder(),
            //     hintText: 'Feedback',
            //   ),
            // ),
            const SizedBox(
              height: 24,
            ),
            ElevatedButton(
              child: Text('Add New Professor'),
              onPressed: () {
                final professor = Professor(
                  // id: controllerId.text,
                  name: controllerName.text,
                  department: controllerDep.text,
                  courses: controllerCourses.text,
                  // overallRating: double.parse(controlleroverallRating.text),
                  // teachingRating: double.parse(controllerteachingRating.text),
                  // personalityRating:
                  //     double.parse(controllerpersonalityRating.text),
                  // gradingRating: double.parse(controllergradingRating.text),
                  // workloadRating: double.parse(controllerworkloadRating.text),
                  // leniencyRating: double.parse(controllerleniencyRating.text),
                  // attendanceRating:
                  //     double.parse(controllerattendanceRating.text),
                  // feedbackRating: double.parse(controllerfeedbackRating.text),
                );

                createProf(professor);

                Navigator.pop(context);
              },
            ),
          ],
        ),
      );

  Stream<List<Professor>> readProfs() => FirebaseFirestore.instance
      .collection('professors')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Professor.fromJson(doc.data())).toList());

  Future createProf(Professor prof) async {
    final docProf = FirebaseFirestore.instance.collection('professors').doc();
    prof.id = docProf.id;
    final json = prof.toJson();
    await docProf.set(json);
  }
}
