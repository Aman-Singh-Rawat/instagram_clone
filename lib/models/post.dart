import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_flutter/models/user.dart';

class Post {
  Post({
    required this.description,
    required this.uId,
    required this.userName,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
    required this.likes,
  });

  final String description;
  final String uId;
  final String userName;
  final String postId;
  final datePublished;
  final String postUrl;
  final String profImage;
  final likes;

  Map<String, dynamic> toJson() =>
      {
        "description": description,
        "uid": uId,
        "username": userName,
        "postId": postId,
        "datePublished": datePublished,
        "postUrl": postUrl,
        "profImage": profImage,
        "likes": likes,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      userName: snapshot["username"],
      uId: snapshot["uid"],
      description: snapshot["description"],
      postId: snapshot["postId"],
      datePublished: snapshot["datePublished"],
      profImage: snapshot["profImage"],
      likes: snapshot["likes"],
      postUrl: snapshot["postUrl"],
    );
  }
}
