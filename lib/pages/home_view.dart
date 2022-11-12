import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram/pages/notifications.dart';
import 'package:instagram/pages/post_add.dart';
import 'package:instagram/pages/profile.dart';
import 'package:instagram/pages/search.dart';
import 'package:instagram/providers/provider.dart';
import 'package:provider/provider.dart';

import 'home_home.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key, required this.uid}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
  final String uid;
  static const routeName = '/homepage';
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;

  List pages = [
    FeedScreen(),
    SearchScreen(),
    AddPostScreen(
      uid: FirebaseAuth.instance.currentUser!.uid,
    ),
    Notifications(),
    ProfileView(
      uid: FirebaseAuth.instance.currentUser!.uid,
    ),
  ];
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      // get post lENGTH
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {}
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: CupertinoTabBar(
          currentIndex: _currentIndex,
          backgroundColor: Colors.white,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: (_currentIndex == 0) ? Colors.black : Colors.grey,
              ),
              label: '',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                  color: (_currentIndex == 1) ? Colors.black : Colors.grey,
                ),
                label: '',
                backgroundColor: Colors.white),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.add_circle,
                  color: (_currentIndex == 2) ? Colors.black : Colors.grey,
                ),
                label: '',
                backgroundColor: Colors.white),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                color: (_currentIndex == 3) ? Colors.black : Colors.grey,
              ),
              label: '',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: (_currentIndex == 4) ? Colors.black : Colors.grey,
              ),
              label: '',
              backgroundColor: Colors.white,
            ),
          ],
          onTap: (index) => setState(() {
                _currentIndex = index;
              })),
    );
  }
}
