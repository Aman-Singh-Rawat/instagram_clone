import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_flutter/models/post.dart';
import 'package:instagram_flutter/resources/cloudinary_service.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _instance = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uId,
    String userName,
    String profileImage,
  ) async {
    String result = "fail";
    try {
      String? postUrl = await uploadToCloudinary("posts", file, true);
      if (postUrl == null) {
        print("post Url null");
        return "fail";
      }

      String postId = const Uuid().v1();
      print(postUrl);
      Post post = Post(
        description: description,
        uId: uId,
        userName: userName,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: postUrl,
        profImage: profileImage,
        likes: [],
      );

      await _instance
          .collection("posts")
          .doc(postId)
          .set(post.toJson());

      result = "success";
    } catch (error) {
      return error.toString();
    }
    return result;
  }
}
