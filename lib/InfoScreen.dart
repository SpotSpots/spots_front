import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CafeInfo {
  final String amenNum;
  final String category;
  String congestion;
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
  String _selectedCongestion = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isFavorite = false;


  @override
  void initState() {
    super.initState();
    _fetchCafeInfo();
    _fetchReviews();
    _checkFavorite();
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

  Future<void> _fetchReviews() async {
    try {
      // Firestore에서 해당 카페이름을 가진 문서의 리뷰 데이터를 가져옵니다.
      DocumentSnapshot cafeSnapshot = await FirebaseFirestore.instance
          .collection('cafe')
          .doc(widget.cafeInfo)
          .get();

      // 가져온 리뷰 데이터를 리스트에 할당합니다.
      List<String> userNames = [];
      List<String> reviews = [];

      if (cafeSnapshot.exists) {
        List<dynamic> reviewSnapshot = cafeSnapshot['reviews'];

        for (var review in reviewSnapshot) {
          // Firestore에서 해당 userID를 가진 문서를 가져와서 userName 필드 값을 얻습니다.
          DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
              .collection('user')
              .doc(review.split('/')[1]) // 구조가 'user/userId/reviewText'인 경우
              .get();

          // userName 필드 값을 가져와서 _userNames 리스트에 추가합니다.
          if (userSnapshot.exists) {
            userNames.insert(0, userSnapshot['userName']);

          } else {
            // 사용자 문서가 존재하지 않거나 'userName' 필드가 없는 경우 처리
            userNames.insert(0, 'unknown');

          }

          reviews.insert(0, review.split('/')[2]);
        }
        _times.insert(0, 'now');
      }

      // 상태를 업데이트합니다.
      setState(() {
        _userNames = userNames;
        _reviews = reviews;
      });
    } catch (error) {
      print('리뷰 가져오기 오류: $error');
    }
  }

  Future<void> _showCongestionDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Select Congestion'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCongestionRadioTile('congest', 'Congest', setState),
                  _buildCongestionRadioTile('normal', 'Normal', setState),
                  _buildCongestionRadioTile('sparse', 'Sparse', setState),
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
                  onPressed: () async {
                    // Handle the done button click
                    print("Done button clicked: _selectedCongestion=$_selectedCongestion");
                    if (_selectedCongestion.isNotEmpty) {
                      // Update UI
                      setState(() {
                        _cafeData?.congestion = _selectedCongestion;
                      });

                      // TODO: Update Firestore with the new congestion value
                      try {
                        // Firestore에서 해당 카페이름을 가진 문서를 찾습니다.
                        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                            .collection('cafe')
                            .where('name', isEqualTo: widget.cafeInfo)
                            .get();

                        // 가져온 문서가 하나일 경우에만 처리합니다.
                        if (querySnapshot.docs.length == 1) {
                          // 문서 ID를 가져옵니다.
                          String documentID = querySnapshot.docs.first.id;

                          // 문서를 업데이트합니다. 문서 ID를 사용하여 업데이트할 문서를 지정합니다.
                          await FirebaseFirestore.instance
                              .collection('cafe')
                              .doc(documentID)
                              .update({'congestion': _selectedCongestion});

                          print('Firestore document updated successfully!');
                        } else {
                          print('Document not found or multiple documents found.');
                        }
                      } catch (error) {
                        print('Error updating Firestore document: $error');
                      }
                      // Close the dialog
                      Navigator.of(context).pop();

                      // Update the text in the main screen
                      setState(() {}); // This will trigger a redraw of the main screen
                    }
                  },
                  child: Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showReviewDialog() async {
    String? userId = getCurrentUserId();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Write a Review'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _reviewController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Enter your review here...',
                  contentPadding: EdgeInsets.all(16.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.redAccent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(width: 2, color: Colors.redAccent),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Clear the text field when cancel is pressed
                _reviewController.clear();
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Handle the review submission
                String reviewText = _reviewController.text;
                if (userId != null && reviewText.isNotEmpty) {
                  try {
                    // 리뷰 업데이트 수행
                    await FirebaseFirestore.instance
                        .collection('user')
                        .doc(userId)
                        .update({
                      'reviews': FieldValue.arrayUnion(['cafe/${widget.cafeInfo}/$reviewText'])
                    });

                    // 카페의 리뷰 업데이트
                    await FirebaseFirestore.instance
                        .collection('cafe')
                        .doc(widget.cafeInfo)
                        .update({
                      'reviews': FieldValue.arrayUnion(['user/$userId/$reviewText'])
                    });

                    print('Review submitted and Firestore updated successfully!');

                    await _fetchReviews();



                  } catch (error) {
                    print('Error updating Firestore with the new review: $error');
                  }

                  // Close the dialog
                  Navigator.of(context).pop();

                  // Update the text in the main screen
                  setState(() {}); // This will trigger a redraw of the main screen
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _checkFavorite() async {
    try {
      User? user = getCurrentUser();
      if (user != null) {
        // 현재 로그인한 사용자의 ID 가져오기
        String? userId = getCurrentUserId();
        print("**** userid **** " + userId.toString());

        // Firestore에서 해당 사용자의 정보를 가져옵니다.
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('user')
            .doc(userId)
            .get();

        if (userSnapshot.exists) {
          // userFavorite 필드를 확인하여 현재 카페가 포함되어 있는지 확인합니다.
          List<dynamic> userFavorites = userSnapshot['userFavorite'];

          // 1. cafeInfo로 cafe collection을 검색
          QuerySnapshot cafeQuery = await FirebaseFirestore.instance
              .collection('cafe')
              .where('name', isEqualTo: widget.cafeInfo)
              .get();

          if (cafeQuery.docs.isNotEmpty) {
            // 2. uid 검색 결과 나온 document의 하위 필드인 userFavorite에 cafeInfo로 검색한 cafe를 reference 하도록 설정
            DocumentReference cafeReference = cafeQuery.docs.first.reference;

            // Check if the current cafeInfo is in the user's favorites
            bool isFavorite = userFavorites.contains(cafeReference);
            print("**** isFavorite **** " + isFavorite.toString());
            print("**** widget.cafeInfo **** " + widget.cafeInfo);

            // Toggle the favorite state
            setState(() {
              _isFavorite = isFavorite;
            });
          }
        }
      }
    } catch (error) {
      print('Error checking favorite status: $error');
    }
  }


  Future<void> _toggleFavorite() async {
    try {
      User? user = getCurrentUser();
      if (user != null) {
        // 현재 로그인한 사용자의 ID 가져오기
        String? userId = getCurrentUserId();

        // Firestore에서 해당 사용자의 정보를 가져옵니다.
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('user')
            .doc(userId)
            .get();

        if (userSnapshot.exists) {
          // userFavorite 필드를 업데이트하여 현재 카페를 추가 또는 제거합니다.
          List<dynamic> userFavorites = userSnapshot['userFavorite'];
          if (_isFavorite) {
            userFavorites.remove('cafe/${widget.cafeInfo}');
          } else {
            userFavorites.add('cafe/${widget.cafeInfo}');
          }

          // 업데이트된 정보를 Firestore에 저장합니다.
          await FirebaseFirestore.instance
              .collection('user')
              .doc(userId)
              .update({'userFavorite': userFavorites});

          setState(() {
            _isFavorite = !_isFavorite;
          });
        }
      }
    } catch (error) {
      print('Error toggling favorite status: $error');
    }
  }

  String _lastSelected = 'TAB: 0';
  bool _isChecked = false;


  List<String> _userNames = [];
  List<String> _reviews = [];
  bool _showMoreReviews = false;

  List<String> _times = ['32 min ago', '51 min ago', '1 hr ago', '3 hr ago', '5 hr ago', '12 hr ago','15 hr ago','22 hr ago','1 day ago','5 days ago', '7 days ago', '7 days ago', '9 days ago', '10 days ago', '15 days ago'];

  bool boothSeating = true;
  bool limitedOutlets = true;
  bool moderateNoise = false;
  bool wifi = true;
  TextEditingController _reviewController = TextEditingController();


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
                Image.network(_cafeData?.image ?? 'assets/cafe1.png'),
                Positioned(
                  top: 35,
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
                  top: 35,
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
                            _isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: _isFavorite ? Colors.red : Colors.grey, size: 20,
                          ),
                          onPressed: () {
                            _toggleFavorite();
                          },
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
                            _cafeData?.name ?? '',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 20),
                          Image.asset(
                            _cafeData?.congestion != null
                                ? 'assets/${_cafeData?.congestion}.png'
                                : 'assets/normal.png', // 기본 이미지 경로로 수정
                            width: 10,
                            height: 10,
                          ),
                          SizedBox(width: 8),
                          Text(_cafeData?.congestion ?? ''),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.yellow),
                          Text(_cafeData?.rating ?? ''),
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
                      Text(_cafeData?.category  ?? ''),
                      Text('  //  '),
                      Text(_cafeData?.detail  ?? ''),
                    ]
                  ),
                ],
              ),
            ),

            Divider(),
            SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                if (!_isChecked) {
                  // Only show the congestion dialog when not checked in
                  await _showCongestionDialog();
                } else {
                  await _showReviewDialog();
                }
                setState(() {
                  _isChecked = !_isChecked; // 여기서 _isChecked를 true로 변경
                });
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(350, 50),
                primary: _isChecked ? Colors.green : Colors.blue,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  _isChecked ? 'Check Out' : 'Check In',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),

            SizedBox(height: 10),

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

              for (int i = 0; i < (visibleReviews.length > 3 && !_showMoreReviews ? 3 : visibleReviews.length); i++) ...[
                buildProfile(_userNames[i], _times[i], visibleReviews[i]),
                SizedBox(height: 10),
              ],

              // See more 또는 See less 버튼 추가
              if (_reviews.length > 3)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showMoreReviews = !_showMoreReviews;
                    });
                  },
                  child: Text(_showMoreReviews ? 'See less' : 'See more'),
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

  Widget _buildCongestionRadioTile(String value, String label, Function(void Function()) setStateCallback) {
    return RadioListTile<String>(
      title:Row(
        children: [
        Text(label),
        SizedBox(width: 10), // 이미지와 텍스트 사이의 간격 조절
        Image.asset(
          'assets/$value.png',
          width: 10,  // 원하는 너비 설정
          height: 10, // 원하는 높이 설정
        ),
        ],
      ),
      value: value,
      groupValue: _selectedCongestion,
      onChanged: (String? newValue) {
        setStateCallback(() {
          _selectedCongestion = newValue!;
        });
      },
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
  User? getCurrentUser() {
    User? user = _auth.currentUser;
    return user;
  }

// 현재 로그인한 사용자의 ID 가져오기
  String? getCurrentUserId() {
    User? user = _auth.currentUser;
    return user?.uid;
  }

}
