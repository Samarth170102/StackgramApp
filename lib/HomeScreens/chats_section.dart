// ignore_for_file: must_be_immutable
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_8/CustomClasses/user_data_class.dart';
import 'package:flutter_application_8/HomeScreens/conversation_page.dart';
import 'package:flutter_application_8/Services/database_services.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets1.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets3.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets5.dart';
import 'package:flutter_application_8/main.dart';
import 'package:page_transition/page_transition.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatsSection extends StatefulWidget {
  bool darkMode;
  ChatsSection(this.darkMode);
  @override
  _ChatsSectionState createState() => _ChatsSectionState();
}

class _ChatsSectionState extends State<ChatsSection> {
  @override
  Widget build(BuildContext context) {
    VxState.watch(context, on: [PageChangeMutation]);
    return StreamBuilder<MainDataModel>(
        stream: Database().mainDocsSnap,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final main = snapshot.data;
            return StreamBuilder<UserDataModel>(
                stream: Database().docsSnap,
                builder: (context, snapshot2) {
                  if (snapshot2.hasData) {
                    final user = snapshot2.data;
                    List<dynamic> chatsList = user!.chatsList!;
                    Map<String, dynamic> chatsMap = user.chatsMap!;
                    return Scaffold(
                      backgroundColor: user.darkMode! ? Vx.black : Vx.white,
                      appBar:
                          appBarForAuth(toolbarHeight: 0, mode: user.darkMode),
                      body: Column(
                        children: [
                          rowforHeadingInEditProfile(
                              "Chats", user.darkMode!, context),
                          Container(
                            child: chatsList.isEmpty
                                ? Container(
                                    child: Text(
                                      "No conversations",
                                      style: TextStyle(
                                          fontSize: forHeight(27),
                                          color: user.darkMode!
                                              ? Vx.white
                                              : Vx.black,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ).centered().pOnly(bottom: forHeight(80))
                                : ListView.builder(
                                    itemCount: chatsList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      Map<String, dynamic> chatsMapUser =
                                          chatsMap[chatsList[index]];
                                      List<dynamic> chats =
                                          chatsMapUser["chats"];
                                      String lastMsg = "";
                                      if (chats.isNotEmpty) {
                                        if (chats[chats.length - 1]
                                                .runtimeType !=
                                            String) {
                                          Map<String, dynamic> chatMap =
                                              chats[chats.length - 1];
                                          lastMsg = chatMap["msg"];
                                        }
                                      }
                                      showDeleteDialog() {
                                        return showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Container(
                                              height: forHeight(125),
                                              width: forHeight(290),
                                              decoration: BoxDecoration(
                                                  color: user.darkMode!
                                                      ? Vx.hexToColor(user
                                                          .accentColor
                                                          .toString())
                                                      : Vx.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          forHeight(8))),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Clear the chat?",
                                                    style: TextStyle(
                                                        color: user.darkMode!
                                                            ? Vx.white
                                                            : Vx.black,
                                                        fontSize: forHeight(21),
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ).objectCenterLeft(),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          String
                                                              anotherUserUid =
                                                              chatsList[index];
                                                          chatsList.remove(
                                                              anotherUserUid);
                                                          chatsList.add(
                                                              anotherUserUid);
                                                          chats.clear();
                                                          Database()
                                                              .dataCollection
                                                              .doc(user.uid)
                                                              .update({
                                                            "chatsMap":
                                                                chatsMap,
                                                            "chatsList":
                                                                chatsList
                                                          });
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          "Yes",
                                                          style: TextStyle(
                                                              color: user
                                                                      .darkMode!
                                                                  ? Vx.white
                                                                  : Vx.hexToColor(user
                                                                      .accentColor
                                                                      .toString()),
                                                              fontSize:
                                                                  forHeight(22),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ),
                                                      ),
                                                      sizedBoxForWidth(20),
                                                      GestureDetector(
                                                        onTap: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child: Text(
                                                          "No",
                                                          style: TextStyle(
                                                              color: user
                                                                      .darkMode!
                                                                  ? Vx.white
                                                                  : Vx.black,
                                                              fontSize:
                                                                  forHeight(22),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ),
                                                      ),
                                                    ],
                                                  ).pOnly(right: forWidth(5)),
                                                ],
                                              ).pSymmetric(
                                                  v: forHeight(16),
                                                  h: forWidth(10)),
                                            ).centered();
                                          },
                                        );
                                      }

                                      return GestureDetector(
                                        onTap: () async {
                                          final doc = await (Database()
                                              .dataCollection
                                              .doc(chatsList[index])
                                              .get());
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                              child: ConversationPage(main!,
                                                  doc["uid"], user.darkMode!),
                                              type: PageTransitionType
                                                  .bottomToTop,
                                              duration:
                                                  Duration(milliseconds: 350),
                                              reverseDuration:
                                                  Duration(milliseconds: 250),
                                            ),
                                          );
                                        },
                                        onLongPress: () async {
                                          showDeleteDialog();
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          height: forHeight(120),
                                          child: Row(
                                            children: [
                                              Container(
                                                key: UniqueKey(),
                                                height: forHeight(100),
                                                width: forHeight(100),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      fit: BoxFit.fitWidth,
                                                      image: CachedNetworkImageProvider(
                                                          main!.profilePhotosMap![
                                                              chatsList[
                                                                  index]])),
                                                ),
                                              ),
                                              sizedBoxForWidth(11),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    main.usernamesMap![
                                                        chatsList[index]],
                                                    style: TextStyle(
                                                        color: user.darkMode!
                                                            ? Vx.white
                                                            : Vx.black,
                                                        fontSize: forHeight(20),
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Visibility(
                                                      visible: lastMsg != "",
                                                      child: sizedBoxForHeight(
                                                          20)),
                                                  Visibility(
                                                    visible: lastMsg != "",
                                                    child: Text(
                                                      lastMsg.length < 15
                                                          ? lastMsg
                                                          : lastMsg.substring(
                                                                  0, 14) +
                                                              "...",
                                                      style: TextStyle(
                                                        color: user.darkMode!
                                                            ? Vx.white
                                                            : Vx.black,
                                                        fontSize: forHeight(16),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ).pOnly(bottom: forHeight(10)),
                                            ],
                                          ).pOnly(left: forHeight(11)),
                                        ),
                                      );
                                    },
                                  ),
                          ).expand()
                        ],
                      ),
                    );
                  } else {
                    return loadingWidget(
                        accentColor: UserDataModel().accentColor,
                        mode: widget.darkMode);
                  }
                });
          } else {
            return loadingWidget(
                accentColor: UserDataModel().accentColor,
                mode: widget.darkMode);
          }
        });
  }
}
