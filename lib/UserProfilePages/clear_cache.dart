import 'package:flutter/material.dart';
import 'package:flutter_application_8/CustomClasses/user_data_class.dart';
import 'package:flutter_application_8/Services/database_services.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets1.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets3.dart';
import 'package:flutter_application_8/main.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

modalBottomSheetForClearCache(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return StreamBuilder<UserDataModel>(
          stream: Database().docsSnap,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final user = snapshot.data;
              return Container(
                color: user!.darkMode! ? Vx.black : Vx.white,
                height: forHeight(270),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        "Clear Cache",
                        style: TextStyle(
                            color: user.darkMode! ? Vx.white : Vx.black,
                            fontSize: 3.01537 * height,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    sizedBoxForHeight(45),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Only Image Cache",
                          style: TextStyle(
                              color: user.darkMode! ? Vx.white : Vx.black,
                              fontSize: forHeight(22)),
                        ),
                        GestureDetector(
                          onTap: () {
                            imageCache!.clear();
                            imageCache!.clearLiveImages();
                            PageChangeMutation();
                            VxToast.show(context,
                                msg: "Image Cache Cleaned",
                                position: VxToastPosition.center,
                                bgColor:
                                    Vx.hexToColor(user.accentColor.toString()));
                          },
                          child: Container(
                            height: forHeight(60),
                            width: forHeight(60),
                            decoration: BoxDecoration(
                                color:
                                    Vx.hexToColor(user.accentColor.toString()),
                                borderRadius:
                                    BorderRadius.circular(forHeight(8))),
                            child: Image.asset(
                              "assets/images/bottombar/clear.png",
                              color: Vx.white,
                            ).pSymmetric(h: forWidth(7)),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "App Cache",
                          style: TextStyle(
                              color: user.darkMode! ? Vx.white : Vx.black,
                              fontSize: forHeight(22)),
                        ),
                        GestureDetector(
                          onTap: () {
                            DefaultCacheManager().emptyCache();
                            imageCache!.clear();
                            imageCache!.clearLiveImages();
                            PageChangeMutation();
                            VxToast.show(context,
                                msg: "App Cache Cleaned",
                                position: VxToastPosition.center,
                                bgColor:
                                    Vx.hexToColor(user.accentColor.toString()));
                          },
                          child: Container(
                            height: forHeight(60),
                            width: forHeight(60),
                            decoration: BoxDecoration(
                                color:
                                    Vx.hexToColor(user.accentColor.toString()),
                                borderRadius:
                                    BorderRadius.circular(forHeight(8))),
                            child: Image.asset(
                              "assets/images/bottombar/clear.png",
                              color: Vx.white,
                            ).pSymmetric(h: forWidth(7)),
                          ),
                        )
                      ],
                    ).pOnly(top: forHeight(20))
                  ],
                ).pOnly(
                    left: 1.0052 * height,
                    right: 2.0052 * height,
                    top: 1.0052 * height),
              );
            } else {
              return loadingWidget(mode: UserDataModel().darkMode);
            }
          });
    },
  );
}
