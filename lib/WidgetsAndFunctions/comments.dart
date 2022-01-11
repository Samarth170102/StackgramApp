import 'package:flutter/material.dart';
import 'package:flutter_application_8/Services/database_services.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets2.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets3.dart';
import 'package:flutter_application_8/main.dart';
import 'package:velocity_x/velocity_x.dart';

modalBottomSheetForComments(
    List comments,
    String uid,
    String userUid,
    String postImgName,
    Map<String, dynamic> userPost,
    Map<String, dynamic> post,
    String accentColor,
    bool darkMode,
    BuildContext context) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        VxState.watch(context, on: [PageChangeMutation]);
        final main = providerOfMainDataModel(context);
        TextEditingController textController = TextEditingController();
        Map<String, dynamic>? usernamesMap = main.usernamesMap;
        String username = usernamesMap![uid];
        String commentString = "";
        FocusNode focusNode = FocusNode();

        Future doComment(String value) async {
          if (value != "") {
            textController.clear();
            if (value.isNotEmpty) {
              comments.add({"userUid": uid, "msg": value});
              userPost[postImgName] = post;
              Database()
                  .dataCollection
                  .doc(userUid)
                  .update({"posts": userPost});
            }
            PageChangeMutation();
          } else {
            VxToast.show(context,
                msg: "Cannot send an empty comment",
                textSize: forHeight(15),
                position: VxToastPosition.bottom,
                showTime: 4000,
                bgColor: darkMode ? Vx.hexToColor(accentColor) : Vx.black);
          }
        }

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            body: Column(
              children: [
                Container(
                  color: darkMode ? Vx.black : Vx.white,
                  child: ListView(
                    children: [
                      Container(
                        child: Text(
                          "Comments",
                          style: TextStyle(
                              color: darkMode ? Vx.white : Vx.black,
                              fontSize: 3.01537 * height,
                              fontWeight: FontWeight.w500),
                        ).pOnly(top: 1.0052 * height),
                      ).objectCenterLeft(),
                      sizedBoxForHeight(20),
                      comments.isEmpty
                          ? Container(
                              child: Text(
                                "No one has commented yet",
                                style: TextStyle(
                                    fontSize: forHeight(22),
                                    color: darkMode ? Vx.white : Vx.gray400),
                              ).centered(),
                            ).pOnly(top: forHeight(150))
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: comments.length,
                              itemBuilder: (BuildContext context, int index) {
                                var msgDetails = comments[index];
                                return commentBox(username, msgDetails,
                                    darkMode, accentColor, usernamesMap);
                              },
                            ),
                    ],
                  ).pOnly(
                    left: 1.0052 * height,
                    right: 1.0052 * height,
                  ),
                ).expand(),
                Container(
                  child: Row(
                    children: [
                      Container(
                        width: forWidth(318),
                        color: darkMode ? Vx.black : Vx.white,
                        child: TextFormField(
                          focusNode: focusNode,
                          controller: textController,
                          onFieldSubmitted: (value) async {
                            await doComment(value);
                          },
                          onChanged: (value) => commentString = value,
                          style: TextStyle(
                              fontSize: forHeight(17),
                              color: darkMode ? Vx.white : Vx.black),
                          cursorColor: Vx.hexToColor(accentColor),
                          decoration: InputDecoration(
                            hintText: "Enter Your Comment..",
                            hintStyle: TextStyle(
                                fontSize: forHeight(18),
                                color: darkMode ? Vx.white : Vx.gray500),
                            border: InputBorder.none,
                          ),
                        ),
                      ).pOnly(left: forHeight(20)),
                      Container(
                        width: forWidth(35),
                        height: forHeight(35),
                        child: GestureDetector(
                          onTap: () async {
                            focusNode.unfocus();
                            await doComment(commentString);
                          },
                          child: Image.asset(
                            "assets/images/bottombar/send.png",
                            color: Vx.hexToColor(accentColor),
                          ).objectCenterRight(),
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: darkMode ? Vx.black : Vx.white,
                      border: Border(
                          top: BorderSide(
                              color: Vx.gray400, width: forHeight(0.4)))),
                ),
              ],
            ),
          ),
        );
      });
}
