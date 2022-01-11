// ignore_for_file: must_be_immutable
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_8/CustomClasses/user_data_class.dart';
import 'package:flutter_application_8/HomePageSelector/homepage_selector.dart';
import 'package:flutter_application_8/HomeScreens/another_users_profile.dart';
import 'package:flutter_application_8/Services/database_services.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/comments.dart';
import 'package:flutter_application_8/HomeScreens/image_preview.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/liked_by.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets1.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets3.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets4.dart';
import 'package:flutter_application_8/main.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class HomePageBox extends StatefulWidget {
  int? length;
  int? index;
  Map<String, dynamic>? postDetails;
  HomePageBox({this.postDetails, this.length, this.index});
  @override
  _HomePageBoxState createState() => _HomePageBoxState();
}

class _HomePageBoxState extends State<HomePageBox> {
  int likes = 0;
  String caption = "";
  String userUid = "";
  String profileName = "";
  List<dynamic> comments = [];
  List<dynamic> likedList = [];
  Map<String, dynamic> post = {};
  Map<String, dynamic> posts = {};
  Map<String, dynamic> likedBy = {};
  dynamic userDetails = DocumentSnapshot<Object?>;
  String profilePhotoUrl = "https://upload.wikimedia.org/wikipedia/"
      "commons/8/89/HD_transparent_picture.png";
  getDetails(String uid) async {
    final doc = await (Database().dataCollection.doc(uid).get());
    userDetails = doc;
    post = doc.get("posts")[widget.postDetails?["postImgName"]];
    posts = doc.get("posts");
    likes = post["likes"];
    userUid = doc.get("uid");
    likedBy = post["likedBy"];
    caption = post["caption"];
    comments = post["comments"];
    likedList = post["likedList"];
    profileName = doc.get("username");
    profilePhotoUrl = doc.get("profilePhotoUrl");
  }

