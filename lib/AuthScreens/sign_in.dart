import 'package:flutter/material.dart';
import 'package:flutter_application_8/Services/auth_services.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets1.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets3.dart';
import 'package:flutter_application_8/main.dart';
import 'package:velocity_x/velocity_x.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String email = "";
  String password = "";
  final _formkey = GlobalKey<FormState>();
  bool loading = false;
  dynamic error = false;
  dynamic error2 = false;
  bool inputChange = false;
  FocusNode focusNode = FocusNode();
  FocusNode focusNode2 = FocusNode();

  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    VxState.watch(context, on: [ObsecurePassworldMutation]);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: loading
          ? loadingWidget()
          : Scaffold(
              backgroundColor: Vx.white,
              appBar: appBarForAuth(),
              body: Form(
                key: _formkey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 9.5461 * height,
                    ),
                    Container(
                      width: forWidth(270),
                      child: Image.asset("assets/images/logo/app_logo.png"),
                    ),
                    SizedBox(
                      height: 5.0281 * height,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                            color: Vx.black,
                            fontSize: 2.2112 * height,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      height: 0.9046 * height,
                    ),
                    TextFormField(
                      cursorColor: Vx.black,
                      style: TextStyle(fontSize: 1.9097 * height),
                      focusNode: focusNode,
                      onChanged: (val) {
                        email = val;
                      },
                      onTap: () {
                        setState(() {});
                      },
                      validator: (value) {
                        String emailRx =
                            (r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                        error = RegExp(emailRx).hasMatch(value!)
                            ? null
                            : "Invalid Email";
                        return error;
                      },
                      decoration: fieldInputDecoration(
                          "Email",
                          error,
                          inputChange,
                          focusNode.hasFocus ? true : false,
                          false),
                    ),
                    SizedBox(height: 1.1056 * height),
                    TextFormField(
                      cursorColor: Vx.black,
                      style: TextStyle(fontSize: 1.9097 * height),
                      focusNode: focusNode2,
                      obscureText: obsecurePassword,
                      onTap: () {
                        setState(() {});
                      },
                      validator: (value) {
                        error2 = value!.isNotEmpty
                            ? null
                            : "Password Can't Be Empty";
                        return error2;
                      },
                      onChanged: (val) {
                        password = val;
                      },
                      decoration: fieldInputDecoration(
                          "Password",
                          error2,
                          inputChange,
                          focusNode2.hasFocus ? true : false,
                          true),
                    ),
                    SizedBox(height: 3.1158 * height),
                    TextButton(
                      onPressed: () async {
                        setState(() {
                          inputChange = true;
                        });
                        if (_formkey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                          });
                          try {
                            dynamic result = await _authService
                                .signInWithEmailAndPassword(email, password);
                            Future.delayed(Duration(seconds: 3));
                            if (result == null) {
                              print("User Do Not Found");
                            }
                          } catch (e) {
                            setState(() {
                              loading = false;
                              String error = e.toString().split("] ")[1];
                              VxToast.show(context,
                                  msg: error,
                                  textSize: 1.6893 * height,
                                  showTime: 4000);
                            });
                          }
                        } else {
                          loading = false;
                        }
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                            fontSize: 1.80922 * height, color: Vx.white),
                      ),
                      style: TextButton.styleFrom(
                        fixedSize: Size(15.0768 * height, 5.52819 * height),
                        backgroundColor: Vx.hexToColor("#4773f1"),
                      ),
                    ),
                    SizedBox(height: 2.01025 * height),
                    askAuthChange(
                      context: context,
                      beforeText: "Don't Have An Account? ",
                    )
                  ],
                ).pSymmetric(h: 3.01537 * height),
              )),
    );
  }
}
