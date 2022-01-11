import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_8/HomePageSelector/homepage_selector.dart';
import 'package:flutter_application_8/HomeScreens/another_users_profile.dart';
import 'package:flutter_application_8/Services/database_services.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets3.dart';
import 'package:flutter_application_8/main.dart';
import 'package:page_transition/page_transition.dart';
import 'package:velocity_x/velocity_x.dart';

modalBottomSheetForLikedBy(Map<String, dynamic> likedBy, String postUserUid,
    bool darkMode, String accentColor, BuildContext context) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        final likedByList = likedBy.values.toList();
        final main = providerOfMainDataModel(context);
        Map<String, dynamic>? usernamesMap = main.usernamesMap;
        Map<String, dynamic>? profilePhotosMap = main.profilePhotosMap;
        return Container(
          color: darkMode ? Vx.black : Vx.white,
          child: ListView(
            children: [
              Container(
                child: Text(
                  "Liked By",
                  style: TextStyle(
                      color: darkMode ? Vx.white : Vx.black,
                      fontSize: 3.01537 * height,
                      fontWeight: FontWeight.w500),
                ).pOnly(top: 1.0052 * height),
              ).objectCenterLeft(),
              sizedBoxForHeight(24),
              likedByList.isEmpty
                  ? Container(
                      child: Text(
                        "No one has liked yet",
                        style: TextStyle(
                            fontSize: forHeight(25),
                            color: darkMode ? Vx.white : Vx.gray400),
                      ).centered(),
                    ).pOnly(top: forHeight(150))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: likedByList.length,
                      itemBuilder: (BuildContext context, int index) {
                        final userUid = likedByList[index]["uid"];
                        return GestureDetector(
                          onTap: () async {
                            if (postUserUid == userUid) {
                              indexOfPage = 3;
                              Navigator.popUntil(
                                  context, (route) => route.isFirst);
                              PageChangeMutation();
                            } else {
                              final doc = await (Database()
                                  .dataCollection
                                  .doc(userUid)
                                  .get());
                              final userDetails = doc;
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: AnotherUsersProfile(
                                      userDetails, accentColor, darkMode),
                                  type: PageTransitionType.bottomToTop,
                                  duration: Duration(milliseconds: 350),
                                  reverseDuration: Duration(milliseconds: 250),
                                ),
                              );
                            }
                          },
                          child: Container(
                            color: darkMode ? Vx.black : Vx.white,
                            child: Row(
                              children: [
                                Container(
                                  height: forHeight(75),
                                  width: forHeight(75),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.fitWidth,
                                        image: CachedNetworkImageProvider(
                                            profilePhotosMap![userUid])),
                                    shape: BoxShape.circle,
                                  ),
                                ).pOnly(right: forWidth(12)),
                                Text(
                                  usernamesMap![userUid],
                                  style: TextStyle(
                                      color: darkMode ? Vx.white : Vx.black,
                                      fontSize: forHeight(20),
                                      fontWeight: FontWeight.w400),
                                ).pOnly(bottom: forHeight(5))
                              ],
                            ).pOnly(left: forWidth(8)),
                          ).pOnly(bottom: forHeight(12)),
                        );
                      },
                    ),
            ],
          ).pOnly(
            left: 1.0052 * height,
            right: 1.0052 * height,
          ),
        );
      });
}
