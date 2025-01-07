import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:instagram_flutter/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.uId,
  });

  final String uId;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLength = 0;
  int followers = 0;
  int following = 0;
  bool _isFollowing = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    try {
      var userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uId)
          .get();

      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      postLength = postSnap.docs.length;
      followers = userSnapshot.data()?[followers]?.length ?? 0;
      following = userSnapshot.data()?[following]?.length ?? 0;
      _isFollowing = userSnapshot
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);

      setState(() {
        print(userSnapshot.data());
        userData = userSnapshot.data()!;
      });
    } catch (e) {
      showSnackBar(e.toString(), context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? const Center(
      child: CircularProgressIndicator(),
    ) : Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(userData['username']),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(
                        userData['photoUrl'],
                      ),
                      radius: 40,
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildStatColumn(postLength, 'posts'),
                              buildStatColumn(followers, 'followers'),
                              buildStatColumn(following, 'following'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FirebaseAuth.instance.currentUser!.uid == widget.uId? FollowButton(
                                textColor: primaryColor,
                                borderColor: Colors.grey,
                                backgroundColor: mobileBackgroundColor,
                                text: 'Edit Profile',
                                function: () {},
                              ): _isFollowing ? FollowButton(
                                textColor: Colors.black,
                                borderColor: Colors.grey,
                                backgroundColor: Colors.white,
                                text: 'Unfollow',
                                function: () {},
                              ) : FollowButton(
                                textColor: Colors.white,
                                borderColor: Colors.blue,
                                backgroundColor: Colors.blue,
                                text: 'Follow',
                                function: () {},
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    userData['username'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 1),
                  child: Text(
                    userData['bio'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 2),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        )
      ],
    );
  }
}
