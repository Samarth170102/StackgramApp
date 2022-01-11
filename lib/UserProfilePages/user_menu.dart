import 'package:flutter/material.dart';
import 'package:flutter_application_8/CustomClasses/user_data_class.dart';
import 'package:flutter_application_8/HomePageSelector/homepage_selector.dart';
import 'package:flutter_application_8/Services/auth_services.dart';
import 'package:flutter_application_8/Services/database_services.dart';
import 'package:flutter_application_8/UserProfilePages/about_us.dart';
import 'package:flutter_application_8/UserProfilePages/clear_cache.dart';
import 'package:flutter_application_8/UserProfilePages/edit_profile.dart';
import 'package:flutter_application_8/UserProfilePages/theme.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets1.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets3.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets4.dart';
import 'package:page_transition/page_transition.dart';
import 'package:velocity_x/velocity_x.dart';

userMenuModalBottomSheet(BuildContext context, bool darkmode) {
  final userAuthData = providerOfUserAuthData(context, listen: false);
  String creationTime = userAuthData!.creationTime.split(" ")[0];
  String lastSignInTime = userAuthData.lastSignInTime.split(" ")[0];
  return showModalBottomSheet(
      context: context,
      builder: (context) {
        return StreamBuilder<UserDataModel>(
            stream: Database().docsSnap,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final user = snapshot.data;
                return Container(
                  height: forHeight(370),
                  color: user!.darkMode! ? Vx.black : Vx.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "User Menu",
                        style: TextStyle(
                            fontSize: forHeight(25),
                            fontWeight: FontWeight.w500,
                            color: user.darkMode! ? Vx.white : Vx.black),
                      ).pOnly(top: forHeight(5)),
                      sizedBoxForHeight(37),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              PageTransition(
                                child:
                                    EditProfile(creationTime, lastSignInTime),
                                type: PageTransitionType.bottomToTop,
                                duration: Duration(milliseconds: 250),
                                reverseDuration: Duration(milliseconds: 250),
                              ),
                            ),
                            child: userMenuOption("Edit Profile",
                                    "edit_profile", user.darkMode!)
                                .pOnly(bottom: forHeight(23)),
                          ),
                          GestureDetector(
                              onTap: () => modalBottomSheetForTheme(context),
                              child: userMenuOption(
                                      "Theme", "theme", user.darkMode!)
                                  .pOnly(
                                bottom: forHeight(23),
                              )),
                          GestureDetector(
                            onTap: () => modalBottomSheetForClearCache(context),
                            child: userMenuOption(
                                    "Clear Cache", "clear", user.darkMode!)
                                .pOnly(bottom: forHeight(23)),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              PageTransition(
                                child: AboutUs(),
                                type: PageTransitionType.bottomToTop,
                                duration: Duration(milliseconds: 250),
                                reverseDuration: Duration(milliseconds: 250),
                              ),
                            ),
                            child: userMenuOption(
                                    "About Us", "about_us", user.darkMode!)
                                .pOnly(left: forWidth(5.7)),
                          ).pOnly(
                            bottom: forHeight(23),
                          ),
                          GestureDetector(
                            onTap: () {
                              AuthService().signOut();
                              indexOfPage = 0;
                              Navigator.pop(context);
                            },
                            child: userMenuOption(
                                    "Sign Out", "sign_out", user.darkMode!)
                                .pOnly(left: forWidth(10.5)),
                          ),
                        ],
                      ).pOnly(left: forWidth(7))
                    ],
                  ).pOnly(
                    left: forWidth(5),
                  ),
                );
              } else {
                return loadingWidget(mode: darkmode);
              }
            });
      });
}
