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
  int _congestionLevel = -1; // -1: 선택 안 함, 0: 낮음, 1: 보통, 2: 높음
  TextEditingController _reviewController = TextEditingController(); // 리뷰를 입력받을 컨트롤러

  bool boothSeating = true;
  bool limitedOutlets = true;
  bool moderateNoise = false;
  bool wifi = true;

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

  void _toggleCheckIn(String review) {
    if (_congestionLevel == -1) {
      // Show a pop-up message indicating that congestion level should be selected
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Please Select Congestion Level'),
            content: Text('Please select a congestion level before checking in.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Proceed with check-in logic
      setState(() {
        _isChecked = !_isChecked;
        _checkInText = _isChecked ? 'Check Out' : 'Check In';
        _addToRecentlyCheckedIn(_isChecked, _congestionLevel, review);
      });
    }
  }

  void _addToRecentlyCheckedIn(bool checkedIn, int congestionLevel, String review) {
    // TODO: Recently Checked In에 추가하는 로직을 구현
    // checkedIn: 체크인 상태, congestionLevel: 선택한 혼잡도, review: 작성한 리뷰
    // firebase 연동
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
                Image.asset('assets/cafe1.png', width: double.infinity, height: 200, fit: BoxFit.cover),

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
                      Icon(Icons.place, color: Colors.black),
                      SizedBox(width: 8),
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

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Congestion Level Before Checking In:', // 라디오 버튼 위에 혼잡도를 체크해주세요라는 텍스트 (영어)
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildRadioButton('sparse', 0),
                      _buildRadioButton('normal', 1),
                      _buildRadioButton('congest', 2),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _reviewController,
                decoration: const InputDecoration(
                  hintText: 'Write your review',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ),

        ElevatedButton(
          onPressed: () {
            _toggleCheckIn(_reviewController.text);
          },
          style: ElevatedButton.styleFrom(
            minimumSize: Size(80, 70),
            primary: _isChecked ? Colors.green : Colors.blue,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              _checkInText,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),

            SizedBox(height: 20),

            Divider(),

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

            Divider(),

            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Amenities'),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildAmenityRow(Icons.airline_seat_legroom_normal, 'Booth Seating', boothSeating),
                      ),
                      SizedBox(width: 16), // 각 항목 사이의 간격 조절
                      Expanded(
                        child: _buildAmenityRow(Icons.power, 'Limited Outlets', limitedOutlets),
                      ),
                    ],
                  ),
                  SizedBox(height: 8), // 행 간의 간격 조절
                  Row(
                    children: [
                      Expanded(
                        child: _buildAmenityRow(Icons.volume_down, 'Moderate Noise', moderateNoise),
                      ),
                      SizedBox(width: 16), // 각 항목 사이의 간격 조절
                      Expanded(
                        child: _buildAmenityRow(Icons.wifi, 'Wifi', wifi),
                      ),
                    ],
                  ),
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
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black),
            image: DecorationImage(
              image: AssetImage('assets/cafe1.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name),
              SizedBox(height: 4),

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

        Text(time, style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildRadioButton(String label, int value) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: _congestionLevel,
          onChanged: (int? selectedValue) {
            setState(() {
              _congestionLevel = selectedValue!;
            });
          },
        ),
        Text(label),
      ],
    );
  }

  Widget _buildAmenityRow(IconData icon, String text, bool isAvailable) {
    return Row(
      children: [
        Icon(icon),
        SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}
