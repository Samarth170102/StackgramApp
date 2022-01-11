import 'package:flutter/material.dart';
import 'package:flutter_application_8/CustomClasses/user_auth_class.dart';
import 'package:flutter_application_8/CustomClasses/user_data_class.dart';
import 'package:flutter_application_8/HomePageSelector/homepage_selector.dart';
import 'package:flutter_application_8/HomeScreens/welcome_user.dart';
import 'package:flutter_application_8/WidgetsAndFunctions/widgets1.dart';
import 'package:provider/provider.dart';

class ChangeHomeScreen extends StatelessWidget {
  const ChangeHomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserAuthData?>(context);
    final userModal = Provider.of<UserDataModel>(context);
    dynamic creationTime = user!.creationTime;
    dynamic lastSignInTime = user.lastSignInTime;
    return creationTime == lastSignInTime && userModal.username == ""
        ? userModal.username == null
            ? loadingWidget()
            : WelcomeUser()
        : userModal.username == null
            ? loadingWidget()
            : HomePageSelector();
  }
}
