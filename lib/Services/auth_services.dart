import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_8/CustomClasses/user_auth_class.dart';

import 'database_services.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  UserAuthData? updateUserAuthData(User? user) {
    return user != null
        ? UserAuthData(
            user.uid.toString(),
            user.metadata.creationTime.toString(),
            user.metadata.lastSignInTime.toString())
        : null;
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    User? user = userCredential.user;
    await Database().updateUserData(uid: user!.uid, name: "");
    return updateUserAuthData(user);
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    UserCredential userCredential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    User? user = userCredential.user;
    return updateUserAuthData(user);
  }

  Future signOut() async {
    return await auth.signOut();
  }

  Stream<UserAuthData?> get userChanges {
    return auth.userChanges().map(updateUserAuthData);
  }

  Stream<UserAuthData?> get user {
    return auth.authStateChanges().map(updateUserAuthData);
  }
}
