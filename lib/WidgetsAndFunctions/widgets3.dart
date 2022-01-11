import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_8/CustomClasses/user_auth_class.dart';
import 'package:flutter_application_8/CustomClasses/user_data_class.dart';
import 'package:flutter_application_8/HomeScreens/upload_post.dart';
import 'package:flutter_application_8/Services/database_services.dart';
import 'package:flutter_application_8/main.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

uploadProfilePic(
    BuildContext context,
    String uid,
    Map<String, dynamic>? profilePhotosMap,
    bool darkMode,
    String accentColor) async {
  final _firebaseStorage = FirebaseStorage.instance;
  final imagePicker = ImagePicker();
  XFile? image;
  await Permission.photos.request();
  final permissionStatus = await Permission.photos.status;
  if (permissionStatus.isGranted) {
    image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      var file = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Edit Image',
            activeControlsWidgetColor: Vx.hexToColor(accentColor),
            toolbarColor: Vx.hexToColor(accentColor),
            toolbarWidgetColor: Colors.white,
            statusBarColor: Vx.hexToColor(accentColor),
            initAspectRatio: CropAspectRatioPreset.square,
            showCropGrid: true,
            lockAspectRatio: false),
      );
      if (file != null) {
        VxToast.show(context,
            msg: "Photo is uploading, Please wait",
            showTime: 3000,
            textSize: forHeight(15),
            bgColor: darkMode ? Vx.hexToColor(accentColor) : Vx.black);
        var storageRef = await _firebaseStorage
            .ref()
            .child("profilePhotos/$uid")
            .putFile(file);
        var downloadUrl = await storageRef.ref.getDownloadURL();
        profilePhotosMap![uid] = downloadUrl;
        await Database()
            .updateMainDocData("profilePhotosMap", profilePhotosMap, context);
        await Database()
            .dataCollection
            .doc(uid)
            .update({"profilePhotoUrl": downloadUrl});
        VxToast.show(context,
            msg: "Profile photo updated!",
            showTime: 2000,
            textSize: forHeight(15),
            bgColor: darkMode ? Vx.hexToColor(accentColor) : Vx.black);
      }
    }
  } else {
    print(darkMode);
    VxToast.show(context,
        msg: "Permission Not Granted",
        textSize: forHeight(15),
        bgColor: darkMode ? Vx.hexToColor(accentColor) : Vx.black);
  }
}

Future getImage(BuildContext context) async {
  final imagePicker = ImagePicker();
  XFile? image;
  await Permission.photos.request();
  final permissionStatus = await Permission.photos.status;
  if (permissionStatus.isGranted) {
    image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imgFilePath = image.path;
      return File(image.path);
    }
  } else {
    VxToast.show(context, msg: "Permission Not Granted");
  }
}

double forHeight(double size) {
  return (size / 8.533333333333333) * height;
}

double forWidth(double size) {
  return (size / 3.84) * width;
}

themeSetMsg(String accentColor, BuildContext context) {
  return VxToast.show(context,
      msg: "Theme Set",
      bgColor: Vx.hexToColor(accentColor),
      position: VxToastPosition.center,
      textSize: forHeight(18));
}

UserAuthData? providerOfUserAuthData(BuildContext context, {bool? listen}) {
  return Provider.of<UserAuthData?>(context, listen: listen ?? true);
}

UserDataModel providerOfUserDataModel(BuildContext context, {bool? listen}) {
  return Provider.of<UserDataModel>(context, listen: listen ?? true);
}

MainDataModel providerOfMainDataModel(BuildContext context, {bool? listen}) {
  return Provider.of<MainDataModel>(context, listen: listen ?? true);
}

SizedBox sizedBoxForHeight(double height) {
  return SizedBox(
    height: forHeight(height),
  );
}

SizedBox sizedBoxForWidth(double width) {
  return SizedBox(
    width: forWidth(width),
  );
}
