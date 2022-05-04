class UserFire {
  String? uid;
  String? favorites;
  String? ownReviews;
  bool isAdmin;

  UserFire({this.uid, this.favorites, this.ownReviews, this.isAdmin = false});

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'favorites': favorites,
        'ownReviews': ownReviews,
        'isAdmin': isAdmin
      };

  static UserFire fromJson(Map<String, dynamic>? json) => UserFire(
      uid: json!['uid'],
      favorites: json['favorites'],
      ownReviews: json['ownReviews'],
      isAdmin: json['isAdmin']);
}
