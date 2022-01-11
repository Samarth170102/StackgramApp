// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_application_8/CustomClasses/user_data_class.dart';
import 'package:flutter_application_8/Services/auth_services.dart';
import 'package:flutter_application_8/Services/database_services.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets1.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets3.dart';
import 'package:flutter_application_8/main.dart';
import 'package:velocity_x/velocity_x.dart';

class VerifyEmail extends StatefulWidget {
  String email;
  String password;
  VerifyEmail(this.email, this.password);

  @override
  _VerifyEmailState createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  String inputOTP = "";
  bool loading = false;
  dynamic error = false;
  bool inputChange = false;
  FocusNode focusNode = FocusNode();
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MainDataModel>(
        stream: Database().mainDocsSnap,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final main = snapshot.data;
            final emailVerificationOTP =
                main!.emailVerificaton![widget.email]["OTP"];
            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: WillPopScope(
                onWillPop: () async => false,
                child: Scaffold(
                    backgroundColor: Vx.white,
                    appBar: appBarForAuth(toolbarHeight: 0),
                    body: Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          Text(
                            "Email Verification",
                            style: TextStyle(
                                fontSize: forHeight(23),
                                fontWeight: FontWeight.w500,
                                color: Vx.black),
                          ).objectCenterLeft(),
                          sizedBoxForHeight(40),
                          Container(
                            width: forWidth(120),
                            child: Image.asset(
                                "assets/images/bottombar/email.png"),
                          ),
                          RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  style: TextStyle(
                                      color: Vx.black, fontSize: forHeight(22)),
                                  children: [
                                    TextSpan(text: "Check your"),
                                    TextSpan(
                                        text: " Email Inbox\n",
                                        style: TextStyle(
                                            color: Vx.black,
                                            fontWeight: FontWeight.w700)),
                                    TextSpan(text: "Type here the received "),
                                    TextSpan(
                                        text: "OTP",
                                        style: TextStyle(
                                            color: Vx.black,
                                            fontWeight: FontWeight.w700)),
                                  ])),
                          sizedBoxForHeight(50),
                          TextFormField(
                            cursorColor: Vx.black,
                            style: TextStyle(fontSize: 1.9097 * height),
                            focusNode: focusNode,
                            onChanged: (val) {
                              inputOTP = val;
                            },
                            onTap: () {
                              setState(() {});
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                error = "Please enter the OTP";
                              } else if (emailVerificationOTP != value.trim()) {
                                error = "Invalid OTP";
                              } else {
                                error = null;
                              }
                              return error;
                            },
                            decoration: fieldInputDecoration(
                                "OTP",
                                error,
                                inputChange,
                                focusNode.hasFocus ? true : false,
                                false),
                          ).pSymmetric(h: forWidth(20)),
                          sizedBoxForHeight(25),
                          TextButton(
                            onPressed: () async {
                              setState(() {
                                inputChange = true;
                              });
                              if (_formkey.currentState!.validate()) {
                                await AuthService().signUpWithEmailAndPassword(
                                    widget.email, widget.password);
                                VxToast.show(context,
                                    msg: "Verification Successful!");
                                FocusScope.of(context).unfocus();
                                Navigator.pop(context);
                              }
                            },
                            child: Text(
                              "Verify",
                              style: TextStyle(
                                  fontSize: 2.10922 * height, color: Vx.white),
                            ),
                            style: TextButton.styleFrom(
                              fixedSize: Size(forHeight(110), forHeight(50)),
                              backgroundColor: Vx.hexToColor("#4773f1"),
                            ),
                          )
                        ],
                      ).pSymmetric(h: forWidth(10)).wFull(context),
                    )),
              ),
            );
          } else {
            return loadingWidget();
          }
        });
  }
}
