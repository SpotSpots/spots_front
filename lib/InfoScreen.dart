import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // AppBar 설정 (뒤로가기, 하트, 설정 버튼)
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Image(
                image: AssetImage(
                    'assets/cafe1.png'
                ),
                width: 380
            ),
            // 상점 정보 상단 섹션
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'KRISP Fresh Living',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.yellow),
                      Text('4.2'),
                    ],
                  ),
                  Text('2.4 mi // Irvine'),
                  Text('Open until 7pm // Cafe, Coffee & Tea'),
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


                  // Profile 리스트
                  Row(
                    children: [
                      buildProfile('Name 1', 'now'),
                      buildProfile('Name 2', '1 hr ago'),
                      buildProfile('Name 3', '2 hr ago'),
                      buildProfile('Name 4', '3 hr ago'),
                      buildProfile('Name 5', '4 hr ago'),
                    ],
                  ),

                  // Check In 버튼
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Check In'),
                  ),
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

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.near_me),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
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
