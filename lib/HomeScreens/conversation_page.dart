// ignore_for_file: must_be_immutable
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_8/CustomClasses/user_data_class.dart';
import 'package:flutter_application_8/HomeScreens/another_users_profile.dart';
import 'package:flutter_application_8/HomeScreens/homepage.dart';
import 'package:flutter_application_8/Services/database_services.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets1.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets3.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets5.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets6.dart';
import 'package:flutter_application_8/main.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:velocity_x/velocity_x.dart';

class ConversationPage extends StatefulWidget {
  MainDataModel main;
  String anotherUserUid;
  bool darkMode;
  ConversationPage(this.main, this.anotherUserUid, this.darkMode);
  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  ScrollController scrollController = ScrollController();
  TextEditingController textController = TextEditingController();
  FocusNode focusNode = FocusNode();
  String msgToSend = "";

  @override
  Widget build(BuildContext context) {
    final main = widget.main;
    return StreamBuilder<DocumentSnapshot<Object?>>(
      stream: Database().dataCollection.doc(widget.anotherUserUid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final anotherUser = snapshot.data;
          Map<String, dynamic> anotherUserChatMaps =
              anotherUser!.get("chatsMap");
          return StreamBuilder<UserDataModel>(
              stream: Database().docsSnap,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Timer(
                    Duration(milliseconds: 1),
                    () {
                      if (scrollController.hasClients) {
                        scrollController
                            .jumpTo(scrollController.position.maxScrollExtent);
                        setState(() {});
                      }
                    },
                  );
                  final user = snapshot.data;
                  Map<String, dynamic> chatsMap = user!.chatsMap!;
                  Map<String, dynamic> chatsMapUser =
                      chatsMap[widget.anotherUserUid];
                  Map<String, dynamic> anotherChatsMapUser =
                      anotherUserChatMaps[user.uid];
                  List<dynamic> userChats = chatsMapUser["chats"];
                  List<dynamic> anotherUserChats = anotherChatsMapUser["chats"];
                  String date = ("${DateFormat('dd').format(DateTime.now())} "
                      "${months[int.parse(DateFormat('MM').format(DateTime.now()).toString())]} "
                      "${DateFormat('yyy').format(DateTime.now())}");
                  if (userChats.isNotEmpty) {
                    if (userChats[userChats.length - 1].runtimeType == String) {
                      userChats.removeAt(userChats.length - 1);
                      Database()
                          .dataCollection
                          .doc(user.uid)
                          .update({"chatsMap": chatsMap});
                    }
                  }
                  doComment() async {
                    if (msgToSend != "") {
                      if (!userChats.contains(date)) {
                        userChats.add(date);
                      }
                      if (!anotherUserChats.contains(date)) {
                        anotherUserChats.add(date);
                      }
                      if (user.chatsList!.indexOf(widget.anotherUserUid) != 0) {
                        user.chatsList!.remove(widget.anotherUserUid);
                        user.chatsList!.insert(0, widget.anotherUserUid);
                        await Database()
                            .dataCollection
                            .doc(user.uid.toString())
                            .update({"chatsList": user.chatsList});
                      }
                      textController.clear();
                      userChats.add({
                        "userUid": user.uid,
                        "msg": msgToSend,
                        "msgTime": DateFormat('hh:mm a [ss]')
                            .format(DateTime.now())
                            .toString()
                      });
                      anotherUserChats.add({
                        "userUid": user.uid,
                        "msg": msgToSend,
                        "msgTime": DateFormat('hh:mm a [ss]')
                            .format(DateTime.now())
                            .toString()
                      });
                      await Database()
                          .dataCollection
                          .doc(user.uid.toString())
                          .update({"chatsMap": chatsMap});
                      await Database()
                          .dataCollection
                          .doc(widget.anotherUserUid)
                          .update({"chatsMap": anotherUserChatMaps});
                    } else {
                      VxToast.show(context,
                          msg: "Cannot send an empty message",
                          textSize: forHeight(15),
                          position: VxToastPosition.center,
                          showTime: 2000,
                          bgColor: user.darkMode!
                              ? Vx.hexToColor(user.accentColor.toString())
                              : Vx.black);
                      PageChangeMutation();
                    }
                    focusNode.requestFocus();
                  }

                  GestureDetector gestureDetectorForProfileVisit() {
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        PageTransition(
                          child: AnotherUsersProfile(anotherUser,
                              user.accentColor.toString(), user.darkMode!),
                          type: PageTransitionType.bottomToTop,
                          duration: Duration(milliseconds: 350),
                          reverseDuration: Duration(milliseconds: 250),
                        ),
                      ),
                      child: Container(
                        height: 75,
                        width: width * 100,
                        child: Row(
                          children: [
                            Container(
                              key: UniqueKey(),
                              height: forHeight(75),
                              width: forHeight(75),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      fit: BoxFit.fitWidth,
                                      image: CachedNetworkImageProvider(
                                          main.profilePhotosMap![
                                              widget.anotherUserUid]))),
                            ),
                            sizedBoxForWidth(11),
                            Text(
                              main.usernamesMap![widget.anotherUserUid],
                              style: TextStyle(
                                  color: user.darkMode! ? Vx.white : Vx.black,
                                  fontSize: forHeight(17.5),
                                  fontWeight: FontWeight.w500),
                            ).pOnly(bottom: forHeight(6)),
                          ],
                        ).pOnly(left: forHeight(15)),
                      ),
                    );
                  }

