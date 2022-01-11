// ignore_for_file: prefer_adjacent_string_concatenation, must_be_immutable
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_8/CustomClasses/user_data_class.dart';
import 'package:flutter_application_8/Services/database_services.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets1.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets3.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets4.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets5.dart';
import 'package:flutter_application_8/main.dart';
import 'package:velocity_x/velocity_x.dart';

class EditProfile extends StatefulWidget {
  String creationTime;
  String lastSignIn;
  EditProfile(this.creationTime, this.lastSignIn);
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserDataModel>(
        stream: Database().docsSnap,
        builder: (context2, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data;
            String username = user!.username.toString();
            String name = user.name.toString().trim();
            String bio = user.bio.toString().trim();
            return StreamBuilder<MainDataModel>(
                stream: Database().mainDocsSnap,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final usernamesList = snapshot.data!.usernames;
                    var usernamesMap = snapshot.data!.usernamesMap;
                    var profilePhotosMap = snapshot.data!.profilePhotosMap;
                    return GestureDetector(
                        onTap: () => FocusScope.of(context).unfocus(),
                        child: Scaffold(
                            backgroundColor:
                                user.darkMode! ? Vx.black : Vx.white,
                            appBar: appBarForAuth(
                                toolbarHeight: 0, mode: user.darkMode!),
                            body: Form(
                                key: _formkey,
                                child: Column(children: [
                                  rowforHeadingInEditProfile(
                                      "Edit Profile", user.darkMode!, context),
                                  sizedBoxForHeight(15),
                                  Container(
                                      height: forHeight(150),
                                      width: forHeight(150),
                                      child: CircleAvatar(
                                        key: UniqueKey(),
                                        backgroundColor: Vx.white,
                                        backgroundImage:
                                            CachedNetworkImageProvider(user
                                                .profilePhotoUrl
                                                .toString()),
                                      )),
                                  sizedBoxForHeight(21),
                                  GestureDetector(
                                    onTap: () async {
                                      await uploadProfilePic(
                                          context,
                                          user.uid.toString(),
                                          profilePhotosMap,
                                          user.darkMode!,
                                          user.accentColor.toString());
                                    },
                                    child: Text(
                                      "Change Profile Photo",
                                      style: TextStyle(
                                          color: Vx.hexToColor(
                                              user.accentColor.toString()),
                                          fontSize: forHeight(16)),
                                    ).pOnly(left: forWidth(5)),
                                  ),
                                  sizedBoxForHeight(41),
                                  ListView(shrinkWrap: true, children: [
                                    Row(children: [
                                      Container(
                                        height: forHeight(45),
                                        child: Text("Username",
                                            style: TextStyle(
                                              color: user.darkMode!
                                                  ? Vx.white
                                                  : Vx.black,
                                              fontSize: forHeight(17),
                                            )).objectTopCenter(),
                                      ),
                                      sizedBoxForWidth(13),
                                      Container(
                                        height: forHeight(45),
                                        width: width * 66,
                                        child: TextFormField(
                                            maxLength: 20,
                                            initialValue: user.username,
                                            cursorColor: user.darkMode!
                                                ? Vx.white
                                                : Vx.black,
                                            style: TextStyle(
                                                color: user.darkMode!
                                                    ? Vx.white
                                                    : Vx.black,
                                                fontSize: 1.9097 * height),
                                            decoration:
                                                inputDecorationEditProfile(
                                                    EdgeInsets.only(
                                                        bottom: forHeight(14)),
                                                    user,
                                                    context),
                                            validator: (value) {
                                              if (user.lastUsername
                                                      .toString() !=
                                                  value) {
                                                if (value!.isEmpty) {
                                                  return "Username can't be Empty";
                                                } else if (usernamesList!
                                                    .contains(
                                                        value.toLowerCase())) {
                                                  return "Username already exist";
                                                } else if (value
                                                    .contains(" ")) {
                                                  return "No space in username";
                                                } else {
                                                  return null;
                                                }
                                              } else {
                                                return null;
                                              }
                                            },
                                            onChanged: (val) {
                                              username = val;
                                            }).objectBottomCenter(),
                                      )
                                    ]),
                                    Row(children: [
                                      Container(
                                          child: Text(
                                        "Name",
                                        style: TextStyle(
                                          color: user.darkMode!
                                              ? Vx.white
                                              : Vx.black,
                                          fontSize: forHeight(17),
                                        ),
                                      )).pOnly(top: 24),
                                      sizedBoxForWidth(13),
                                      Container(
                                        width: width * 76,
                                        child: TextFormField(
                                          initialValue: user.name,
                                          cursorColor: user.darkMode!
                                              ? Vx.white
                                              : Vx.black,
                                          style: TextStyle(
                                              color: user.darkMode!
                                                  ? Vx.white
                                                  : Vx.black,
                                              fontSize: 1.9097 * height),
                                          decoration:
                                              inputDecorationEditProfile(
                                                  EdgeInsets.only(
                                                      top: forHeight(26)),
                                                  user,
                                                  context),
                                          validator: (value) => value!.isEmpty
                                              ? "Name cannot be empty"
                                              : null,
                                          onChanged: (val) {
                                            name = val;
                                          },
                                        ).objectBottomCenter(),
                                      )
                                    ]),
                                    sizedBoxForHeight(15),
                                    Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Bio",
                                            style: TextStyle(
                                              color: user.darkMode!
                                                  ? Vx.white
                                                  : Vx.black,
                                              fontSize: forHeight(17),
                                            ),
                                          ).pOnly(top: forHeight(26)),
                                          sizedBoxForWidth(13),
                                          Container(
                                              width: width * 81.4,
                                              child: TextFormField(
                                                  initialValue:
                                                      user.bio!.trim(),
                                                  cursorColor: user.darkMode!
                                                      ? Vx.white
                                                      : Vx.black,
                                                  style: TextStyle(
                                                      color: user.darkMode!
                                                          ? Vx.white
                                                          : Vx.black,
                                                      fontSize:
                                                          1.9097 * height),
                                                  keyboardType:
                                                      TextInputType.multiline,
                                                  maxLines: 4,
                                                  decoration:
                                                      inputDecorationEditProfile(
                                                          EdgeInsets.only(
                                                              top: forHeight(
                                                                  24)),
                                                          user,
                                                          context),
                                                  onChanged: (val) {
                                                    bio = val;
                                                  }))
                                        ]),
                                    rowForUserDetails("Email",
                                        user.email.toString(), user.darkMode!),
                                    rowForUserDetails("Account Created",
                                        widget.creationTime, user.darkMode!),
                                    rowForUserDetails("Last Sign In",
                                        widget.lastSignIn, user.darkMode!),
                                    sizedBoxForHeight(50),
                                    Align(
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            if (_formkey.currentState!
                                                .validate()) {
                                              VxToast.show(context,
                                                  msg: "Saved",
                                                  bgColor: user.darkMode!
                                                      ? Vx.hexToColor(user
                                                          .accentColor
                                                          .toString())
                                                      : Vx.black,
                                                  position:
                                                      VxToastPosition.center,
                                                  textSize: forHeight(18));
                                              await Database()
                                                  .dataCollection
                                                  .doc(user.uid)
                                                  .update(
                                                      {"username": username, "lastUsername": username,
                                                "name": name,"bio": bio});
                                              int index = usernamesList!
                                                  .indexOf(user.lastUsername
                                                      .toString());
                                              usernamesList[index] = username;
                                              await Database()
                                                  .updateMainDocData(
                                                      "usernames",
                                                      usernamesList,
                                                      context);
                                              usernamesMap![user.uid
                                                  .toString()] = username;
                                              await Database()
                                                  .updateMainDocData(
                                                      "usernamesMap",
                                                      usernamesMap,
                                                      context);
                                            }
                                          },
                                          style: TextButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          forHeight(4))),
                                              backgroundColor: Vx.hexToColor(
                                                  user.accentColor.toString()),
                                              fixedSize: Size(
                                                forHeight(137),
                                                forHeight(50),
                                              )),
                                          child: Text(
                                            "Save",
                                            style: TextStyle(
                                                fontSize: forHeight(16)),
                                          )).pOnly(bottom: forHeight(13)),
                                    )
                                  ]).pSymmetric(h: forWidth(10)).expand(),
                                ]))));
                  } else {
                    return loadingWidget(mode: user.darkMode!);
                  }
                });
          } else {
            return loadingWidget(mode: UserDataModel().darkMode);
          }
        });
  }
}
