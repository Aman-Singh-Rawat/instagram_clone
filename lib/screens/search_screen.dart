import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SearchScreen();
}

class _SearchScreen extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isShowUsers = false;
  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: _searchController,
          decoration: const InputDecoration(labelText: 'Search for a user'),
          onFieldSubmitted: (String _) {
            setState(() {
              _isShowUsers = true;
            });
          },
        ),
      ),
      body: _isShowUsers ? FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .where(
              'username',
              isGreaterThanOrEqualTo: _searchController.text,
            )
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: (snapshot.data!.docs.length),
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    (snapshot.data! as dynamic).docs[index]['photoUrl'],
                  ),
                ),
                title: Text((snapshot.data! as dynamic).docs[index]['username'],),
              );
            },
          );
        },
      ) : const Text('Posts'),
    );
  }
}
