import 'package:flutter/material.dart';
import 'package:flutter_application_8/HomeScreens/chats_section.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets3.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/homepage_box.dart';
import 'package:flutter_application_8/main.dart';
import 'package:page_transition/page_transition.dart';
import 'package:velocity_x/velocity_x.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

List<String> months = [
  "temp",
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  " August",
  "September",
  "October",
  "November",
  "December"
];

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    VxState.watch(context, on: [PageChangeMutation]);
    final main = providerOfMainDataModel(context);
    final user = providerOfUserDataModel(context);
    int length = 0;
    if (main.stackPosts != null) {
      length = main.stackPosts!.length;
    }
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: forWidth(133),
              child: Image.asset(
                "assets/images/logo/app_logo.png",
                color: user.darkMode! ? Vx.white : Vx.black,
              ),
            ).objectCenterLeft().pOnly(bottom: forHeight(5), left: forWidth(5)),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                PageTransition(
                  child: ChatsSection(user.darkMode!),
                  type: PageTransitionType.bottomToTop,
                  duration: Duration(milliseconds: 350),
                  reverseDuration: Duration(milliseconds: 250),
                ),
              ),
              child: Container(
                height: forHeight(37),
                child: Image.asset(
                  "assets/images/bottombar/chats_section.png",
                  color: user.darkMode! ? Vx.white : Vx.black,
                ),
              ).pOnly(right: forWidth(7)),
            )
          ],
        ),
        ListView.builder(
          key: PageStorageKey("homepage"),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics:
              AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          itemCount: length,
          itemBuilder: (context, index) {
            return HomePageBox(
              postDetails: main.stackPosts?[length - index - 1],
              length: length,
              index: index,
            ).centered();
          },
        ).expand()
      ],
    ).wFull(context);
  }
}
