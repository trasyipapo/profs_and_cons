// import 'package:flutter/material.dart';
// import 'package:profs_and_cons/pages/login.dart';
// import 'package:profs_and_cons/pages/home.dart';
// import 'package:profs_and_cons/pages/profile.dart';
// import 'package:profs_and_cons/pages/fullreview.dart';
// import 'package:profs_and_cons/pages/revlist.dart';
// import 'package:profs_and_cons/pages/searchresults.dart';
// import 'package:profs_and_cons/pages/home_page.dart';

// void main() {
//   runApp(MaterialApp(
//       theme: ThemeData(fontFamily: 'GoogleSans'),
//       initialRoute: '/homepage',
//       routes: {
//         '/login': (context) => const Login(),
//         '/home': (context) => const Home(),
//         '/profile': (context) => const Profile(),
//         '/fullreview': (context) => const FullReview(),
//         '/revlist': (context) => const RevList(),
//         '/searchresults': (context) => const SearchResults(),
//         '/homepage': (context) => HomePage(),
//       }));
// }

import 'package:flutter/material.dart';
import 'package:profs_and_cons/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Google SignIn';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.deepOrange),
        home: HomePage(),
      );
}
