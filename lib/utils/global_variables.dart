import 'package:flutter/cupertino.dart';
import 'package:instagram_flutter/screens/add_post.dart';
import 'package:instagram_flutter/screens/feed_screen.dart';

import '../screens/search_screen.dart';

const webScreenSize = 600;

const homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Text("notif"),
  Text("profile"),
];
