// ignore_for_file: must_be_immutable
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_8/CustomClasses/user_data_class.dart';
import 'package:flutter_application_8/HomeScreens/conversation_page.dart';
import 'package:flutter_application_8/HomeScreens/image_page.dart';
import 'package:flutter_application_8/Services/database_services.dart';
import 'package:flutter_application_8/HomeScreens/image_preview.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets1.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets3.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets4.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets5.dart';
import 'package:flutter_application_8/main.dart';
import 'package:page_transition/page_transition.dart';
import 'package:velocity_x/velocity_x.dart';

class AnotherUsersProfile extends StatefulWidget {
  dynamic userDetails;
  bool darkMode;
  String accentColor;
  AnotherUsersProfile(this.userDetails, this.accentColor, this.darkMode);
  @override
  _AnotherUsersProfileState createState() => _AnotherUsersProfileState();
}

class _AnotherUsersProfileState extends State<AnotherUsersProfile> {
  bool readMore = false;
  bool maxLine = false;
  @override
  Widget build(BuildContext context) {
    final userDetails = widget.userDetails;
    Map<String, dynamic>? posts = userDetails["posts"];
    String bio = userDetails["bio"].toString().trim();
    final span = TextSpan(text: bio);
    final tp =
        TextPainter(text: span, maxLines: 3, textDirection: TextDirection.ltr);
    tp.layout(maxWidth: (width * 78));
    bool lengthCheck = tp.didExceedMaxLines;
    return StreamBuilder<MainDataModel>(
        stream: Database().mainDocsSnap,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            bool darkMode = widget.darkMode;
            final main = snapshot.data;
            return StreamBuilder<UserDataModel>(
                stream: Database().docsSnap,
                builder: (context, snapshot2) {
                  if (snapshot2.hasData) {
                    final user = snapshot2.data;
                    return Scaffold(
                        backgroundColor: widget.darkMode ? Vx.black : Vx.white,
                        appBar: appBarForAuth(
                            toolbarHeight: 0, mode: widget.darkMode),
                        body: Container(
                            height: height * 100,
                            child: ListView(
                                physics: AlwaysScrollableScrollPhysics(
                                    parent: BouncingScrollPhysics()),
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      rowforHeadingInEditProfile("User Profile",
                                          widget.darkMode, context),
                                      GestureDetector(
                                        onTap: () async {
                                          if (!user!.chatsList!
                                              .contains(userDetails["uid"])) {
                                            VxToast.show(context,
                                                msg: "Creating conversation...",
                                                showTime: 1500,
                                                textSize: forHeight(15),
                                                bgColor: darkMode
                                                    ? Vx.hexToColor(user
                                                        .accentColor
                                                        .toString())
                                                    : Vx.black);
                                            final anotherUser = await Database()
                                                .dataCollection
                                                .doc(userDetails["uid"])
                                                .get();
                                            user.chatsList!
                                                .add(userDetails["uid"]);
                                            user.chatsMap![userDetails["uid"]] =
                                                {
                                              "chats": [],
                                            };
                                            await Database()
                                                .dataCollection
                                                .doc(user.uid)
                                                .update({
                                              "chatsList": user.chatsList,
                                              "chatsMap": user.chatsMap
                                            });
                                            List<dynamic> anotherUserChatsList =
                                                anotherUser.get("chatsList");
                                            Map<String, dynamic>
                                                anotherUserChatsMap =
                                                anotherUser.get("chatsMap");
                                            anotherUserChatsList
                                                .add(user.uid.toString());
                                            anotherUserChatsMap[
                                                user.uid.toString()] = {
                                              "chats": [],
                                            };
                                            await Database()
                                                .dataCollection
                                                .doc(userDetails["uid"])
                                                .update({
                                              "chatsMap": anotherUserChatsMap,
                                              "chatsList": anotherUserChatsList
                                            });
                                          }
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                              child: ConversationPage(main!,
                                                  userDetails["uid"], darkMode),
                                              type: PageTransitionType
                                                  .bottomToTop,
                                              duration:
                                                  Duration(milliseconds: 350),
                                              reverseDuration:
                                                  Duration(milliseconds: 250),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          height: forHeight(38),
                                          child: Image.asset(
                                            "assets/images/bottombar/do_chat.png",
                                            color:
                                                darkMode ? Vx.white : Vx.black,
                                          ),
                                        ).pOnly(
                                            right: forWidth(7),
                                            bottom: forHeight(4)),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: forHeight(120),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: forHeight(105),
                                          width: forHeight(105),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  fit: BoxFit.fitWidth,
                                                  image:
                                                      CachedNetworkImageProvider(
                                                    userDetails[
                                                            "profilePhotoUrl"]
                                                        .toString(),
                                                  ))),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              userDetails["username"]
                                                  .toString(),
                                              style: TextStyle(
                                                  color: darkMode
                                                      ? Vx.white
                                                      : Vx.black,
                                                  fontSize: forHeight(18),
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            sizedBoxForHeight(17),
                                            Text(
                                              userDetails["name"]
                                                  .toString()
                                                  .trim(),
                                              style: TextStyle(
                                                  color: darkMode
                                                      ? Vx.white
                                                      : Vx.black,
                                                  fontSize: forHeight(16)),
                                            ).pOnly(bottom: forHeight(9))
                                          ],
                                        ).pOnly(left: forHeight(10))
                                      ],
                                    ).pOnly(left: forHeight(11)),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Bio",
                                        style: TextStyle(
                                            fontSize: forHeight(18),
                                            color: darkMode
                                                ? Vx.white
                                                : Vx.gray400),
                                      ),
                                      Text(
                                        bio,
                                        maxLines: maxLine ? 300 : 3,
                                        style: TextStyle(
                                          color: darkMode ? Vx.white : Vx.black,
                                          fontSize: forHeight(15),
                                        ),
                                      ).pOnly(
                                          top: forHeight(3),
                                          right: forWidth(1)),
                                      Visibility(
                                        visible: lengthCheck,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              readMore = !readMore;
                                              maxLine = !maxLine;
                                            });
                                          },
                                          child: Text(
                                            readMore
                                                ? "Read less"
                                                : "Read more..",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: forHeight(16),
                                                color: Vx.hexToColor(
                                                    userDetails["accentColor"]
                                                        .toString())),
                                          )
                                              .objectCenterRight()
                                              .pOnly(right: forWidth(5)),
                                        ),
                                      ),
                                    ],
                                  ).pOnly(
                                      left: forHeight(12), top: forHeight(15)),
                                  Divider(
                                      color: darkMode ? Vx.white : Vx.gray200),
                                  Text(
                                    "Posts",
                                    style: TextStyle(
                                        fontSize: forHeight(23),
                                        fontWeight: FontWeight.w500,
                                        color: darkMode ? Vx.white : Vx.black),
                                  ).objectCenterLeft().pOnly(
                                      left: forWidth(10),
                                      bottom: forHeight(10)),
                                  GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              mainAxisSpacing: forWidth(2.5),
                                              crossAxisSpacing: forWidth(2.5)),
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: posts!.length,
                                      itemBuilder: (context, index) {
                                        int lenght = posts.length;
                                        String imgName =
                                            "image${lenght - index}_${userDetails["uid"]}";
                                        Map<String, dynamic>? post =
                                            posts[imgName];
                                        String imgUrl = post!["imgUrl"];
                                        return GestureDetector(
                                            onTap: () => Navigator.push(
                                                  context,
                                                  PageTransition(
                                                    child: ImagePage(imgName,
                                                        post, main!.stackPosts),
                                                    type: PageTransitionType
                                                        .bottomToTop,
                                                    duration: Duration(
                                                        milliseconds: 350),
                                                    reverseDuration: Duration(
                                                        milliseconds: 250),
                                                  ),
                                                ),
                                            child: RawGestureDetector(
                                                gestures: longPressNavigator(
                                                    "push", context,
                                                    page: ImagePreview(imgUrl)),
                                                child: Container(
                                                    child: CachedNetworkImage(
                                                  key: UniqueKey(),
                                                  imageUrl: imgUrl,
                                                  fit: BoxFit.cover,
                                                ))));
                                      })
                                ])));
                  } else {
                    return loadingWidget(
                        accentColor: widget.accentColor, mode: widget.darkMode);
                  }
                });
          } else {
            return loadingWidget(
                accentColor: widget.accentColor, mode: widget.darkMode);
          }
        });
  }
}
