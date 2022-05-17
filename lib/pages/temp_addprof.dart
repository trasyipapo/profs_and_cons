import 'dart:async';
import 'package:profs_and_cons/pages/search.dart';
import 'package:profs_and_cons/pages/bookmarks.dart';
import 'package:profs_and_cons/pages/userRevs.dart';
import 'package:flutter/material.dart';
import 'package:profs_and_cons/objects/professor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProf extends StatefulWidget {
  @override
  State<AddProf> createState() => _AddProfState();
}

class _AddProfState extends State<AddProf> {
  final controllerName = TextEditingController();
  final controllerDep = TextEditingController();
  final controllerCourses = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Color.fromARGB(255, 52, 55, 58),
              onPressed: () {
                Navigator.pop(context);
              }),
          backgroundColor: Color.fromARGB(255, 248, 249, 255),
        ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
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
            const SizedBox(
              height: 24,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 239, 108, 108),
                  minimumSize: const Size.fromHeight(50)),
              child: Text(
                'Add New Professor',
                style: TextStyle(
                    fontFamily: 'GoogleSans',
                    fontWeight: FontWeight.normal,
                    fontSize: 20),
              ),
              onPressed: () {
                final professor = Professor(
                  name: controllerName.text,
                  department: controllerDep.text,
                  courses: controllerCourses.text,
                );

                createProf(professor);

                Navigator.pop(context);
              },
            ),
          ],
        ),
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
