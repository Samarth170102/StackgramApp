import 'package:flutter/material.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets3.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets5.dart';
import 'package:flutter_application_8/main.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:image_cropper/image_cropper.dart';

class UploadPost extends StatefulWidget {
  @override
  UploadPostState createState() => UploadPostState();
}

dynamic imgFile;
String imgFilePath = "";

class UploadPostState extends State<UploadPost> {
  String caption = "";
  @override
  Widget build(BuildContext context) {
    final user = providerOfUserDataModel(context);
    bool darkMode = false;
    if (user.darkMode == true) {
      darkMode = true;
    }
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: darkMode ? Vx.black : Vx.white,
        body: Column(
          children: [
            Text(
              "Upload Image",
              style: TextStyle(
                  fontSize: forHeight(23),
                  fontWeight: FontWeight.w500,
                  color: darkMode ? Vx.white : Vx.black),
            ).objectCenterLeft().pOnly(left: forWidth(8)),
            imgFile == null
                ? Container(
                    child: Align(
                      child: ElevatedButton(
                        onPressed: () async {
                          imgFile = await getImage(context);
                          setState(() {});
                        },
                        style: TextButton.styleFrom(
                            backgroundColor:
                                Vx.hexToColor(user.accentColor.toString()),
                            fixedSize: Size(
                              forHeight(175),
                              forHeight(62),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(forHeight(6)))),
                        child: Text(
                          "Get Image",
                          style: TextStyle(fontSize: forHeight(20)),
                        ),
                      ),
                    ),
                  ).expand()
                : Container(
                    child: ListView(
                      children: [
                        sizedBoxForHeight(29),
                        Container(
                          height: forHeight(360),
                          width: width * 90,
                          child: Image.file(imgFile),
                        ).centered(),
                        GestureDetector(
                          onTap: () async {
                            imgFile = await ImageCropper.cropImage(
                                  sourcePath: imgFilePath,
                                  aspectRatioPresets: [
                                    CropAspectRatioPreset.square,
                                    CropAspectRatioPreset.ratio3x2,
                                    CropAspectRatioPreset.original,
                                    CropAspectRatioPreset.ratio4x3,
                                    CropAspectRatioPreset.ratio16x9
                                  ],
                                  androidUiSettings: AndroidUiSettings(
                                    toolbarTitle: 'Edit Image',
                                    activeControlsWidgetColor: Vx.hexToColor(
                                        user.accentColor.toString()),
                                    toolbarColor: Vx.hexToColor(
                                        user.accentColor.toString()),
                                    toolbarWidgetColor: Colors.white,
                                    statusBarColor: Vx.hexToColor(
                                        user.accentColor.toString()),
                                    initAspectRatio:
                                        CropAspectRatioPreset.original,
                                    lockAspectRatio: false,
                                  ),
                                ) ??
                                imgFile;
                            setState(() {});
                          },
                          child: Container(
                            height: forHeight(45),
                            width: forHeight(45),
                            child: Image.asset(
                              "assets/images/bottombar/edit_image.png",
                              color: Vx.hexToColor(user.accentColor.toString()),
                            ),
                          ).objectCenterRight().pOnly(right: forWidth(5)),
                        ),
                        TextField(
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 8,
                          onChanged: (value) => caption = value,
                          cursorColor:
                              Vx.hexToColor(user.accentColor.toString()),
                          style: TextStyle(
                              fontSize: forHeight(16),
                              height: forHeight(1.4),
                              color: darkMode ? Vx.white : Vx.black),
                          decoration: InputDecoration(
                            hintText: "Caption",
                            hintStyle: TextStyle(
                                color: darkMode ? Vx.white : Vx.black),
                            contentPadding: EdgeInsets.only(
                              top: forHeight(21),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                width: forHeight(1.5),
                                color:
                                    Vx.hexToColor(user.accentColor.toString()),
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                width: forHeight(1.5),
                                color: darkMode
                                    ? Vx.white
                                    : Vx.black.withOpacity(0.8),
                              ),
                            ),
                          ),
                        ).pSymmetric(h: forWidth(10))
                      ],
                    ),
                  ).expand(),
            Visibility(
              visible: imgFile != null,
              child: ElevatedButton(
                onPressed: () async {
                  await uploadPost(imgFile, caption.trim(), context);
                  setState(() {});
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(forHeight(4))),
                  backgroundColor: Vx.hexToColor(user.accentColor.toString()),
                  fixedSize: Size(
                    forHeight(115),
                    forHeight(45),
                  ),
                ),
                child: Text(
                  "Upload",
                  style: TextStyle(fontSize: forHeight(16)),
                ),
              ).pOnly(bottom: forHeight(13)),
            ),
          ],
        ),
      ),
    );
  }
}
