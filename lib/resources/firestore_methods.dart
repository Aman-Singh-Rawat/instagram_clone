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

      await _instance.collection("posts").doc(postId).set(post.toJson());

      result = "success";
    } catch (error) {
      return error.toString();
    }
    return result;
  }

  Future<void> likePost(postId, String uId, List likes) async {
    try {
      if (likes.contains(uId)) {
        await _instance.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uId]),
        });
      } else {
        await _instance.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uId]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> postComment({
    required String uId,
    required String text,
    required String postId,
    required String name,
    required String profilePic,
  }) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _instance
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          "name": name,
          "uid": uId,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
      } else {
        print("Text is empty");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _instance.collection('posts').doc(postId).delete();
    } catch(err) {
      print(err.toString());
    }
  }
}
