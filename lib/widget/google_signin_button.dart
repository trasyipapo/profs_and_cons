import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:profs_and_cons/provider/google_sign_in.dart';
import 'package:provider/provider.dart';

class GoogleSigninButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(4),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              primary: Color.fromARGB(255, 239, 108, 108), minimumSize: const Size.fromHeight(50)),
          label: Text(
            'Sign In With Google',
            style: TextStyle(
                fontFamily: 'GoogleSans',
                fontWeight: FontWeight.normal,
                fontSize: 20),
          ),
          icon: FaIcon(FontAwesomeIcons.google, color: Color.fromARGB(255, 248, 249, 255)),
          onPressed: () {
            final provider =
                Provider.of<GoogleSignInProvider>(context, listen: false);
            provider.login();
          },
        ),
      );
}
