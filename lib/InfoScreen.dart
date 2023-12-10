import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'fab_bottom_app_bar.dart';
import 'fab_with_icons.dart';
import 'layout.dart';

class CafeInfo {
  final String amenNum;
  final String category;
  final String congestion;
  final String detail;
  final String image;
  final String name;
  final String rating;
  // 다른 필드들 추가

  CafeInfo({
    required this.amenNum,
    required this.category,
    required this.congestion,
    required this.detail,
    required this.image,
    required this.name,
    required this.rating,
  });
}

class InfoScreen extends StatefulWidget {

  final String cafeInfo;
  const InfoScreen(this.cafeInfo);

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {

  CafeInfo? _cafeData;

  @override
  void initState() {
    super.initState();
    _fetchCafeInfo();
  }

  Future<void> _fetchCafeInfo() async {
    try {
      // Firestore에서 해당 카페이름을 가진 문서를 가져옵니다.
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('cafe')
          .where('name', isEqualTo: widget.cafeInfo)
          .get();

      // 가져온 문서가 하나일 경우에만 처리합니다.
      if (querySnapshot.docs.length == 1) {
        // 문서를 Map으로 변환합니다.
        Map<String, dynamic> data = querySnapshot.docs.first.data() as Map<String, dynamic>;

        // CafeInfo 객체로 변환합니다.
        CafeInfo cafeInfo = CafeInfo(
          name: data['name'],
          amenNum: data['amenNum'],
          category: data['category'],
          congestion: data['congestion'],
          detail: data['detail'],
          image: data['image'],
          rating: data['rating'],
          // 다른 필드들 추가
        );

        // 상태를 업데이트합니다.
        setState(() {
          _cafeData = cafeInfo;
        });
      }
    } catch (error) {
      print('Error fetching cafe info: $error');
    }
  }


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
                Image.asset('assets/${_cafeData?.image}', width: double.infinity, height: 200, fit: BoxFit.cover),

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

            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            _cafeData?.name ?? 'Loading...',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 20),
                          Image.asset(
                            'assets/${_cafeData?.congestion ?? 'default'}.png',
                            width: 10,
                            height: 10,
                          ),
                          SizedBox(width: 8),
                          Text(_cafeData!.congestion),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.yellow),
                          Text(_cafeData!.rating),
                        ],
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Text('Open until 7pm'), // 수정
                    ],
                  ),
                  Row(
                    children: [
                      Text(_cafeData!.category),
                      Text(' // '),
                      Text(_cafeData!.detail),
                    ]
                  ),
                  SizedBox(height: 20),
                ],
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
              image: AssetImage('assets/_cafeData.png'),
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

  Widget _buildAmenityRow(IconData icon, String text, bool isAvailable) {
    return Row(
      children: [
        Icon(icon),
        SizedBox(width: 8),
        // 있는것만 띄우기
        Text(text),
      ],
    );
  }

  Widget _buildRadioButtonWithImage(String label, int value) {
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
        Image.asset(
          'assets/$label.png',  // 이미지 파일의 경로
          width: 10,
          height: 10,
        ),
        SizedBox(width: 8),
        Text(label),
      ],
    );
  }



  /* function */
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

  // void _updateCongestionLevel(int newCongestionLevel) {
  //   // TODO: Firestore를 사용하여 DB에서 해당 카페의 congestion 값을 업데이트
  //   // widget.cafeInfo는 현재 카페의 이름입니다.
  //   FirebaseFirestore.instance
  //       .collection('cafe')
  //       .doc(widget.cafeInfo)
  //       .update({'congestion': newCongestionLevel})
  //       .then((_) {
  //     print('Congestion level updated successfully!');
  //   }).catchError((error) {
  //     print('Error updating congestion level: $error');
  //   });
  // }

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

  void _toggleCheckIn(String review) {
    if (_isChecked) {
      // Check Out 상태일 때 리뷰를 쓸 수 있는 팝업 띄우기
      _showReviewPopup();
    } else {
      // Check In 상태일 때 팝업 창 띄우기
      _showCongestionPopup();
    }
  }

  void _showCongestionPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Congestion Level'),
          contentPadding: EdgeInsets.symmetric(vertical: 16),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildRadioButtonWithImage('sparse', 0),
              _buildRadioButtonWithImage('normal', 1),
              _buildRadioButtonWithImage('congest', 2),
              SizedBox(height: 16),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Check if a RadioButton is selected
                if (_congestionLevel == -1) {
                  // Show a warning that a congestion level should be selected
                  _showCongestionWarning();
                } else {
                  // Proceed with Check In logic
                  Navigator.of(context).pop(); // Close the dialog
                  _performCheckIn(_reviewController.text);
                  // _updateCongestionLevel(_congestionLevel); // Update congestion level in DB
                }
              },
              child: Text('Done'),
            ),
          ],
        );
      },
    );
  }

  void _showCongestionWarning() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning'),
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
  }

  void _showReviewPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Write Your Review'),
          content: Column(
            children: [
              TextField(
                controller: _reviewController,
                decoration: InputDecoration(
                  hintText: 'Write your review',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Skip'),
            ),
            TextButton(
              onPressed: () {
                // Check if review is not empty
                if (_reviewController.text.isNotEmpty) {
                  // Proceed with Check Out logic
                  Navigator.of(context).pop(); // Close the dialog
                  _performCheckOut();
                } else {
                  // Show a warning that review should be written
                  _showReviewWarning();
                }
              },
              child: Text('Done'),
            ),
          ],
        );
      },
    );
  }

  void _showReviewWarning() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning'),
          content: Text('Please write a review before checking out.'),
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
  }

  void _performCheckIn(String review) {
    // TODO: Implement Check In logic
    setState(() {
      _isChecked = true;
      _checkInText = 'Check Out';
    });
    _addToRecentlyCheckedIn(true, _congestionLevel, review);
  }

  void _performCheckOut() {
    // TODO: Implement Check Out logic
    setState(() {
      _isChecked = false;
      _checkInText = 'Check In';
    });
  }


}
