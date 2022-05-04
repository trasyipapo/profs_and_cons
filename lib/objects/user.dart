class UserFire {
  String? uid;
  String? favorites;
  bool isAdmin;

  UserFire({this.uid, this.favorites, this.isAdmin = false});

  Map<String, dynamic> toJson() =>
      {'uid': uid, 'favorites': favorites, 'isAdmin': isAdmin};

  static UserFire fromJson(Map<String, dynamic>? json) => UserFire(
      uid: json!['uid'],
      favorites: json['favorites'],
      isAdmin: json['isAdmin']);
}
