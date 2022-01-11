import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets3.dart';
import 'package:flutter_application_8/main.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:velocity_x/velocity_x.dart';

RichText askAuthChange({BuildContext? context, String? beforeText}) {
  return RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: beforeText,
          style: TextStyle(
            color: Vx.gray400,
            fontSize: 1.6082 * height,
          ),
        ),
        TextSpan(
            text: "Click Here",
            style: TextStyle(
              color: Vx.hexToColor("#4773f1"),
              fontSize: 1.6082 * height,
            ),
            recognizer: TapGestureRecognizer()..onTap = () => AuthMutation()),
      ],
    ),
  );
}

fieldInputDecoration(String inputType, dynamic error, bool textchange,
    bool floatColor, bool obsecureVisible) {
  return InputDecoration(
    suffixIcon: obsecureVisible
        ? Column(
            children: [
              sizedBoxForHeight(7),
              GestureDetector(
                onTap: () {
                  obsecurePassword = !obsecurePassword;
                  ObsecurePassworldMutation();
                },
                child: Container(
                  width: forWidth(35),
                  child: Image.asset(
                    "assets/images/bottombar/${obsecurePassword ? "hide_password" : "show_password"}.png",
                    color: (floatColor
                        ? Vx.hexToColor("#4773f1")
                        : Vx.black.withOpacity(0.6)),
                  ),
                ).pOnly(right: forWidth(9)),
              )
            ],
          )
        : null,
    floatingLabelStyle: textchange
        ? TextStyle(
            color: error == null
                ? (floatColor
                    ? Vx.hexToColor("#4773f1").withOpacity(0.8)
                    : Vx.black.withOpacity(0.6))
                : Vx.red700,
            fontSize: 1.70871 * height)
        : TextStyle(
            color: floatColor
                ? Vx.hexToColor("#4773f1").withOpacity(0.8)
                : Vx.black.withOpacity(0.6),
            fontSize: 1.70871 * height),
    filled: true,
    fillColor: Colors.transparent,
    labelText: "Enter $inputType",
    labelStyle: TextStyle(
      fontSize: 1.70871 * height,
      color: Vx.black.withOpacity(0.6),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Vx.hexToColor("#4773f1").withOpacity(0.8),
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Vx.black.withOpacity(0.8),
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Vx.red700,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Vx.red700,
      ),
    ),
  );
}

AppBar appBarForAuth({
  double? toolbarHeight,
  bool? mode,
  Color? specialColor,
}) {
  bool darkMode = false;
  if (mode == true) {
    darkMode = true;
  }
  return AppBar(
    systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor:
            darkMode ? Colors.transparent : specialColor ?? Colors.transparent,
        statusBarIconBrightness: darkMode ? Brightness.light : Brightness.dark),
    toolbarHeight: toolbarHeight ?? 5.52819 * height,
    backgroundColor: darkMode ? Vx.black : Vx.white,
    elevation: 0,
  );
}

Container loadingWidget({bool? mode, String? accentColor}) {
  bool darkMode = false;
  if (mode == true) {
    darkMode = true;
  }
  return Container(
    color: darkMode ? Vx.black : Colors.white,
    child: Center(
      child: SpinKitThreeInOut(
        color: Vx.hexToColor(accentColor ?? "#4773f1").withOpacity(0.9),
        size: 8.041 * height,
      ),
    ),
  );
}
