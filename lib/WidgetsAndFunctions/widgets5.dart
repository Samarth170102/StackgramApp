import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_8/HomeScreens/upload_post.dart';
import 'package:flutter_application_8/Services/database_services.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets3.dart';
import 'package:flutter_application_8/main.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

uploadPost(File file, String caption, BuildContext context) async {
  final user = providerOfUserDataModel(context, listen: false);
  final main = providerOfMainDataModel(context, listen: false);
  VxToast.show(context,
      msg: "Post is uploading, Please wait",
      textSize: forHeight(15),
      showTime: 5500,
      position: VxToastPosition.center,
      bgColor: Vx.hexToColor(user.accentColor.toString()));
  final _firebaseStorage = FirebaseStorage.instance;
  String postImgName = "image${user.index}_" + user.uid.toString();
  DateTime now = DateTime.now();
  String postTime = DateFormat('dd-MM-yyyy').format(now);
  int index = user.index!.toInt();
  var storageRef = await _firebaseStorage
      .ref()
      .child("postImages/$postImgName")
      .putFile(file);
  var downloadUrl = await storageRef.ref.getDownloadURL();
  user.posts?[postImgName] = {
    "likes": 0,
    "likedBy": {},
    "comments": [],
    "likedList": [],
    "caption": caption,
    "imgUrl": downloadUrl,
    "uploadDate": postTime
  };
  main.stackPosts?.add({"uid": user.uid, "postImgName": postImgName});
  await Database().updateSingleDocData("posts", user.posts, context);
  await Database().updateMainDocData("stackPosts", main.stackPosts, context);
  await Database().updateSingleDocData("index", index + 1, context);
  imgFile = null;
  imgFilePath = "";
  VxToast.show(context,
      msg: "Post Uploaded",
      textSize: forHeight(15),
      position: VxToastPosition.top,
      showTime: 4000,
      bgColor: Vx.hexToColor(user.accentColor.toString()));
}

Row rowforHeadingInEditProfile(
    String heading, bool darkMode, BuildContext context) {
  return Row(children: [
    GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        onDoubleTap: () {
          Navigator.popUntil(context, (route) => route.isFirst);
        },
        child: Container(
            height: 5.72921 * height,
            width: 5.72921 * height,
            child: Align(
              child: Image.asset(
                "assets/images/bottombar/back.png",
                color: darkMode ? Vx.white : Vx.black,
              ).pSymmetric(h: 1.6082 * height),
            ))),
    Container(
      child: Text(
        heading,
        style: TextStyle(
            color: darkMode ? Vx.white : Vx.black,
            fontSize: 2.61332 * height,
            fontWeight: FontWeight.w500),
      ),
    ).pOnly(bottom: 0.20102 * height),
  ]);
}
