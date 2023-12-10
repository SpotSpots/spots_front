import 'package:flutter/material.dart';


class InfoScreen extends StatelessWidget {
  final String cafeInfo;
  const InfoScreen(this.cafeInfo); // this.cafeInfo : cafe's name (String type)

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
                          icon: Icon(Icons.favorite_border, color: Colors.red),
                          onPressed: () {},
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
                        this.cafeInfo,
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
