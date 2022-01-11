import 'package:flutter/material.dart';
import 'package:flutter_application_8/CustomClasses/user_data_class.dart';
import 'package:flutter_application_8/Services/database_services.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets1.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets3.dart';
import 'package:flutter_application_8/main.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class WelcomeUser extends StatefulWidget {
  @override
  _WelcomeUserState createState() => _WelcomeUserState();
}

class _WelcomeUserState extends State<WelcomeUser> {
  String name = "";
  String username = "";
  final _formkey = GlobalKey<FormState>();
  bool loading = false;
  dynamic error = false;
  dynamic error2 = false;
  bool inputChange = false;
  FocusNode focusNode = FocusNode();
  FocusNode focusNode2 = FocusNode();

  @override
  Widget build(BuildContext context) {
    final main = Provider.of<MainDataModel>(context);
    final user = providerOfUserDataModel(context);
    var usernamesMap = main.usernamesMap;
    var profilePhotosMap = main.profilePhotosMap;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: loading
          ? loadingWidget()
          : Scaffold(
              appBar: appBarForAuth(),
              backgroundColor: Vx.white,
              body: Form(
                key: _formkey,
                child: Column(
                  children: [
                    SizedBox(height: 17.08714 * height),
                    Column(
                      children: [
                        Text(
                          "Welcome new user",
                          style: TextStyle(
                              color: Vx.black, fontSize: 3.51794 * height),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "to, ",
                              style: TextStyle(
                                  color: Vx.black, fontSize: 3.51794 * height),
                            ),
                            Image.asset(
                              'assets/images/logo/app_logo.png',
                              width: forWidth(190),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 7.041 * height),
                    TextFormField(
                      cursorColor: Vx.black,
                      style: TextStyle(fontSize: 1.9097 * height),
                      focusNode: focusNode,
                      onTap: () {
                        setState(() {});
                      },
                      validator: (value) {
                        error =
                            value!.isNotEmpty ? null : "Name can't be empty";
                        return error;
                      },
                      onChanged: (val) {
                        name = val;
                      },
                      decoration: fieldInputDecoration("Name", error,
                          inputChange, focusNode.hasFocus ? true : false,false),
                    ),
                    sizedBoxForHeight(10),
                    TextFormField(
                      cursorColor: Vx.black,
                      style: TextStyle(fontSize: 1.9097 * height),
                      focusNode: focusNode2,
                      onTap: () {
                        setState(() {});
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          error2 = "Username can't be Empty";
                        } else if (main.usernames!
                            .contains(value.toLowerCase())) {
                          error2 = "Username already exist";
                        } else if (value.contains(" ")) {
                          error2 = "Username should not have any space";
                        } else if (username.length > 20) {
                          error2 = "Username is more than 20 characters";
                        } else {
                          error2 = null;
                        }
                        return error2;
                      },
                      onChanged: (val) {
                        username = val;
                      },
                      decoration: fieldInputDecoration("Username", error2,
                          inputChange, focusNode2.hasFocus ? true : false,false),
                    ),
                    sizedBoxForHeight(25),
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
                            main.usernames!.add(username.toLowerCase());
                            await Database().updateMainDocData(
                                "usernames", main.usernames, context);
                            await Future.delayed(Duration(seconds: 1));
                            await Database()
                                .updateSingleDocData("name", name, context);
                            await Database().updateSingleDocData(
                                "lastUsername", username, context);
                            usernamesMap![user.uid.toString()] = username;
                            await Database().updateMainDocData(
                                "usernamesMap", usernamesMap, context);
                            profilePhotosMap![user.uid.toString()] =
                                "https://firebasestorage.googleapis.com/v0/b/testapp4-53638.ap"
                                "pspot.com/o/profilePhotos%2FdefaultProfilePhoto.png?alt=media"
                                "&token=0ce0af4f-15c8-496c-aab6-46f428ac9180";
                            await Database().updateMainDocData(
                                "profilePhotosMap", profilePhotosMap, context);
                            await Database().updateSingleDocData(
                                "username", username, context);
                          } catch (e) {
                            setState(() {
                              loading = false;
                            });
                          }
                        } else {
                          loading = false;
                        }
                      },
                      child: Text(
                        "Submit",
                        style: TextStyle(
                            fontSize: 2.01025 * height, color: Vx.white),
                      ),
                      style: TextButton.styleFrom(
                        fixedSize: Size(15.1224 * height, 5.52819 * height),
                        backgroundColor: Vx.hexToColor("#4773f1"),
                      ),
                    ),
                  ],
                ).pSymmetric(h: 3.01537 * height),
              ),
            ),
    );
  }
}
