import 'package:flutter/material.dart';

import 'fab_bottom_app_bar.dart';
import 'fab_with_icons.dart';
import 'layout.dart';

class InfoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  String _lastSelected = 'TAB: 0';
  String _checkInText = 'Check In';
  bool _isChecked = false;
  List<String> _reviews = [
    'Great place with a cozy atmosphere. Highly recommended!',
    'Nice coffee and friendly staff.',
    'Quiet place to work. Good coffee.',
    'Love the interior design. Good place for meetings.',
    'Great spot for studying. WiFi is fast!',
  ];
  bool _showMoreReviews = false;
  List<String> _userNames = ['alexiamae', 'liamthom..', 'emilygrace', 'lexijade', 'eljjaaaa'];

  void _selectedTab(int index) {
    setState(() {
      _lastSelected = 'TAB: $index';
    });
  }

  void _selectedFab(int index) {
    setState(() {
      _lastSelected = 'FAB: $index';
    });
  }

  void _toggleCheckIn() {
    setState(() {
      _isChecked = !_isChecked;
      _checkInText = _isChecked ? 'Checked!' : 'Check In';
    });
  }

  void _toggleMoreReviews() {
    setState(() {
      _showMoreReviews = !_showMoreReviews;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> visibleReviews = _showMoreReviews ? _reviews : _reviews.take(3).toList();

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
                    decoration: const BoxDecoration(
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
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

            // Check In 버튼
            ElevatedButton(
              onPressed: _toggleCheckIn,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0), // Adjust horizontal padding
                child: Text(
                  _checkInText,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(80, 70), // Adjust minimum size
                primary: _isChecked ? Colors.green : Colors.blue,
              ),
            ),

            SizedBox(height: 20),

            Divider(),

            // Recently Checked In 섹션
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Recently Checked In',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),

                  // Profile 리스트
                  for (int i = 0; i < visibleReviews.length; i++) ...[
                    buildProfile(_userNames[i], 'time', visibleReviews[i]),
                    Divider(),
                  ],

                  if (!_showMoreReviews)
                    ElevatedButton(
                      onPressed: _toggleMoreReviews,
                      child: Text('More Reviews'),
                    ),
                  if (_showMoreReviews)
                    ElevatedButton(
                      onPressed: _toggleMoreReviews,
                      child: Text('Less Reviews'),
                    ),
                ],
              ),
            ),

            // Divider
            Divider(),

            // Amenities 섹션
            const Padding(
              padding: EdgeInsets.all(16.0),
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
      bottomNavigationBar: FABBottomAppBar(
        centerItemText: 'Explore',
        color: Colors.blue,
        selectedColor: Colors.red,
        notchedShape: CircularNotchedRectangle(),
        onTabSelected: _selectedTab,
        items: [
          FABBottomAppBarItem(iconData: Icons.home, text: 'Home'),
          FABBottomAppBarItem(iconData: Icons.favorite, text: 'Saved'),
          FABBottomAppBarItem(iconData: Icons.chat_bubble, text: 'Activity'),
          FABBottomAppBarItem(iconData: Icons.person, text: 'Profile'),
        ],
        backgroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFab(
        context,
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    final icons = [Icons.school, Icons.local_cafe, Icons.more];
    return AnchoredOverlay(
      showOverlay: true,
      overlayBuilder: (context, offset) {
        return CenterAbout(
          position: Offset(offset.dx, offset.dy - icons.length * 35.0),
          child: FabWithIcons(
            icons: icons,
            onIconTapped: _selectedFab,
          ),
        );
      },
      child: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.explore),
        elevation: 2.0,
        shape: CircleBorder(),
      ),
    );
  }

  Widget buildProfile(String name, String time, String review) {
    return Row(
      children: [
        // 프로필 이미지
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
        SizedBox(width: 8),
        // 프로필 정보 및 리뷰
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 프로필 이름
              Text(name),
              SizedBox(height: 4),
              // 리뷰 텍스트
              Padding(
                padding: const EdgeInsets.only(top: 0, left: 8.0, right: 8.0, bottom: 8.0),
                child: Text(
                  review,
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
        // 리뷰 작성 시간
        Text(time, style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}
