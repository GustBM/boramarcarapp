import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:boramarcarapp/controllers/auth_controller.dart';

class GoogleIconLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GoogleAuthButton(
      onPressed: () async {
        try {
          await Provider.of<AuthController>(context, listen: false)
              .signInWithGoogle();
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.toString()),
          ));
        }
      },
      darkMode: false,
      style: AuthButtonStyle(
        buttonType: AuthButtonType.icon,
        borderRadius: 40.0,
      ),
    );
  }
}

class FacebookIconLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FacebookAuthButton(
      onPressed: () async {
        try {
          await Provider.of<AuthController>(context, listen: false)
              .signInWithFacebook();
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.toString()),
          ));
        }
      },
      darkMode: false,
      style: AuthButtonStyle(
        buttonType: AuthButtonType.icon,
        borderRadius: 40.0,
      ),
    );
  }
}
