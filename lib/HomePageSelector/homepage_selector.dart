import 'package:flutter/material.dart';
import 'package:flutter_application_8/CustomClasses/user_data_class.dart';
import 'package:flutter_application_8/HomeScreens/search_page.dart';
import 'package:flutter_application_8/HomeScreens/upload_post.dart';
import 'package:flutter_application_8/HomeScreens/homepage.dart';
import 'package:flutter_application_8/HomeScreens/user_profile.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets1.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets2.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets3.dart';
import 'package:flutter_application_8/main.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class HomePageSelector extends StatefulWidget {
  @override
  State<HomePageSelector> createState() => HomePageSelectorState();
}

int indexOfPage = 0;

class HomePageSelectorState extends State<HomePageSelector>
    with AutomaticKeepAliveClientMixin<HomePageSelector> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    VxState.watch(context, on: [PageChangeMutation]);
    final user = Provider.of<UserDataModel>(context);
    final main = providerOfMainDataModel(context);
    List<Widget> homescreens = [
      HomePage(),
      SearchPage(main, user),
      UploadPost(),
      UserProfile()
    ];
    bool darkMode = false;
    if (user.darkMode == true) {
      darkMode = true;
    }
    return Scaffold(
      backgroundColor: darkMode ? Vx.black : Vx.white,
      appBar: appBarForAuth(
        toolbarHeight: forHeight(0.00001),
        mode: darkMode,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: indexOfPage,
        items: [
          bottomNavigationBarItem("Home", "home", 0, indexOfPage, darkMode,
              user.accentColor.toString()),
          bottomNavigationBarItem("Search", "search", 1, indexOfPage, darkMode,
              user.accentColor.toString()),
          bottomNavigationBarItem("Upload", "upload", 2, indexOfPage, darkMode,
              user.accentColor.toString()),
          bottomNavigationBarItem("User", "user", 3, indexOfPage, darkMode,
              user.accentColor.toString()),
        ],
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: darkMode ? Vx.black : Vx.white,
        showUnselectedLabels: false,
        selectedItemColor: Vx.hexToColor(user.accentColor.toString()),
        unselectedItemColor: darkMode ? Vx.white : Vx.gray500,
        selectedFontSize: height * 1.5,
        onTap: (value) {
          setState(() {
            indexOfPage = value;
          });
        },
      ),
      body: homescreens[indexOfPage],
    );
  }
}
