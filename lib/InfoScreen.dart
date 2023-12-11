import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class InfoScreen extends StatefulWidget {
  final String cafeInfo;
  const InfoScreen(this.cafeInfo);

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  bool _isFavorite = false;

  Future<void> addToUserFavorites(String cafeName) async {
    print("addToUserFavorites");
    try {
      // 현재 사용자 인증 상태 확인
      User? user = FirebaseAuth.instance.currentUser;
      print(user?.uid); // helloworld1로 로그인 함
      print(cafeName);

      if (user != null) {
        String uid = user.uid;

        // 1. cafeInfo로 cafe collection을 검색
        QuerySnapshot cafeQuery = await FirebaseFirestore.instance
            .collection('cafe')
            .where('name', isEqualTo: cafeName)
            .get();

        if (cafeQuery.docs.isNotEmpty) {
          // 2. uid로 user collection을 검색
          DocumentReference userReference =
          FirebaseFirestore.instance.collection('user').doc(uid);

          // 3. uid 검색 결과 나온 document의 하위 필드인 userFavorite에 cafeInfo로 검색한 cafe를 reference 하도록 설정
          DocumentReference cafeReference = cafeQuery.docs.first.reference;

          // Get the current user document
          DocumentSnapshot userSnapshot = await userReference.get();

          // Initialize userFavorite field as an empty list if it doesn't exist
          List<dynamic> userFavorites = userSnapshot['userFavorite'] ?? [];

          // Check if cafeReference already exists in userFavorites
          if (userFavorites.contains(cafeReference)) {
            // Remove cafe reference from userFavorite list
            userFavorites.remove(cafeReference);
          } else {
            // Add cafe reference to userFavorite list
            userFavorites.add(cafeReference);
          }

          // Update userFavorite field in the user document
          await userReference.update({'userFavorite': userFavorites});

          // Toggle the favorite state
          setState(() {
            _isFavorite = userFavorites.contains(cafeReference);
          });

          print('Cafe favorite status updated successfully.');
        }
      }
    } catch (error) {
      print('Error adding cafe to user favorites: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                // 큰 이미지
                Image.asset('assets/cafe1.png', width: double.infinity, height: 200, fit: BoxFit.cover),

                // 상단 버튼들
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      iconSize: 18,
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: IconButton(
                          icon: Icon(
                            _isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: _isFavorite ? Colors.red : Colors.grey,
                          ),
                          onPressed: () async {
                            addToUserFavorites(widget.cafeInfo);
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.more_horiz, color: Colors.grey),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // 상점 정보 상단 섹션
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        this.widget.cafeInfo,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.yellow),
                          Text('4.2'),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.place, color: Colors.black), // GPS 모양 이모티콘
                      SizedBox(width: 8), // 이모티콘과 텍스트 사이의 간격 조절
                      Text('2.4 mi // Irvine'),
                    ],
                  ),
                  Text('Open until 7pm // Cafe, Coffee & Tea'),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(Icons.warning, color: Colors.yellow),
                      Text('Limited Seating'),
                    ],
                  ),
                ],
              ),
            ),

            // Divider
            Divider(),

            // Recently Checked In 섹션
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Recently Checked In',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),

                  // Profile 리스트
                  Row(
                    children: [
                      buildProfile('alexiamae', 'now'),
                      buildProfile('liamthom..', '1 hr ago'),
                      buildProfile('emilygrace', '4 hr ago'),
                      buildProfile('lexijade', '1 day ago'),
                      buildProfile('eljjaaaa', '5 day ago'),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Check In 버튼
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Check In'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(100, 70),
                    ),
                  )
,
                ],
              ),
            ),

            // Divider
            Divider(),

            // Amenities 섹션
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Amenities'),
                  // Amenities 리스트
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfile(String name, String time) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black),
              image: DecorationImage(
                image: AssetImage('assets/cafe1.png'), // 프로필 이미지 경로로 수정
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 4),
          Text(name),
          Text(time, style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
