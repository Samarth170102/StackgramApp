import 'package:flutter/material.dart';
import 'package:flutter_application_8/AuthScreens/sign_in.dart';
import 'package:flutter_application_8/AuthScreens/sign_up.dart';
import 'package:flutter_application_8/main.dart';
import 'package:velocity_x/velocity_x.dart';

class ChangeAuthScreen extends StatelessWidget {
  const ChangeAuthScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    VxState.watch(context, on: [AuthMutation]);
    return store.authStateChange ? SignUp() : SignIn();
  }
}
