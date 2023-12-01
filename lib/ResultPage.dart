import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key, required this.title});

  final String title;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  // 나중에 기능 추가하면서 삭제
  int _myCounter = 0;
  int _yourCounter = 0;
  void _refreshGoalCounter() {
    setState(() {
      _myCounter = 0;
      _yourCounter = 0;
    });
  }
  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE9E9E9),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xffE9E9E9),
        title: Text('Reslts', style: TextStyle(fontWeight: FontWeight.bold),),
        leading: IconButton(
            icon: Icon(Icons.navigate_before, size: 28),
            onPressed: () {
              print('menu button is clicked');
            }
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.more_horiz),
              onPressed: () {
                print('clicked');
              }
          ),
        ],
      ),

      body: Container(
        child: ListView(
          children: <Widget> [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                // 1. 검색창
                SizedBox(height: 10,),
                ElevatedButton(style : ElevatedButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.fromLTRB(10, 15, 350, 15),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ), onPressed : _refreshGoalCounter, child: const Icon(Icons.search)),

                // 2. 정렬, 필터링 버튼 // 작동 되도록 수정
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(style : ElevatedButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.fromLTRB(7, 7, 7, 7),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ), onPressed : _refreshGoalCounter, child: const Icon(Icons.tune)),
                    ElevatedButton(style : ElevatedButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.fromLTRB(15, 7, 15, 7),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ), onPressed : _refreshGoalCounter, child: const Text('Sort V')),
                    ElevatedButton(style : ElevatedButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.fromLTRB(15, 7, 15, 7),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ), onPressed : _refreshGoalCounter, child: const Text('Open Now')),
                    ElevatedButton(style : ElevatedButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.fromLTRB(15, 7, 15, 7),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ), onPressed : _refreshGoalCounter, child: const Text('Price V')),
                    ElevatedButton(style : ElevatedButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.fromLTRB(15, 7, 15, 7),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ), onPressed : _refreshGoalCounter, child: const Text('Wi-Fi')),
                  ],
                ),

                // 3. 카페 이미지 + 정보
                SizedBox(height: 30,),
                Container(
                  margin: EdgeInsets.only(bottom: 20.0),
                  child: Column(
                    children: [
                      Stack(
                          children : [
                            const Image(
                                image: AssetImage(
                                    'assets/cafe1.png'
                                ),
                                width: 380
                            ),
                            Positioned(
                              bottom: 117,
                              right: 158,
                              child: const Image(
                                  image: AssetImage(
                                      'assets/starMark.png'
                                  ),
                                  width: 380
                              ),
                            ),
                            Positioned(
                              bottom: 9,
                              right: 176,
                              child: const Image(
                                  image: AssetImage(
                                      'assets/star.png'
                                  ),
                                  width: 380
                              ),
                            ),
                            Positioned(  // 별점 정보
                              bottom: 176,
                              left: 25,
                              child: Text('4.2', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),),
                            ),
                            Positioned(
                              bottom: -5,
                              left: 160,
                              child: const Image(
                                  image: AssetImage(
                                      'assets/circle.png'
                                  ),
                                  width: 380
                              ),
                            ),
                            Positioned(
                              bottom: 12,
                              left: 160,
                              child: const Image(
                                  image: AssetImage(
                                      'assets/heart.png'
                                  ),
                                  width: 380
                              ),
                            ),
                          ]
                      ),
                      Container(
                        width: 380,
                        height: 110,
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Column(
                                  children: [
                                    Text('KRISP Fresh Living', style: TextStyle(fontWeight: FontWeight.bold),),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(Icons.location_on),
                                        Text('2.4 mi // Irvine'),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 110,
                                ),
                                ElevatedButton(style : ElevatedButton.styleFrom(minimumSize: Size(60, 30)), onPressed: _refreshGoalCounter, child: Text('Check In')),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(width: 2),
                                Icon(Icons.wifi),
                                Text('Wi-fi'),
                                SizedBox(width: 5),
                                Icon(Icons.videocam),
                                Text('Outlets'),
                                SizedBox(width: 5),
                                Icon(Icons.volume_up),
                                Text('Moderate Noise'),
                                SizedBox(width: 8),
                                Text('+ 5 More', style: TextStyle(color: Colors.grey),), // 누르면 나머지 보여주기?
                                SizedBox(width: 2),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),


                // 4. 3과 동일하게...
                SizedBox(height: 10,),
                Container(
                  margin: EdgeInsets.only(bottom: 20.0),
                  child: Column(
                    children: [
                      Stack(
                          children : [
                            const Image(
                                image: AssetImage(
                                    'assets/cafe1.png'
                                ),
                                width: 380
                            ),
                            Positioned(
                              bottom: 117,
                              right: 158,
                              child: const Image(
                                  image: AssetImage(
                                      'assets/starMark.png'
                                  ),
                                  width: 380
                              ),
                            ),
                            Positioned(
                              bottom: 9,
                              right: 176,
                              child: const Image(
                                  image: AssetImage(
                                      'assets/star.png'
                                  ),
                                  width: 380
                              ),
                            ),
                            Positioned(  // 별점 정보
                              bottom: 176,
                              left: 25,
                              child: Text('4.1', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),),
                            ),
                            Positioned(
                              bottom: -5,
                              left: 160,
                              child: const Image(
                                  image: AssetImage(
                                      'assets/circle.png'
                                  ),
                                  width: 380
                              ),
                            ),
                            Positioned(
                              bottom: 12,
                              left: 160,
                              child: const Image(
                                  image: AssetImage(
                                      'assets/heart.png'
                                  ),
                                  width: 380
                              ),
                            ),
                          ]
                      ),
                      Container(
                        width: 380,
                        height: 110,
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Column(
                                  children: [
                                    Text('KRISP Fresh Living', style: TextStyle(fontWeight: FontWeight.bold),),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(Icons.location_on),
                                        Text('2.4 mi // Irvine'),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 110,
                                ),
                                ElevatedButton(
                                    style : ElevatedButton.styleFrom(minimumSize: Size(60, 30)),
                                    onPressed: _refreshGoalCounter,
                                    child: Text('Check In')),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(width: 2),
                                Icon(Icons.wifi),
                                Text('Wi-fi'),
                                SizedBox(width: 5),
                                Icon(Icons.videocam),
                                Text('Outlets'),
                                SizedBox(width: 5),
                                Icon(Icons.volume_up),
                                Text('Moderate Noise'),
                                SizedBox(width: 8),
                                Text('+ 5 More', style: TextStyle(color: Colors.grey),), // 누르면 나머지 보여주기?
                                SizedBox(width: 2),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),



              ],
            ),
          ],
        ),
      ),
    );
  }
}
