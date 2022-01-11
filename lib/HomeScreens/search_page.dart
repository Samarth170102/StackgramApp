// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_8/CustomClasses/user_data_class.dart';
import 'package:flutter_application_8/HomeScreens/another_users_profile.dart';
import 'package:flutter_application_8/Services/database_services.dart';
import 'package:flutter_application_8/main.dart';
import 'package:page_transition/page_transition.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets3.dart';

class SearchPage extends StatefulWidget {
  UserDataModel user;
  MainDataModel main;
  SearchPage(this.main, this.user);
  @override
  _SearchPageState createState() => _SearchPageState();
}

bool isSearch = false;
String query = "";

class _SearchPageState extends State<SearchPage> {
  UserDataModel user = UserDataModel();
  MainDataModel main = MainDataModel();
  Map<String, dynamic>? usernames;
  Map<String, dynamic>? profilePhotosMap = {};
  List userUids = [];
  Map<String, dynamic> usersDetailsMap = {};
  List<String> usersnames = [];
  @override
  void initState() {
    super.initState();
    user = widget.user;
    main = widget.main;
    usernames = main.usernamesMap;
    profilePhotosMap = main.profilePhotosMap;
    userUids = main.usernamesMap!.keys.toList();
    usersDetailsMap = {};
    usersnames = [];
    for (var item in userUids) {
      String username = usernames![item];
      String profilePhotoUrl = profilePhotosMap![item];
      usersDetailsMap[username] = {
        "username": username,
        "profilePhotoUrl": profilePhotoUrl,
        "uid": item
      };
    }
    usersnames = usersDetailsMap.keys.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          user.darkMode! ? Vx.gray500.withOpacity(0.50) : Vx.gray100,
      appBar: AppBar(
        leading: Text(
          "Search",
          style: TextStyle(
              fontSize: forHeight(25),
              fontWeight: FontWeight.w500,
              color: user.darkMode! ? Vx.white : Vx.black),
        ).pOnly(left: forWidth(8)).centered(),
        actions: [
          IconButton(
            onPressed: () {
              isSearch = !isSearch;
              query = "";
              setState(() {});
            },
            icon: ImageIcon(
              AssetImage(
                  "assets/images/bottombar/${isSearch ? "cancel" : "search"}.png"),
              color: user.darkMode! ? Vx.white : Vx.black,
            ),
          )
        ],
        leadingWidth: forHeight(100),
        backgroundColor: user.darkMode! ? Vx.black : Vx.white,
        elevation: isSearch ? 0 : forHeight(1.5),
        toolbarHeight: forHeight(55),
      ),
      body: Column(
        children: [
          Visibility(
            visible: isSearch,
            child: Material(
              elevation: forHeight(1.5),
              child: Container(
                color: user.darkMode! ? Vx.black : Vx.white,
                height: forHeight(50),
                width: width * 100,
                child: TextFormField(
                  initialValue: query,
                  onChanged: (value) {
                    query = value;
                    setState(() {});
                  },
                  maxLength: 20,
                  autofocus: true,
                  cursorColor: Vx.hexToColor(user.accentColor.toString()),
                  style: TextStyle(
                      fontSize: forHeight(20),
                      color: user.darkMode! ? Vx.white : Vx.black),
                  decoration: InputDecoration(
                      border: InputBorder.none, counterText: ""),
                ).pSymmetric(h: forWidth(20)),
              ),
            ),
          ),
          sizedBoxForHeight(8),
          Container(
            width: width * 100,
            child: ListView.builder(
              itemCount: usersnames.length,
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic> userBox =
                    usersDetailsMap[usersnames[index]];
                return Visibility(
                  visible: userBox["username"]
                          .toString()
                          .toLowerCase()
                          .contains(query.toLowerCase()) &&
                      userBox["uid"] != user.uid,
                  child: GestureDetector(
                    onTap: () async {
                      final doc = await (Database()
                          .dataCollection
                          .doc(userBox["uid"])
                          .get());
                      final userDetails = doc;
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
                                      userBox["profilePhotoUrl"],
                                    ))),
                          ),
                          sizedBoxForWidth(11),
                          Text(
                            userBox["username"],
                            style: TextStyle(
                                color: user.darkMode! ? Vx.white : Vx.black,
                                fontSize: forHeight(19),
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ).pOnly(left: forHeight(11)),
                    ),
                  ),
                );
              },
            ),
          ).expand(),
        ],
      ),
    );
  }
}
