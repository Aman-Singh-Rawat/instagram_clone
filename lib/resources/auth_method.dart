import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_flutter/resources/cloudinary_service.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseStore = FirebaseFirestore.instance;

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
    //required Uint8List file,
  }) async {
    String result = "Some error occurred";
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          bio.isNotEmpty) {
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String? photoUrl = await uploadToCloudinary("profilePics", file, false);
        if(photoUrl == null) {
          return "Fail";
        }

        await _firebaseStore.collection("users").doc(credential.user!.uid).set({
          "username": username,
          "uid": credential.user!.uid,
          "email": email,
          "bio": bio,
          "followers": [],
          "following": [],
          "photoUrl": photoUrl,
        });

        result = "Success";
      }
    } catch (error) {
      result = error.toString();
    }
    return result;
  }
}
