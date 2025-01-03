import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_flutter/resources/cloudinary_service.dart';

import 'package:instagram_flutter/models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseStore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snapshot =
        await _firebaseStore.collection("users").doc(currentUser.uid).get();

    return model.User.fromSnap(snapshot);
  }

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
      if (email.isEmpty ||
          password.isEmpty ||
          username.isEmpty ||
          bio.isEmpty) {
        return "All fields must be filled";
      }

      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String? photoUrl = await uploadToCloudinary("profilePics", file, false);
      if (photoUrl == null) {
        return "Fail";
      }

      model.User user = model.User(
        userName: username,
        uId: credential.user!.uid,
        email: email,
        bio: bio,
        followers: [],
        following: [],
        photoUrl: photoUrl,
      );
      await _firebaseStore.collection("users").doc(credential.user!.uid).set(
            user.toJson(),
          );

      result = "success";
    } catch (error) {
      result = error.toString();
    }
    return result;
  }

  Future<String> loginScreen(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "success";
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific exceptions
      if (e.code == 'user-not-found') {
        return 'No user found with this email.';
      } else if (e.code == 'wrong-password') {
        return 'Incorrect password.';
      } else {
        return e.message ?? 'An error occurred.';
      }
    } catch (e) {
      // Handle other exceptions
      return 'Error: $e';
    }
  }
}
