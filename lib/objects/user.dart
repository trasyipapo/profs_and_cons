class UserFire {
  String? uid;
  String? favorites;
  String? ownReviews;

  UserFire({this.uid, this.favorites, this.ownReviews});

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'favorites': favorites,
        'ownReviews': ownReviews,
      };

  static UserFire fromJson(Map<String, dynamic>? json) => UserFire(
      uid: json!['uid'],
      favorites: json['favorites'],
      ownReviews: json['ownReviews']);
}