                  GestureDetector gestureDetectorForDeleteMsg(int index) {
                    return GestureDetector(
                      onLongPress: () => showDialog(
                        context: context,
                        builder: (context) {
                          FocusScope.of(context).unfocus();
                          String userUidInUserChats = "";
                          try {
                            userUidInUserChats = userChats[index]["userUid"];
                          } catch (e) {
                            null;
                          }
                          return Container(
                            height: userUidInUserChats != user.uid
                                ? forHeight(60)
                                : forHeight(115),
                            width: forHeight(290),
                            decoration: BoxDecoration(
                                color: user.darkMode!
                                    ? Vx.hexToColor(user.accentColor.toString())
                                    : Vx.white,
                                borderRadius:
                                    BorderRadius.circular(forHeight(8))),
                            child: Material(
                              color: Colors.transparent,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      userChats.removeAt(index);
                                      Database()
                                          .dataCollection
                                          .doc(user.uid)
                                          .update({"chatsMap": chatsMap});
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                      height: forHeight(60),
                                      child: Text(
                                        "Delete for me",
                                        style: TextStyle(
                                            color: user.darkMode!
                                                ? Vx.white
                                                : Vx.black,
                                            fontSize: forHeight(21),
                                            fontWeight: FontWeight.w600),
                                      ).objectCenterLeft(),
                                    ),
                                  ),
                                  Visibility(
                                    visible: userUidInUserChats == user.uid,
                                    child: GestureDetector(
                                      onTap: () {
                                        for (var i = 0;
                                            i < anotherUserChats.length;
                                            i++) {
                                          if (anotherUserChats[i].runtimeType !=
                                              String) {
                                            if (anotherUserChats[i]["msg"] ==
                                                userChats[index]["msg"]) {
                                              if (anotherUserChats[i]
                                                      ["msgTime"] ==
                                                  userChats[index]["msgTime"]) {
                                                anotherUserChats.removeAt(i);
                                                Database()
                                                    .dataCollection
                                                    .doc(widget.anotherUserUid)
                                                    .update({
                                                  "chatsMap":
                                                      anotherUserChatMaps
                                                });
                                              }
                                            }
                                          }
                                        }
                                        userChats.removeAt(index);
                                        Database()
                                            .dataCollection
                                            .doc(user.uid)
                                            .update({"chatsMap": chatsMap});
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        height: forHeight(55),
                                        color: Colors.transparent,
                                        child: Text(
                                          "Delete for both",
                                          style: TextStyle(
                                              color: user.darkMode!
                                                  ? Vx.white
                                                  : Vx.black,
                                              fontSize: forHeight(21),
                                              fontWeight: FontWeight.w600),
                                        ).objectCenterLeft(),
                                      ),
                                    ),
                                  ),
                                ],
                              ).pSymmetric(h: forWidth(10)),
                            ),
                          ).objectCenter();
                        },
                      ),
                      child: chatBox(
                              user.username.toString(),
                              userChats[index],
                              user.darkMode!,
                              user.accentColor.toString(),
                              main.usernamesMap)
                          .pOnly(top: index == 0 ? forHeight(10) : 0),
                    );
                  }

                  return GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: Scaffold(
                          backgroundColor: user.darkMode! ? Vx.black : Vx.white,
                          appBar: appBarForAuth(
                              toolbarHeight: 0, mode: user.darkMode),
                          body: Column(children: [
                            rowforHeadingInEditProfile(
                                "Conversation", user.darkMode!, context),
                            gestureDetectorForProfileVisit(),
                            sizedBoxForHeight(10),
                            Column(children: [
                              Container(
                                child: ListView.builder(
                                  controller: scrollController,
                                  shrinkWrap: true,
                                  itemCount: userChats.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      child: userChats[index].runtimeType !=
                                              String
                                          ? gestureDetectorForDeleteMsg(index)
                                          : Container(
                                              height: 35,
                                              width: 35,
                                              child: Text(
                                                userChats[index],
                                                style: TextStyle(
                                                    color: user.darkMode!
                                                        ? Vx.white
                                                        : Vx.gray400,
                                                    fontSize: forHeight(16)),
                                              ).centered(),
                                            ).pOnly(
                                              top: index != 0
                                                  ? forHeight(25)
                                                  : forHeight(10),
                                            ),
                                    );
                                  },
                                ).pOnly(
                                  left: 1.0052 * height,
                                  right: 1.0052 * height,
                                ),
                                decoration: BoxDecoration(
                                    border: Border(
                                        top: BorderSide(
                                            color: Vx.gray400,
                                            width: forHeight(0.4)),
                                        bottom: BorderSide(
                                            color: Vx.gray400,
                                            width: forHeight(0.4)))),
                              ).expand(),
                              Row(children: [
                                Container(
                                  width: forWidth(318),
                                  color: user.darkMode! ? Vx.black : Vx.white,
                                  child: TextFormField(
                                    focusNode: focusNode,
                                    controller: textController,
                                    onFieldSubmitted: (value) async {
                                      await doComment();
                                    },
                                    onChanged: (value) {
                                      msgToSend = value;
                                    },
                                    style: TextStyle(
                                        fontSize: forHeight(17),
                                        color: user.darkMode!
                                            ? Vx.white
                                            : Vx.black),
                                    cursorColor: Vx.hexToColor(
                                        user.accentColor.toString()),
                                    decoration: InputDecoration(
                                      hintText: "Enter Your Comment..",
                                      hintStyle: TextStyle(
                                          fontSize: forHeight(18),
                                          color: user.darkMode!
                                              ? Vx.white
                                              : Vx.gray500),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ).pOnly(left: forHeight(20)),
                                Container(
                                    width: forWidth(35),
                                    height: forHeight(35),
                                    child: GestureDetector(
                                      onTap: () async {
                                        await doComment();
                                      },
                                      child: Image.asset(
                                        "assets/images/bottombar/send.png",
                                        color: Vx.hexToColor(user.accentColor!),
                                      ).objectCenterRight(),
                                    ))
                              ])
                            ]).expand(),
                          ])));
                } else {
                  return loadingWidget(
                      accentColor: UserDataModel().accentColor,
                      mode: widget.darkMode);
                }
              });
        } else {
          return loadingWidget(
              accentColor: UserDataModel().accentColor, mode: widget.darkMode);
        }
      },
    );
  }
}
