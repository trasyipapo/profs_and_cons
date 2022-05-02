class UserFire {
  String? uid;
  String? favorites;

  UserFire({this.uid, this.favorites});

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'favorites': favorites,
      };

  static UserFire fromJson(Map<String, dynamic> json) =>
      UserFire(uid: json['uid'], favorites: json['favorites']);
}
