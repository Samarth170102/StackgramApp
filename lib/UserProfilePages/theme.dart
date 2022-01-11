import 'package:flutter/material.dart';
import 'package:flutter_application_8/CustomClasses/user_data_class.dart';
import 'package:flutter_application_8/Services/database_services.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets1.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets2.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets3.dart';
import 'package:flutter_application_8/main.dart';
import 'package:velocity_x/velocity_x.dart';

modalBottomSheetForTheme(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return StreamBuilder<UserDataModel>(
        stream: Database().docsSnap,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserDataModel? user = snapshot.data;
            bool darkMode = false;
            if (user!.darkMode == true) {
              darkMode = true;
            }
            return Container(
              color: darkMode ? Vx.black : Vx.white,
              height: 37.18966 * height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      "Theme",
                      style: TextStyle(
                          color: darkMode ? Vx.white : Vx.black,
                          fontSize: 3.01537 * height,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: 5.02563 * height,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 5.02563 * height,
                        child: Text(
                          " Mode",
                          style: TextStyle(
                              fontSize: 2.31179 * height,
                              color: darkMode ? Vx.white : Vx.black),
                        ),
                      ).pOnly(top: 2.51281 * height),
                      SizedBox(
                        width: 1.50768 * height,
                      ),
                      Container(
                        height: 8.041 * height,
                        width: width * 60,
                        child: Row(
                          children: [
                            GestureDetector(
                                onTap: () async {
                                  await Database()
                                      .dataCollection
                                      .doc(user.uid)
                                      .update({"darkMode": false});
                                },
                                child: themeBox("Light", Vx.black, "#FFFFFF")),
                            SizedBox(
                              width: 1.2061 * height,
                            ),
                            GestureDetector(
                                onTap: () async {
                                  await Database()
                                      .dataCollection
                                      .doc(user.uid)
                                      .update({"darkMode": true});
                                },
                                child: themeBox("Dark", Vx.white, "#000000"))
                          ],
                        ),
                      )
                    ],
                  ),
                  Container(
                    height: 5.02563 * height,
                    child: Text(
                      " Accent Color",
                      style: TextStyle(
                          fontSize: 2.3117 * height,
                          color: darkMode ? Vx.white : Vx.black),
                    ),
                  ).pOnly(top: 3.01537 * height),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 6.030 * height,
                        width: width * 94,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                themeSetMsg("#4773f1", context);
                                await Database()
                                    .dataCollection
                                    .doc(user.uid)
                                    .update({"accentColor": "#4773f1"});
                              },
                              child: themeBox("", Vx.white, "#4773f1"),
                            ),
                            GestureDetector(
                              onTap: () async {
                                themeSetMsg("#EC3E40", context);
                                await Database()
                                    .dataCollection
                                    .doc(user.uid)
                                    .update({"accentColor": "#EC3E40"});
                              },
                              child: themeBox("", Vx.white, "#EC3E40"),
                            ),
                            GestureDetector(
                              onTap: () async {
                                themeSetMsg("#996ee7", context);
                                await Database()
                                    .dataCollection
                                    .doc(user.uid)
                                    .update({"accentColor": "#996ee7"});
                              },
                              child: themeBox("", Vx.white, "#996ee7"),
                            ),
                            GestureDetector(
                              onTap: () async {
                                themeSetMsg("#ea5490", context);
                                await Database()
                                    .dataCollection
                                    .doc(user.uid)
                                    .update({"accentColor": "#ea5490"});
                              },
                              child: themeBox("", Vx.white, "#ea5490"),
                            ),
                          ],
                        ),
                      )
                    ],
                  ).pOnly(left: 0.6030 * height),
                ],
              ).pOnly(
                  left: 1.0052 * height,
                  right: 1.0052 * height,
                  top: 1.0052 * height),
            );
          }
          return loadingWidget(mode: UserDataModel().darkMode);
        },
      );
    },
  );
}
