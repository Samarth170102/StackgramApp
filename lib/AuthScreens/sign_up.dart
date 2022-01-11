import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_8/HomeScreens/verify_email.dart';
import 'package:flutter_application_8/Services/database_services.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets1.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets3.dart';
import 'package:flutter_application_8/main.dart';
import 'package:page_transition/page_transition.dart';
import 'package:velocity_x/velocity_x.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email = "";
  String password = "";
  final _formkey = GlobalKey<FormState>();
  bool loading = false;
  dynamic error = false;
  dynamic error2 = false;
  bool inputChange = false;
  FocusNode focusNode = FocusNode();
  FocusNode focusNode2 = FocusNode();
  String OTP = "";

  Future sendEmail(String email, String OTP) async {
    final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
    await http.post(url,
        headers: {
          "origin": "http://localhost",
          "Content-Type": "application/json",
        },
        body: json.encode({
          "service_id": "service_cxk24dr",
          "template_id": "template_lqpsno8",
          "user_id": "user_8Dqk1xlrgn2ct4FM1JTA5",
          "template_params": {"user_email_to_send": email, "otp": OTP}
        }));
  }

  @override
  Widget build(BuildContext context) {
    VxState.watch(context, on: [ObsecurePassworldMutation]);
    final main = providerOfMainDataModel(context);
    Map<String, dynamic>? emailVerification = main.emailVerificaton;
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
                        "Sign Up",
                        style: TextStyle(
                            color: Vx.black.withOpacity(0.7),
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
                        if (value!.isEmpty) {
                          error2 = "Password Can't Be Empty";
                        } else if (value.length < 7) {
                          error2 = "Minimum length is 7 characters";
                        } else {
                          error2 = null;
                        }
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
                        FocusScope.of(context).unfocus();
                        if (_formkey.currentState!.validate()) {
                          try {
                            Random random = Random();
                            String OTP =
                                (random.nextInt(899999) + 100000).toString();
                            if (emailVerification!.containsKey(email)) {
                              throw "] Email is already registered!";
                            } else {
                              emailVerification[email] = {
                                "password": password,
                                "OTP": OTP
                              };
                              Database().updateMainDocData("emailVerification",
                                  emailVerification, context);
                              VxToast.show(context,
                                  msg: "Sending verification email..",
                                  showTime: 5000);
                              await sendEmail(email, OTP);
                              await Future.delayed(Duration(seconds: 2));
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: VerifyEmail(email, password),
                                      type: PageTransitionType.bottomToTop));
                              setState(() {
                                loading = true;
                              });
                            }
                          } catch (e) {
                            setState(() {
                              loading = false;
                              String error = e.toString().split("] ")[1];
                              VxToast.show(context,
                                  msg: error,
                                  textSize: 1.6893 * height,
                                  showTime: 3000);
                            });
                          }
                        } else {
                          loading = false;
                        }
                      },
                      child: Text(
                        "Sign Up",
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
                      beforeText: "Already Have An Account? ",
                    )
                  ],
                ).pSymmetric(h: 3.01537 * height),
              )),
    );
  }
}
