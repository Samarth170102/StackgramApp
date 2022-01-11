import 'package:flutter/material.dart';
import 'package:flutter_application_8/CustomClasses/user_auth_class.dart';
import 'package:flutter_application_8/CustomClasses/user_data_class.dart';
import 'package:flutter_application_8/ScreenWrappers/authscreen_wrapper.dart';
import 'package:flutter_application_8/Services/database_services.dart';
import 'package:provider/provider.dart';

import 'homescreen_wrapper.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserAuthData?>(context);
    if (user == null) {
      return ChangeAuthScreen();
    }
    return StreamProvider<UserDataModel>.value(
      initialData: UserDataModel(),
      value: Database().docsSnap,
      child: ChangeHomeScreen(),
    );
  }
}
