import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_8/Services/auth_services.dart';
import 'package:flutter_application_8/Services/database_services.dart';
import 'package:flutter_application_8/ScreenWrappers/main_wrapper.dart';
import 'package:flutter_application_8/CustomClasses/user_auth_class.dart';
import 'package:flutter_application_8/CustomClasses/user_data_class.dart';

void main(List<String> args) async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(VxState(store: MyStore(), child: MaterialApp(home: MyApp())));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyStore extends VxStore {
  bool authStateChange = true;
  bool pageChange = true;
  bool obsecurePasswordChange = true;
}

class AuthMutation extends VxMutation<MyStore> {
  @override
  perform() {
    store.authStateChange = !store.authStateChange;
  }
}

class PageChangeMutation extends VxMutation<MyStore> {
  @override
  perform() {
    store.pageChange = !store.pageChange;
  }
}

class ObsecurePassworldMutation extends VxMutation<MyStore> {
  @override
  perform() {
    store.obsecurePasswordChange = !store.obsecurePasswordChange;
  }
}

MyStore store = VxState.store;

double height = 0;
double width = 0;
bool obsecurePassword = true;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height / 100;
    width = MediaQuery.of(context).size.width / 100;
    obsecurePassword = true;
    return StreamProvider<MainDataModel>.value(
      initialData: MainDataModel(),
      value: Database().mainDocsSnap,
      child: StreamProvider<UserAuthData?>.value(
        initialData: null,
        value: AuthService().user,
        child: MaterialApp(
          theme: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          home: Wrapper(),
        ),
      ),
    );
  }
}
