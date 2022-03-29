import 'package:flutter/material.dart';
import 'package:profs_and_cons/widget/google_signin_button.dart';

class LoginWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/bg-image.png"), fit: BoxFit.cover)),
        child: buildLogin(),
      );

  Widget buildLogin() => Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 80, horizontal: 20),
              width: 175,
              child: Text(
                'Profs and Cons',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'GoogleSans',
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          Spacer(),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: 175,
              child: Text(
                'Welcome,\nAtenean!',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'GoogleSans',
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: 500,
              child: Text(
                'Are you ready to start the sem?',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'GoogleSans',
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.all(20),
            child: GoogleSigninButton(),
          ),
          Spacer(
            flex: 3,
          ),
        ],
      );
}
