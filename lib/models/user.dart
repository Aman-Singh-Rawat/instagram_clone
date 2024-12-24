class User {
  final String email;
  final String uId;
  final String photoUrl;
  final String userName;
  final String bio;
  final List followers;
  final List following;

  const User({
    required this.email,
    required this.uId,
    required this.photoUrl,
    required this.userName,
    required this.bio,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() => {
    "username": userName,
    "uid": uId,
    "email": email,
    "photoUrl": photoUrl,
    "bio": bio,
    "followers": followers,
    "following": following,
  };
}
