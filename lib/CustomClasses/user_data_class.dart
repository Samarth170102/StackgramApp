class UserDataModel {
  int? index;
  String? uid;
  String? bio;
  String? name;
  String? email;
  bool? darkMode;
  List? chatsList;
  String? username;
  String? accentColor;
  String? lastUsername;
  String? profilePhotoUrl;
  Map<String, dynamic>? posts;
  Map<String, dynamic>? chatsMap;
  UserDataModel({
    this.bio,
    this.uid,
    this.name,
    this.posts,
    this.index,
    this.email,
    this.username,
    this.chatsMap,
    this.darkMode,
    this.chatsList,
    this.accentColor,
    this.lastUsername,
    this.profilePhotoUrl,
  });
}

class MainDataModel {
  List<String>? usernames;
  Map<String, dynamic>? usernamesMap;
  Map<String, dynamic>? profilePhotosMap;
  List<Map<String, dynamic>>? stackPosts;
  Map<String, dynamic>? emailVerificaton;
  MainDataModel(
      {this.usernames,
      this.stackPosts,
      this.usernamesMap,
      this.emailVerificaton,
      this.profilePhotosMap});
}
