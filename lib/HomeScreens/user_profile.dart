import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_8/CustomClasses/user_data_class.dart';
import 'package:flutter_application_8/HomeScreens/image_page.dart';
import 'package:flutter_application_8/UserProfilePages/user_menu.dart';
import 'package:flutter_application_8/HomeScreens/image_preview.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets3.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets4.dart';
import 'package:flutter_application_8/main.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class UserProfile extends StatefulWidget {
  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool readMore = false;
  bool maxLine = false;
  @override
  Widget build(BuildContext context) {
    VxState.watch(context, on: [PageChangeMutation]);
    final user = Provider.of<UserDataModel>(context);
    final main = providerOfMainDataModel(context);
    Map<String, dynamic>? posts = user.posts;
    String bio = user.bio.toString().trim();
    final span = TextSpan(text: bio);
    final tp =
        TextPainter(text: span, maxLines: 3, textDirection: TextDirection.ltr);
    tp.layout(maxWidth: (width * 78));
    bool lengthCheck = tp.didExceedMaxLines;
    return Container(
      height: height * 100,
      child: ListView(
        physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "My Profile",
                style: TextStyle(
                    fontSize: forHeight(23),
                    fontWeight: FontWeight.w500,
                    color: user.darkMode! ? Vx.white : Vx.black),
              ),
              GestureDetector(
                onTap: () => userMenuModalBottomSheet(context,user.darkMode!),
                child: Container(
                  height: forHeight(25),
                  child: Image.asset("assets/images/bottombar/setting.png",
                      color: user.darkMode! ? Vx.white : Vx.black),
                ),
              )
            ],
          ).pOnly(left: forWidth(8), right: forWidth(10)),
          sizedBoxForHeight(16),
          Container(
            height: forHeight(120),
            child: Row(
              children: [
                Container(
                  key: UniqueKey(),
                  height: forHeight(105),
                  width: forHeight(105),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          image: CachedNetworkImageProvider(
                            user.profilePhotoUrl.toString(),
                          ))),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.username.toString().trim(),
                      style: TextStyle(
                          color: user.darkMode! ? Vx.white : Vx.black,
                          fontSize: forHeight(18),
                          fontWeight: FontWeight.w500),
                    ),
                    sizedBoxForHeight(17),
                    Text(
                      user.name.toString(),
                      style: TextStyle(
                          color: user.darkMode! ? Vx.white : Vx.black,
                          fontSize: forHeight(16)),
                    ).pOnly(bottom: forHeight(9))
                  ],
                ).pOnly(left: forHeight(10))
              ],
            ).pOnly(left: forHeight(11)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Bio",
                style: TextStyle(
                    fontSize: forHeight(18),
                    color: user.darkMode! ? Vx.white : Vx.gray400),
              ),
              Text(
                bio,
                maxLines: maxLine ? 300 : 3,
                style: TextStyle(
                  color: user.darkMode! ? Vx.white : Vx.black,
                  fontSize: forHeight(15),
                ),
              ).pOnly(
                  top: forHeight(3),
                  right: forWidth(1),
                  bottom: lengthCheck ? 0 : forHeight(12)),
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
                    readMore ? "Read less" : "Read more..",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: forHeight(16),
                        color: Vx.hexToColor(user.accentColor.toString())),
                  ).objectCenterRight().pOnly(right: forWidth(5)),
                ),
              ),
            ],
          ).pOnly(left: forHeight(12), top: forHeight(15)),
          Divider(color: user.darkMode! ? Vx.white : Vx.gray200),
          Text(
            "Posts",
            style: TextStyle(
                fontSize: forHeight(23),
                fontWeight: FontWeight.w500,
                color: user.darkMode! ? Vx.white : Vx.black),
          ).objectCenterLeft().pOnly(left: forWidth(10), bottom: forHeight(10)),
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: forWidth(2.5),
                crossAxisSpacing: forWidth(2.5)),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: posts!.length,
            itemBuilder: (context, index) {
              int lenght = posts.length;
              String imgName = "image${lenght - index}_${user.uid}";
              Map<String, dynamic>? post = posts[imgName];
              String imgUrl = post!["imgUrl"];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  PageTransition(
                    child: ImagePage(imgName, post, main.stackPosts),
                    type: PageTransitionType.bottomToTop,
                    duration: Duration(milliseconds: 250),
                    reverseDuration: Duration(milliseconds: 250),
                  ),
                ),
                child: RawGestureDetector(
                  gestures: longPressNavigator("push", context,
                      page: ImagePreview(imgUrl)),
                  child: Container(
                    child: CachedNetworkImage(
                      key: UniqueKey(),
                      imageUrl: imgUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
