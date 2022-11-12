import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart'
    as view;

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: SvgPicture.asset(
          'assets/inst_logo.svg',
          height: 32,
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.messenger_outline,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('posts')
                .orderBy('datePublished')
                .get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return view.AlignedGridView.count(
                    crossAxisCount: 1,
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) => Container(
                          child: Column(
                            children: [
                              ListTile(title: Text('')),
                              Image.network(
                                (snapshot.data! as dynamic).docs[index]
                                    ['postUrl'],
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                        ));
              }
            },
          );
        },
      ),
    );
  }
}
