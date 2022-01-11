// ignore_for_file: prefer_adjacent_string_concatenation, must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_application_8/CustomClasses/user_data_class.dart';
import 'package:flutter_application_8/Services/database_services.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets1.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets3.dart';
import 'package:flutter_application_8/main.dart';
import 'package:velocity_x/velocity_x.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserDataModel>(
        stream: Database().docsSnap,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data;
            return Scaffold(
              backgroundColor: user!.darkMode! ? Vx.black : Vx.gray100,
              appBar: appBarForAuth(
                  toolbarHeight: 0,
                  mode: user.darkMode!,
                  specialColor: Vx.gray100),
              body: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 5.72921 * height,
                          width: 5.72921 * height,
                          child: Align(
                            child: Image.asset(
                              "assets/images/bottombar/back.png",
                              color: user.darkMode! ? Vx.white : Vx.black,
                            ).pSymmetric(h: 1.6082 * height),
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          "About Us",
                          style: TextStyle(
                              color: user.darkMode! ? Vx.white : Vx.black,
                              fontSize: 2.61332 * height,
                              fontWeight: FontWeight.w500),
                        ),
                      ).pOnly(bottom: 0.20102 * height),
                    ],
                  ),
                  SizedBox(
                    height: 5.02563 * height,
                  ),
                  Column(
                    children: [
                      Container(
                        height: 16.5845 * height,
                        width: 16.5845 * height,
                        decoration: BoxDecoration(
                            color: Vx.white,
                            borderRadius:
                                BorderRadius.circular(1.507689 * height)),
                        child: Image.asset(
                          "assets/images/logo/icon_logo.png",
                        ).pSymmetric(h: 2.0102 * height),
                      ),
                      SizedBox(
                        height: 0.70358 * height,
                      ),
                      Text(
                        "Stackgram v1.0",
                        style: TextStyle(
                            fontSize: 1.6082 * height,
                            color: user.darkMode! ? Vx.white : Vx.black),
                      ),
                      SizedBox(height: 7.0358 * height),
                      Text(
                        "Stackgram is the social media platform where you can " +
                            "share your memories or share your thoughts,  " +
                            "The user friendly and simple UI makes Stackgram" +
                            " very easy to use.",
                        style: TextStyle(
                            color: user.darkMode! ? Vx.white : Vx.black,
                            fontSize: 1.88922 * height),
                      ).pSymmetric(h: 1.0052 * height),
                      SizedBox(
                        height: forHeight(40),
                      ),
                    ],
                  ).pSymmetric(h: 0.1214 * height),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Made With ",
                        style: TextStyle(
                            color: user.darkMode! ? Vx.white : Vx.black,
                            fontSize: 2.5128 * height),
                      ),
                      Container(
                        height: 3.01537 * height,
                        child: Image.asset(
                            "assets/images/bottombar/like-fill.png",
                            color: Vx.red500),
                      )
                    ],
                  ),
                  Text(
                    "By Samarth",
                    style: TextStyle(
                        fontSize: 1.80922 * height,
                        color: user.darkMode! ? Vx.white : Vx.gray500),
                  ),
                  SizedBox(height: 1.0052 * height)
                ],
              ),
            );
          } else {
            return loadingWidget(mode: UserDataModel().darkMode);
          }
        });
  }
}
