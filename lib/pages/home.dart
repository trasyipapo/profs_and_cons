import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            constraints: const BoxConstraints.expand(),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/bg-image.png"),
                    fit: BoxFit.cover)),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              helloUser,
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: TextField(
                  // onChanged: (value) {
                  //  filterSearchResults(value);
                  // },
                  // controller: editingController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(25.0)))),
                ),
              ),
            ])));
  }
}

Widget helloUser = Container(
    padding: const EdgeInsets.all(32),
    child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('''Hello, 
Name!''',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Colors.white)),
            Text("Let's search for your profs",
                style: TextStyle(fontSize: 16, color: Colors.white))
          ],
        )));
