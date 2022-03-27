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
          Text(
            'Profs and Cons',
            textAlign: TextAlign.left,
          ),
          Spacer(),
          Text('Welcome,\nAtenean!',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 34,
                  color: Colors.white)),
          Text('Are you ready to start the sem?',
              style: TextStyle(fontSize: 16, color: Colors.white)),
          Spacer(),
          GoogleSigninButton(),
          Spacer(),
        ],
      );
}
