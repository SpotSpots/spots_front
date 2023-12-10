import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({Key? key}) : super(key: key);

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {

  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE9E9E9),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent, // 고정 색상 지정
        // backgroundColor: Color(0xffE9E9E9),
        title: Text('Saved', style: TextStyle(fontWeight: FontWeight.bold),),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(20.0),
          child: Container(
            //padding: EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: Text(
              'See what\'s your favorite spots!',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),


      body: Column(
        children: [
          // 1. Cafe Spots
          const SizedBox(height: 20,),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Cafe Spots',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 10,),


          FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance.collection('user').doc(uid).collection('userFavorite').get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                // cafe만 가져오기
                final cafeCards = snapshot.data!.docs
                    .where((document) => document['category'] == 'cafe')
                    .map<Widget>((document) {
                  final name = document['name'];
                  return buildCard('Cafe Spots', name);
                }).toList();

                return Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        children: cafeCards,
                      ),
                    ),
                  ],
                );
              }
            },
          ),

          const SizedBox(height: 20,),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Study Spots',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 10,),
          FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance.collection('user').doc(uid).collection('userFavorite').get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                // Firebase에서 데이터 가져오기 성공
                final studyCards = snapshot.data!.docs
                    .where((document) => document['category'] == 'studyspot')
                    .map<Widget>((document) {
                  final name = document['name'];
                  return buildCard('Study Spots', name);
                }).toList();

                return Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        children: studyCards,
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

Widget buildCard(String category, String name) {
  return Container(
    width: 150,
    height: 210,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            Card(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
                width: 150,
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.asset(
                    'assets/cafe1.png',
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: IconButton(
                  icon: Icon(Icons.favorite, color: Colors.pink),
                  onPressed: () {
                    print('heart button clicked');
                    removeFromFavorites(category, name);
                  },
                  iconSize: 16,
                ),
              ),
            ),
          ],
        ),
        Text(
          name,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}

Future<void> removeFromFavorites(String category, String name) async {
  print('removeFromFavorites function called');
  try {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    print(uid);
    QuerySnapshot userFavoritesSnapshot = await FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .collection('userFavorite')
        .where('category', isEqualTo: category)
        .where('name', isEqualTo: name)
        .get();

    if (userFavoritesSnapshot.docs.isNotEmpty) {
      print("in delete");
      String docId = userFavoritesSnapshot.docs.first.id;
      print(docId);
      await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .collection('userFavorite')
          .doc(docId)
          .delete();
    } else {
      print('No document found for deletion');
    }
  } catch (e) {
    print('Error removing from favorites: $e');
  }
}
