import 'package:flutter/material.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets3.dart';
import 'package:velocity_x/velocity_x.dart';

Align chatBox(String username, Map<String, dynamic> mapMsg, bool darkMode,
    String accentColor, Map<String, dynamic>? usernamesMap) {
  String msgUsername = usernamesMap![mapMsg["userUid"]];
  String msgTime = mapMsg["msgTime"];
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
              crossAxisAlignment: username == msgUsername
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  mapMsg["msg"],
                  style: TextStyle(
                      fontSize: forHeight(17),
                      color: username == msgUsername ? Vx.black : Vx.white),
                ).pOnly(
                    left: forHeight(5), right: forHeight(5), top: forHeight(5)),
                Text(
                  msgTime.substring(0, msgTime.lastIndexOf(" ")),
                  style: TextStyle(
                      fontSize: forHeight(13),
                      color: username == msgUsername ? Vx.black : Vx.white),
                ).pOnly(
                    bottom: forHeight(5),
                    left: forHeight(5),
                    right: forHeight(5),
                    top: forHeight(5)),
              ],
            )),
      ));
}
