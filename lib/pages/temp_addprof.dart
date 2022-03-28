import 'dart:async';
import 'package:profs_and_cons/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:profs_and_cons/widget/professor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProf extends StatefulWidget {
  final controllerId = TextEditingController();
  final controllerName = TextEditingController();

  @override
  State<AddProf> createState() => _AddProfState();
}

class _AddProfState extends State<AddProf> {
  get controllerName => null;

  get controllerId => null;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.search),
                color: Colors.black87,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Home()));
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
              keyboardType: TextInputType.number,
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
                final professor = Professor(
                    id: int.parse(controllerId.text),
                    name: controllerName.text);

                createProf(professor);

                Navigator.pop(context);
              },
            ),
          ],
        ),
      );

  // Stream<List<Professor>> readProfs() =>
  //     FirebaseFirestore.instance.collection('professors').doc();

  Future createProf(Professor prof) async {
    final docProf = FirebaseFirestore.instance.collection('professors').doc();
    final json = prof.toJson();
    await docProf.set(json);
  }
}
