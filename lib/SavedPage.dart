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
        backgroundColor: Colors.transparent,
        title: Text('Saved', style: TextStyle(fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(20.0),
          child: Container(
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
          FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('user').doc(uid).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final userDocument = snapshot.data;
                if (userDocument != null) {
                  final userFavoriteReferences = List<DocumentReference>.from(userDocument['userFavorite']);

                  if (userFavoriteReferences.isNotEmpty) {
                    final userFavoriteDataFutures = userFavoriteReferences.map((reference) => reference.get());
                    return FutureBuilder<List<DocumentSnapshot>>(
                      future: Future.wait(userFavoriteDataFutures),
                      builder: (context, userFavoriteSnapshots) {
                        if (userFavoriteSnapshots.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (userFavoriteSnapshots.hasError) {
                          return Text('Error: ${userFavoriteSnapshots.error}');
                        } else {
                          final userFavoriteData = userFavoriteSnapshots.data;
                          if (userFavoriteData != null) {
                            final cafeCards = userFavoriteData
                                .where((favoriteData) => favoriteData['category'] == 'cafe')
                                .map<Widget>((favoriteData) {
                              final name = favoriteData['name'];
                              final cafeReference = favoriteData.reference;

                              return buildCard('Cafe Spots', name, () {
                                removeFromFavorites('cafe', name, cafeReference);
                              });
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
                        }
                        return Container(); // 사용자 문서 또는 userFavorite이 없을 경우 빈 컨테이너 반환
                      },
                    );
                  }
                }

                return Container(); // 사용자 문서 또는 userFavorite이 없을 경우 빈 컨테이너 반환
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
          FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('user').doc(uid).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final userDocument = snapshot.data;
                if (userDocument != null) {
                  final userFavoriteReferences = List<DocumentReference>.from(userDocument['userFavorite']);

                  if (userFavoriteReferences.isNotEmpty) {
                    final userFavoriteDataFutures = userFavoriteReferences.map((reference) => reference.get());
                    return FutureBuilder<List<DocumentSnapshot>>(
                      future: Future.wait(userFavoriteDataFutures),
                      builder: (context, userFavoriteSnapshots) {
                        if (userFavoriteSnapshots.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (userFavoriteSnapshots.hasError) {
                          return Text('Error: ${userFavoriteSnapshots.error}');
                        } else {
                          final userFavoriteData = userFavoriteSnapshots.data;
                          if (userFavoriteData != null) {
                            final studyCards = userFavoriteData
                                .where((favoriteData) => favoriteData['category'] == 'studyspot')
                                .map<Widget>((favoriteData) {
                              final name = favoriteData['name'];

                              final cafeReference = favoriteData.reference;
                              return buildCard('Study Spots', name, () {
                                removeFromFavorites('studyspot', name, cafeReference);
                              });
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
                        }
                        return Container(); // 사용자 문서 또는 userFavorite이 없을 경우 빈 컨테이너 반환
                      },
                    );
                  }
                }

                return Container(); // 사용자 문서 또는 userFavorite이 없을 경우 빈 컨테이너 반환
              }
            },
          ),
        ],
      ),
    );
  }
}

Widget buildCard(String category, String name, VoidCallback onTap) {
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
                  onPressed: onTap,
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

Future<void> removeFromFavorites(String category, String name, DocumentReference cafeReference) async {
  print('removeFromFavorites function called');
  try {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    // Remove cafe reference from userFavorite list in Firestore
    await FirebaseFirestore.instance.collection('user').doc(uid).update({
      'userFavorite': FieldValue.arrayRemove([cafeReference]),
    });

    print('Cafe removed from favorites in Firestore.');

    // TODO: You may want to update the UI here by triggering a rebuild or updating state.
  } catch (e) {
    print('Error removing from favorites: $e');
  }
}