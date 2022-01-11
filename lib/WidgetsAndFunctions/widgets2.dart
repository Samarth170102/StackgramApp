import 'package:flutter/material.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets3.dart';
import 'package:flutter_application_8/main.dart';
import 'package:velocity_x/velocity_x.dart';

Container themeBox(String text, Color textColor, String backgroundColor) {
  return Container(
    height: 5.8307 * height,
    width: 9.96382 * height,
    child: Text(
      text,
      style: TextStyle(
          fontSize: 2.1107 * height,
          fontWeight: FontWeight.w600,
          color: textColor),
    ).centered(),
    decoration: BoxDecoration(
        color: Vx.hexToColor(backgroundColor),
        borderRadius: BorderRadius.circular(1.00512 * height)),
  );
}

BottomNavigationBarItem bottomNavigationBarItem(String text, String iconName,
    int myIndex, int screenIndex, bool darkMode, String accentColor) {
  return BottomNavigationBarItem(
    label: text,
    icon: Container(
      height: myIndex == screenIndex ? height * 3.3 : height * 3,
      child: Image.asset(
        "assets/images/bottombar/$iconName.png",
        color: myIndex == screenIndex
            ? Vx.hexToColor(accentColor)
            : darkMode
                ? Vx.white
                : Vx.gray500,
      ),
    ),
  );
}

Align commentBox(String username, Map<String, dynamic> mapMsg, bool darkMode,
    String accentColor, Map<String, dynamic>? usernamesMap) {
  String msgUsername = usernamesMap![mapMsg["userUid"]];
  return Align(
      alignment: username == msgUsername
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Card(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        child: Container(
            decoration: BoxDecoration(
                color: username == msgUsername
                    ? darkMode
                        ? Vx.white
                        : Vx.gray200
                    : Vx.hexToColor(accentColor),
                borderRadius: BorderRadius.circular(7)),
            constraints: BoxConstraints(
              maxWidth: forHeight(210),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: username != msgUsername,
                  child: Text(
                    msgUsername,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: forHeight(17),
                        color: username == msgUsername ? Vx.black : Vx.white),
                  ).pOnly(
                      top: forHeight(5),
                      left: forHeight(5),
                      right: forHeight(5)),
                ),
                Text(
                  mapMsg["msg"],
                  style: TextStyle(
                      fontSize: forHeight(17),
                      color: username == msgUsername ? Vx.black : Vx.white),
                ).pOnly(
                    bottom: forHeight(5),
                    left: forHeight(5),
                    right: forHeight(5),
                    top: username == msgUsername ? forHeight(5) : 0),
              ],
            )),
      ));
}
