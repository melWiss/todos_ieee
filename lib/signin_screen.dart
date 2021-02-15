import 'package:flutter/material.dart';
import 'fire.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: OutlinedButton(
          child: Text("Sign In with Google"),
          onPressed: () {
            todoFirebase.signInWithGoogle();
          },
        ),
      ),
    );
  }
}
