import 'package:flutter/cupertino.dart';
import 'package:instagram_flutter/screens/add_post.dart';
import 'package:instagram_flutter/screens/feed_screen.dart';

const webScreenSize = 600;

const homeScreenItems = [
  FeedScreen(),
  Text("search"),
  AddPostScreen(),
  Text("notif"),
  Text("profile"),
];
