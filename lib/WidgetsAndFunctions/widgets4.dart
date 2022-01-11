import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_8/CustomClasses/user_data_class.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets3.dart';
import 'package:page_transition/page_transition.dart';
import 'package:velocity_x/velocity_x.dart';

Map<Type, GestureRecognizerFactory<GestureRecognizer>> longPressNavigator(
    String type, BuildContext context,
    {Widget? page}) {
  return <Type, GestureRecognizerFactory>{
    LongPressGestureRecognizer:
        GestureRecognizerFactoryWithHandlers<LongPressGestureRecognizer>(
      () => LongPressGestureRecognizer(
        duration: Duration(milliseconds: 200),
      ),
      (LongPressGestureRecognizer instance) {
        instance.onLongPress = () {
          if (type == "pop") {
            Navigator.pop(context);
          } else {
            Navigator.push(
                context,
                PageTransition(
                    child: page ?? Container(),
                    duration: Duration(milliseconds: 180),
                    reverseDuration: Duration(milliseconds: 580),
                    type: PageTransitionType.scale,
                    alignment: Alignment.center));
          }
        };
      },
    ),
  };
}

Container userMenuOption(String optionName, String optionPng, bool darkMode) {
  return Container(
    color: darkMode ? Vx.black : Vx.white,
    child: Row(
      children: [
        Container(
          height:
              optionName == "About Us" || optionName == "Sign Out" ? 30 : 38,
          child: Image.asset("assets/images/bottombar/$optionPng.png",
              color: darkMode ? Vx.white : Vx.black),
        ),
        sizedBoxForWidth(optionName == "About Us" ? 13 : 10),
        Container(
          child: Text(
            optionName,
            style: TextStyle(
                fontSize: forHeight(20), color: darkMode ? Vx.white : Vx.black),
          ),
        ),
      ],
    ),
  );
}

InputDecoration inputDecorationEditProfile(
    EdgeInsets edgeInsets, UserDataModel user, BuildContext context) {
  return InputDecoration(
    contentPadding: edgeInsets,
    counterStyle: TextStyle(
        fontSize: forHeight(13), color: user.darkMode! ? Vx.white : Vx.gray400),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        width: forHeight(1.5),
        color: user.darkMode!
            ? Vx.hexToColor(user.accentColor.toString())
            : Vx.black.withOpacity(0.8),
      ),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        width: forHeight(1.5),
        color: user.darkMode! ? Vx.white : Vx.black.withOpacity(0.8),
      ),
    ),
  );
}

Padding rowForUserDetails(String type, String value, bool darkMode) {
  return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Text(
      type,
      style: TextStyle(
        color: darkMode ? Vx.white : Vx.black,
        fontSize: forHeight(17),
      ),
    ),
    Text(
      value,
      style: TextStyle(
        color: darkMode ? Vx.white : Vx.black,
        fontSize: forHeight(17),
      ),
    )
  ]).pOnly(top: forHeight(32));
}