  bool maxLine = false;
  bool readMore = false;
  @override
  Widget build(BuildContext context) {
    VxState.watch(context, on: [PageChangeMutation]);
    getDetails(widget.postDetails?["uid"]);
    int length = widget.length!.toInt();
    int index = widget.index!.toInt();
    profileName + " ";
    final span = TextSpan(text: profileName + " " + caption);
    final tp =
        TextPainter(text: span, maxLines: 2, textDirection: TextDirection.ltr);
    tp.layout(maxWidth: width * 80);
    bool lengthgetDetails = tp.didExceedMaxLines;
    final user = Provider.of<UserDataModel>(context);
    return FutureBuilder(
      future: Database().dataCollection.doc(widget.postDetails?["uid"]).get(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            width: width * 100,
            decoration: BoxDecoration(
                border: Border(
              bottom: BorderSide(
                  color: length == index + 1
                      ? Colors.transparent
                      : user.darkMode!
                          ? Vx.gray50.withOpacity(0.6)
                          : Vx.gray100),
            )),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    if (user.uid == userUid) {
                      indexOfPage = 3;
                      PageChangeMutation();
                    } else {
                      Navigator.push(
                        context,
                        PageTransition(
                          child: AnotherUsersProfile(userDetails,
                              user.accentColor.toString(), user.darkMode!),
                          type: PageTransitionType.bottomToTop,
                          duration: Duration(milliseconds: 350),
                          reverseDuration: Duration(milliseconds: 250),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: width * 100,
                    height: forHeight(60),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: user.darkMode!
                                    ? Vx.gray300.withOpacity(0.6)
                                    : Vx.gray100))),
                    child: Row(
                      children: [
                        Container(
                          height: forHeight(52),
                          width: forHeight(52),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fitWidth,
                                image: CachedNetworkImageProvider(
                                    profilePhotoUrl)),
                            shape: BoxShape.circle,
                          ),
                        ).pOnly(right: forWidth(9)),
                        Text(
                          profileName,
                          style: TextStyle(
                              color: user.darkMode! ? Vx.white : Vx.black,
                              fontSize: forHeight(16.5),
                              fontWeight: FontWeight.w600),
                        ).pOnly(bottom: forHeight(5))
                      ],
                    ).pOnly(left: forWidth(8)),
                  ),
                ),
                GestureDetector(
                  onDoubleTap: () async {
                    if (!likedList.contains(user.uid)) {
                      VxToast.show(context,
                          msg: "Liked!",
                          showTime: 1500,
                          textSize: forHeight(17),
                          bgColor: user.darkMode!
                              ? Vx.hexToColor(user.accentColor.toString())
                              : Vx.black);
                      likes++;
                      likedList.add(user.uid);
                      likedBy[user.uid.toString()] = {
                        "uid": user.uid,
                      };
                      post["likes"] = likes;
                      post["likedBy"] = likedBy;
                      post["likedList"] = likedList;
                      posts[widget.postDetails?["postImgName"]] = post;
                      Database()
                          .dataCollection
                          .doc(userUid)
                          .update({"posts": posts});
                      setState(() {});
                    }
                  },
                  child: Container(
                    width: width * 100,
                    constraints: BoxConstraints(
                      maxHeight: forHeight(350),
                    ),
                    child: RawGestureDetector(
                      gestures: longPressNavigator("push", context,
                          page: ImagePreview(post["imgUrl"] ??
                              "https://upload.wikimedia.org/wikipedia"
                                  "/commons/8/89/HD_transparent_picture.png")),
                      child: CachedNetworkImage(
                        key: UniqueKey(),
                        imageUrl: post["imgUrl"] ??
                            "https://upload.wikimedia.org/wikipedia"
                                "/commons/8/89/HD_transparent_picture.png",
                      ),
                    ),
                  ),
                ),
                Container(
                  width: width * 100,
                  constraints: BoxConstraints(minHeight: forHeight(90)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  if (likedList.contains(user.uid)) {
                                    likes--;
                                    likedList.remove(user.uid);
                                    likedBy.remove(user.uid);
                                    post["likes"] = likes;
                                    post["likedBy"] = likedBy;
                                    post["likedList"] = likedList;
                                  } else {
                                    likes++;
                                    likedList.add(user.uid);
                                    likedBy[user.uid.toString()] = {
                                      "uid": user.uid,
                                    };
                                    post["likes"] = likes;
                                    post["likedBy"] = likedBy;
                                    post["likedList"] = likedList;
                                  }
                                  posts[widget.postDetails?["postImgName"]] =
                                      post;
                                  Database()
                                      .dataCollection
                                      .doc(userUid)
                                      .update({"posts": posts});
                                  setState(() {});
                                },
                                child: Container(
                                  height: forHeight(35),
                                  width: forHeight(35),
                                  child: Image.asset(
                                      likedList.contains(user.uid)
                                          ? "assets/images/bottombar/like-fill.png"
                                          : "assets/images/bottombar/like.png",
                                      color: user.darkMode!
                                          ? likedList.contains(user.uid)
                                              ? null
                                              : Vx.white
                                          : null),
                                ),
                              ),
                              SizedBox(
                                width: forWidth(13),
                              ),
                              GestureDetector(
                                onTap: () => modalBottomSheetForComments(
                                    comments,
                                    user.uid.toString(),
                                    userUid,
                                    widget.postDetails?["postImgName"],
                                    posts,
                                    post,
                                    user.accentColor.toString(),
                                    user.darkMode!,
                                    context),
                                child: Container(
                                  height: forHeight(35),
                                  width: forHeight(35),
                                  child: Image.asset(
                                    "assets/images/bottombar/comments.png",
                                    color: user.darkMode! ? Vx.white : Vx.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => modalBottomSheetForLikedBy(
                                likedBy,
                                user.uid.toString(),
                                user.darkMode!,
                                user.accentColor.toString(),
                                context),
                            child: Text(
                              "Liked by",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: forHeight(17),
                                  color: Vx.hexToColor(
                                      user.accentColor.toString())),
                            ),
                          )
                        ],
                      ).pOnly(
                          top: forHeight(7),
                          left: forWidth(12),
                          right: forWidth(8)),
                      Text(
                        "$likes Like${likes < 2 ? "" : "s"}",
                        style: TextStyle(
                            color: user.darkMode! ? Vx.white : Vx.black,
                            fontSize: forHeight(19),
                            fontWeight: FontWeight.w500),
                      ).objectCenterLeft().pOnly(
                          left: forWidth(16.5),
                          top: forHeight(10),
                          bottom: forHeight(2)),
                      Container(
                        constraints: BoxConstraints(maxHeight: double.infinity),
                        child: RichText(
                          maxLines: maxLine ? 300 : 2,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: profileName + " ",
                                  style: TextStyle(
                                      fontSize: forHeight(17),
                                      color:
                                          user.darkMode! ? Vx.white : Vx.black,
                                      fontWeight: FontWeight.w500)),
                              TextSpan(
                                  text: caption,
                                  style: TextStyle(
                                    fontSize: forHeight(17),
                                    color: user.darkMode! ? Vx.white : Vx.black,
                                  ))
                            ],
                          ),
                        ).objectBottomLeft().pOnly(
                            right: forWidth(1),
                            left: forWidth(16.5),
                            bottom: lengthgetDetails ? 0 : forHeight(18)),
                      ),
                      Visibility(
                        visible: lengthgetDetails,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              readMore = !readMore;
                              maxLine = !maxLine;
                            });
                          },
                          child: Text(
                            readMore ? "Read less" : "Read more..",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: forHeight(16),
                                color:
                                    Vx.hexToColor(user.accentColor.toString())),
                          ).objectCenterRight().pOnly(right: forWidth(5)),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  post["uploadDate"] ?? "",
                  style: TextStyle(
                      fontSize: forHeight(15),
                      color: user.darkMode! ? Vx.gray300 : Vx.gray400),
                )
                    .objectCenterLeft()
                    .pOnly(left: forWidth(8), bottom: forHeight(5)),
              ],
            ),
          );
        }
        return SizedBox(
            height: height * 70,
            child: loadingWidget(
                accentColor: user.accentColor, mode: user.darkMode));
      },
    );
  }
}
