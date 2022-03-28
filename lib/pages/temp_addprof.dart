import 'dart:async';
import 'package:profs_and_cons/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:profs_and_cons/widget/professor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProf extends StatefulWidget {
  @override
  State<AddProf> createState() => _AddProfState();
}

class _AddProfState extends State<AddProf> {
  final controllerId = TextEditingController();
  final controllerName = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.search),
                color: Colors.black87,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SearchPage()));
                })),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            TextField(
              controller: controllerId,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Professor ID',
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            TextField(
              controller: controllerName,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Name',
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            ElevatedButton(
              child: Text('Add New Professor'),
              onPressed: () {
                final professor =
                    Professor(id: controllerId.text, name: controllerName.text);

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
    final docProf =
        FirebaseFirestore.instance.collection('professors').doc(prof.id);
    final json = prof.toJson();
    await docProf.set(json);
  }
}
