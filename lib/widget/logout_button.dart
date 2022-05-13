import 'package:flutter/material.dart';
import 'package:profs_and_cons/pages/login_page.dart';
import 'package:profs_and_cons/provider/google_sign_in.dart';
import 'package:provider/provider.dart';

class LogOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: Builder(
          builder: (BuildContext context) {
            return Container(
              padding: EdgeInsets.all(4),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 248, 249, 255)),
                    foregroundColor: MaterialStateProperty.all(Colors.grey),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: BorderSide(color: Colors.grey))),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.fromLTRB(120, 10, 120, 10))),
                onPressed: () {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.logout();
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(
                      fontFamily: 'GoogleSans',
                      fontWeight: FontWeight.normal,
                      fontSize: 20),
                ),
              ),
            );
          },
        ),
      );
}

// Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: ElevatedButton(
//                           style: ButtonStyle(
//                               backgroundColor:
//                                   MaterialStateProperty.all(Color.fromARGB(255, 248, 249, 255)),
//                               foregroundColor:
//                                   MaterialStateProperty.all(Colors.grey),
//                               shape: MaterialStateProperty.all<
//                                       RoundedRectangleBorder>(
//                                   RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(5.0),
//                                       side: BorderSide(color: Colors.grey))),
//                               padding: MaterialStateProperty.all(
//                                   EdgeInsets.fromLTRB(120, 10, 120, 10))),
//                           onPressed: () {
//                             final provider = Provider.of<GoogleSignInProvider>(
//                                 context,
//                                 listen: false);
//                             provider.logout();
//                           },
//                           child: const Text(
//                             'Logout',
//                             style: TextStyle(
//                                 fontFamily: 'GoogleSans',
//                                 fontWeight: FontWeight.normal,
//                                 fontSize: 20),
//                           ),
//                         )),