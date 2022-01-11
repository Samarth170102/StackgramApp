import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_8/CustomClasses/user_data_class.dart';
import 'package:flutter_application_8/Services/auth_services.dart';
import 'package:provider/provider.dart';

class Database {
  CollectionReference dataCollection =
      FirebaseFirestore.instance.collection("TestApp4");
  Future updateUserData({String? uid, String? name}) async {
    return await dataCollection.doc(uid).set({
      "uid": uid,
      "index": 1,
      "name": name,
      "posts": {},
      "username": name,
      "lastUsername": name,
      "bio": "Hey, I am Using Stackgram💖",
      "email": AuthService().auth.currentUser!.email,
      "profilePhotoUrl": "https://firebasestorage.googleapis.com/"
          "v0/b/testapp4-53638.appspot.com/o/profilePhotos%2FdefaultPr"
          "ofilePhoto.png?alt=media&token=0ce0af4f-15c8-496c-aab6-46f428ac9180",
      "darkMode": false,
      "accentColor": "#4773f1",
      "chatsMap": {},
      "chatsList": []
    });
  }

  Future updateSingleDocData(
      String key, dynamic value, BuildContext context) async {
    final user = Provider.of<UserDataModel>(context, listen: false);
    return await Database().dataCollection.doc(user.uid).update({key: value});
  }

  Future updateMainDocData(
      String key, dynamic value, BuildContext context) async {
    return await Database().dataCollection.doc("main").update({key: value});
  }

  UserDataModel userData(DocumentSnapshot snapshot) {
    return UserDataModel(
      uid: snapshot["uid"],
      bio: snapshot["bio"],
      name: snapshot["name"],
      index: snapshot["index"],
      email: snapshot["email"],
      username: snapshot["username"],
      darkMode: snapshot["darkMode"],
      accentColor: snapshot["accentColor"],
      posts: Map.castFrom(snapshot["posts"]),
      lastUsername: snapshot["lastUsername"],
      chatsMap: Map.castFrom(snapshot["chatsMap"]),
      profilePhotoUrl: snapshot["profilePhotoUrl"],
      chatsList: List.castFrom(snapshot["chatsList"]),
    );
  }

  Stream<UserDataModel> get docsSnap {
    return dataCollection
        .doc(AuthService().auth.currentUser!.uid)
        .snapshots()
        .map(userData);
  }

  MainDataModel mainData(DocumentSnapshot snapshot) {
    return MainDataModel(
      usernames: List.castFrom(
        snapshot["usernames"],
      ),
      stackPosts: List.castFrom(snapshot["stackPosts"]),
      emailVerificaton: Map.castFrom(snapshot["emailVerification"]),
      usernamesMap: Map.castFrom(snapshot["usernamesMap"]),
      profilePhotosMap: Map.castFrom(snapshot["profilePhotosMap"]),
    );
  }

  Stream<MainDataModel> get mainDocsSnap {
    return dataCollection.doc("main").snapshots().map(mainData);
  }
}
