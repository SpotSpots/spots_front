import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'InfoScreen.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({Key? key}) : super(key: key);

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  List<DocumentReference> userFavorites = [];


  @override
  void initState() {
    print("init state no???");
    super.initState();
    // SavedPage에 들어올 때 초기 데이터 로드
    loadUserFavorites();
  }

  // 초기 데이터 로드
  Future<void> loadUserFavorites() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('user').doc(uid).get();
      if (snapshot.exists) {
        List<DocumentReference> favorites = List<DocumentReference>.from(snapshot['userFavorite']);
        setState(() {
          userFavorites = favorites;
        });
      }
    } catch (e) {
      print('Error loading favorites: $e');
    }
  }

  // 새로운 데이터를 로드하는 메서드
  Future<void> reloadUserData() async {
    // 데이터를 다시 불러오는 로직을 수행
    await loadUserFavorites();
    // setState를 호출하여 UI 갱신
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SavedPage()));
    return Scaffold(
      backgroundColor: const Color(0xffD5EAF7),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xffD5EAF7),
        title: Text('Saved', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
            icon: Icon(Icons.navigate_before, size: 28),
            onPressed: () {}
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.more_horiz),
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SavedPage()));
              }
          ),
        ],
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
      body: SingleChildScrollView(
        child: Column(
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
                                final cafeImage = favoriteData.get('image'); // 이미지 URL을 가져옴
                                print("checkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk" + cafeImage);

                                return buildCard('Cafe Spots', name, cafeImage, () {
                                  removeFromFavorites('cafe', name, cafeReference);
                                }, context);
                              }).toList();

                              return Column(
                                children: [
                                  SizedBox(
                                    height: 200,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.symmetric(horizontal: 16),
                                      // children: cafeCards,
                                      itemCount: cafeCards.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return Row(
                                          children: [
                                            cafeCards[index],
                                            SizedBox(width: 15), // 카드들 사이의 간격을 조절
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 20),
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
                                final cafeImage = favoriteData.get('image'); // 이미지 URL을 가져옴
                                print("checkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk" + cafeImage);
                                return buildCard('Study Spots', name, cafeImage, () {
                                  removeFromFavorites('studyspot', name, cafeReference);
                                }, context);
                              }).toList();

                              return Column(
                                children: [
                                  SizedBox(
                                    height: 200,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.symmetric(horizontal: 16),
                                      //children: studyCards,
                                      itemCount: studyCards.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return Row(
                                          children: [
                                            studyCards[index],
                                            SizedBox(width: 15), // 카드들 사이의 간격을 조절
                                          ],
                                        );
                                      },
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
      ),
    );
  }

  Future<void> removeFromFavorites(String category, String name, DocumentReference cafeReference) async {
    print('removeFromFavorites function called');
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      // Firestore에서 사용자 즐겨찾기 목록에서 카페 참조 제거
      await FirebaseFirestore.instance.collection('user').doc(uid).update({
        'userFavorite': FieldValue.arrayRemove([cafeReference]),
      });

      print('Firestore에서 카페가 즐겨찾기 목록에서 제거되었습니다.');

      // SavedPage로 돌아가기
      //Navigator.pop(context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SavedPage()));

    } catch (e) {
      print('즐겨찾기에서 제거 중 오류 발생: $e');
    }
  }


// Future<void> removeFromFavorites(String category, String name, DocumentReference cafeReference) async {
  //   print('removeFromFavorites function called');
  //   try {
  //     String uid = FirebaseAuth.instance.currentUser!.uid;
  //
  //     // Remove cafe reference from userFavorite list in Firestore
  //     await FirebaseFirestore.instance.collection('user').doc(uid).update({
  //       'userFavorite': FieldValue.arrayRemove([cafeReference]),
  //     });
  //
  //     print('Cafe removed from favorites in Firestore.');
  //
  //     // Update the UI using setState
  //     setState(() {
  //       // You may want to update the state here, for example, by removing the item from a list
  //       // userFavorites.cafeFavorites.remove(cafeReference);
  //     });
  //
  //   } catch (e) {
  //     print('Error removing from favorites: $e');
  //   }
  // }
}

Widget buildCard(String category, String name, String imageUrl, VoidCallback onTap, BuildContext context) {
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
                  // child: Image.asset(
                  //   'assets/cafe1.png',
                  //   fit: BoxFit.fitHeight,
                  // ),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => InfoScreen(name)));
                    },
                    child: Image( // 카페 이미지 : cafe/image
                        fit: BoxFit.cover,
                        image: NetworkImage(imageUrl),
                        width: 380
                    ),
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

// Future<void> removeFromFavorites(String category, String name, DocumentReference cafeReference) async {
//   print('removeFromFavorites function called');
//   try {
//     String uid = FirebaseAuth.instance.currentUser!.uid;
//
//     // Remove cafe reference from userFavorite list in Firestore
//     await FirebaseFirestore.instance.collection('user').doc(uid).update({
//       'userFavorite': FieldValue.arrayRemove([cafeReference]),
//     });
//
//     print('Cafe removed from favorites in Firestore.');
//
//     // TODO: You may want to update the UI here by triggering a rebuild or updating state.
//   } catch (e) {
//     print('Error removing from favorites: $e');
//   }
// }

