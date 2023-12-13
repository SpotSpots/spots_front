
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'CafeService.dart';
import 'InfoScreen.dart';
import 'SearchPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = '';
  String spotName = '';
  String spotDetail = '';

  String category = 'cafe';

  int _current = 0;
  int _selectedCategory = 0;

  @override
  void initState(){
    super.initState();
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('user').doc(uid).get();

      setState(() {
        userName = userSnapshot['userName'];
      });
    } catch (error) {
      print('Error : $error');
    }
  }

  Future<String> getUserRecentReviewCafe() async {
    try{
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('user').doc(uid).get();

      if(userSnapshot['reviews'] == null){
        return '';
      } else{
        print(userSnapshot['reviews']);

        String data = userSnapshot['reviews'].split('/')[1];

        return data;
      }

    } catch (error) {
      print('Error : $error');
      return '';
    }
  }


  @override
  Widget build(BuildContext context) {
    final CollectionReference _cafe = FirebaseFirestore.instance.collection('cafe');
    final CarouselController _controller = CarouselController();

    final String imageUrl =
        'https://firebasestorage.googleapis.com/v0/b/spotsfront.appspot.com/o/310_%EC%BB%A4.jpg?alt=media&token=9c58d924-97e5-4cb0-a0cc-857fccd5bba5';

    final List<Widget> carouselWidgets = [
      // 첫번째 컨텐츠 : find your spot!
      Container(
        padding: const EdgeInsets.all(20),
        height: 220,
        width: 350,
        // width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Seek the perfect",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Text(
              "work spot today!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  "Swipe for your ",
                  style: TextStyle(fontSize: 17),
                ),
                Text(
                  "Spots",
                  style: TextStyle(fontSize: 22, color: Colors.blue),
                ),
              ],
            ),
            SizedBox(height: 10,),
          ],
        ),
      ),

      // 두 번째 컨텐츠 : 내가 가장 최근 체크인(리뷰)한 곳 -> 일단 가장 많이 방문 한 곳으로 컨텐츠 변경함
      if (getUserRecentReviewCafe() != '') Container(
          padding: const EdgeInsets.all(15),
          height: 220,
          width: 350,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Row(
            children: [
              const SizedBox(width: 10,),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Most",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "Visited",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: Colors.blue),
                  ),
                  Text(
                    "Spot",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                ],
              ),

              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const InfoScreen('COFFEE NIE')));
                },
                child: Container(
                  margin: const EdgeInsets.only(left:20),
                  width: 150,
                  child: Stack(
                    children: [
                      // 이미지
                      Container(
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [BoxShadow(
                                color: Colors.grey.withOpacity(0.7),
                                spreadRadius: 0,
                                blurRadius: 5.0,
                                offset: Offset(0, 5)
                            )
                            ],
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage('assets/coffeenie.jpg'),
                            )
                        ),
                      ),

                      // 별점 정보 - 1. 검은색 깃발 이미지
                      const Positioned(
                        top: 17,
                        child: Image(image: AssetImage('assets/starMark.png'), width: 60, height: 30,),
                      ),

                      // 별점 정보 - 2. 별 이미지
                      const Positioned(
                        top: 25,
                        left: 4,
                        child: const Image(image: AssetImage('assets/star.png'),),
                      ),

                      // 별점 정보 - 3. 별점 text
                      Positioned(
                          top: 25,
                          left: 20,
                          child: Text('4.3', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),)
                      ),

                      //하얀색 컨테이너
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          alignment: Alignment.bottomLeft,
                          height: 50,
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                              ),
                              color: Colors.white,
                              boxShadow: [BoxShadow(
                                  color: Colors.grey.withOpacity(0.7),
                                  spreadRadius: 0,
                                  blurRadius: 5.0,
                                  offset: Offset(0, 5)
                              )
                              ]
                          ),
                          child: Container( // 이름, 거리
                            margin: const EdgeInsets.only(left: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'COFFEE NIE',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    color: Colors.black,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  '310 Bldg 1F',
                                  style: TextStyle(
                                    fontSize: 10,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  maxLines: 1,
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),

            ],
          ),
        ) else Container(  // 리뷰 안 남겼으면 보여줄 위젯
        padding: const EdgeInsets.all(15),
        height: 220,
        width: 350,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Row(
          children: [
            const SizedBox(width: 10,),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Most",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                Text(
                  "Visited",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: Colors.blue),
                ),
                Text(
                  "Spot",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
              ],
            ),

            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const InfoScreen('COFFEE NIE')));
              },
              child: Container(
                margin: const EdgeInsets.only(left:20),
                width: 150,
                child: Stack(
                  children: [
                    // 이미지
                    Container(
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [BoxShadow(
                              color: Colors.grey.withOpacity(0.7),
                              spreadRadius: 0,
                              blurRadius: 5.0,
                              offset: Offset(0, 5)
                          )
                          ],
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/coffeenie.jpg'),
                          )
                      ),
                    ),

                    // 별점 정보 - 1. 검은색 깃발 이미지
                    const Positioned(
                      top: 17,
                      child: Image(image: AssetImage('assets/starMark.png'), width: 60, height: 30,),
                    ),

                    // 별점 정보 - 2. 별 이미지
                    const Positioned(
                      top: 25,
                      left: 4,
                      child: const Image(image: AssetImage('assets/star.png'),),
                    ),

                    // 별점 정보 - 3. 별점 text
                    Positioned(
                        top: 25,
                        left: 20,
                        child: Text('4.3', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),)
                    ),

                    //하얀색 컨테이너
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        alignment: Alignment.bottomLeft,
                        height: 50,
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                            ),
                            color: Colors.white,
                            boxShadow: [BoxShadow(
                                color: Colors.grey.withOpacity(0.7),
                                spreadRadius: 0,
                                blurRadius: 5.0,
                                offset: Offset(0, 5)
                            )
                            ]
                        ),
                        child: Container( // 이름, 거리
                          margin: const EdgeInsets.only(left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'COFFEE NIE',
                                style: const TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                '310 Bldg 1F',
                                style: TextStyle(
                                  fontSize: 10,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                maxLines: 1,
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

          ],
        ),
      ),

      // 세 번째 컨텐츠 : 리뷰가 가장 많은 곳
      Container(
        padding: const EdgeInsets.all(15),
        height: 220,
        width: 350,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Row(
          children: [
            const SizedBox(width: 10,),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Highest",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                Text(
                  "Rated",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: Colors.blue),
                ),
                Text(
                  "Spot",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
              ],
            ),

            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => InfoScreen('208 Bldg 6F PC Lab')));
              },
              child: Container(
                margin: const EdgeInsets.only(left:20),
                width: 150,
                child: Stack(
                  children: [
                    // 이미지
                    Container(
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [BoxShadow(
                              color: Colors.grey.withOpacity(0.7),
                              spreadRadius: 0,
                              blurRadius: 5.0,
                              offset: Offset(0, 5)
                          )
                          ],
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/208bldg6f.png'),
                          )
                      ),
                    ),

                    // 별점 정보 - 1. 검은색 깃발 이미지
                    const Positioned(
                      top: 17,
                      child: Image(image: AssetImage('assets/starMark.png'), width: 60, height: 30,),
                    ),

                    // 별점 정보 - 2. 별 이미지
                    const Positioned(
                      top: 25,
                      left: 4,
                      child: const Image(image: AssetImage('assets/star.png'),),
                    ),

                    // 별점 정보 - 3. 별점 text
                    Positioned(
                        top: 25,
                        left: 20,
                        child: Text('4.7', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),)
                    ),

                    //하얀색 컨테이너
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        alignment: Alignment.bottomLeft,
                        height: 50,
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                            ),
                            color: Colors.white,
                            boxShadow: [BoxShadow(
                                color: Colors.grey.withOpacity(0.7),
                                spreadRadius: 0,
                                blurRadius: 5.0,
                                offset: Offset(0, 5)
                            )
                            ]
                        ),
                        child: Container(// 이름, 거리
                          width: 150,
                          margin: const EdgeInsets.only(left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                '208 Bldg 6F PC Lab',
                                style: const TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                'PC Lab',
                                style: TextStyle(
                                  fontSize: 10,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                maxLines: 1,
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

          ],
        ),
      )
    ];

    Widget sliderWidget(){
      return CarouselSlider(
        carouselController: _controller,
        options: CarouselOptions(
            aspectRatio: 2.0,
            enlargeCenterPage: true,
            scrollDirection: Axis.horizontal,
            autoPlay: true,
            onPageChanged: (index, reason){
              setState(() {
                _current = index;
              });
            }
        ),
        items: carouselWidgets,
      );
    }

    Widget sliderIndicator(){
      return Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(carouselWidgets.length, (index) {
            return GestureDetector(
              onTap: (){
                _controller.animateToPage(index);
                print('$index 누름!!!!!!!!!!!!!!!!');
              },
              child: Container(
                width: 10.0,
                height: 10.0,
                margin: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == _current
                        ? Colors.indigo
                        : Colors.black.withOpacity(0.5)),
              ),
            );
          }).toList(),
        ),
      );
    }
    // DatabaseReference starCountRef =
    // FirebaseDatabase.instance.ref('posts/$postId/starCount');
    // starCountRef.onValue.listen((DatabaseEvent event) {
    //   final data = event.snapshot.value;
    //   updateStarCount(data);
    // });

    return Scaffold(
      backgroundColor: const Color(0xffD5EAF7),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xffD5EAF7),
          leadingWidth: 200,
          leading: Container(
            width: 200,
            padding: const EdgeInsets.all(6),
            margin: const EdgeInsets.fromLTRB(15, 5, 5, 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/profile.jpg'),
                ),
                const SizedBox(width: 7),
                Row(
                  children: [
                    const Text(
                      'Hello, ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Container(
                      width: 70,
                      child: Text('$userName!',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                print('알림 클릭');
              },
            ),
            IconButton(
              icon: const Icon(Icons.door_back_door_outlined),
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // 1. 검색창
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: Size.zero,
                      padding: const EdgeInsets.fromLTRB(10, 15, 0, 15),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage()));
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.search),
                        SizedBox(width: 10),
                        Text(
                          'Search cafe, library, study centers...',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20,),
                  // 2. stack widget
                  Column(
                    children: [
                      SizedBox(height: 240,
                        child: Stack(
                          children: [
                            sliderWidget(),
                            sliderIndicator(),
                          ],
                        ),)
                    ],
                  ),

                  const SizedBox(height: 10),
                  // 3. Recommended Spots
                  Container(
                    padding: const EdgeInsets.all(15),
                    width: MediaQuery.of(context).size.width,
                    height: 500,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 3-1. 텍스트 위젯
                        const Text(
                          "Recommend Spots",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 5),
                        // 3-2. 장소 버튼
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _selectedCategory == 0? Colors.blue : Colors.blue[50],
                                  minimumSize: Size.zero,
                                  padding: const EdgeInsets.fromLTRB(15, 7, 15, 7),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {
                                  setState(() {
                                    category = 'cafe';
                                    _selectedCategory = 0;
                                  });
                                },
                                child: Text('Cafes', style: TextStyle(color: _selectedCategory == 0? Colors.white: Colors.blue[600]),),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _selectedCategory == 1? Colors.blue : Colors.blue[50],
                                  minimumSize: Size.zero,
                                  padding: const EdgeInsets.fromLTRB(15, 7, 15, 7),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {
                                  setState(() {
                                    category = 'studyspot';
                                    _selectedCategory = 1;
                                  });
                                },
                                child: Text('Study Spots', style: TextStyle(color: _selectedCategory == 1? Colors.white: Colors.blue[600]),),
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        // 3-3. 장소 카드 뷰

                        SizedBox(
                          height: 370,
                          child: FutureBuilder(
                            future: CafeService().getCafesByCategory(category),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<Cafe> cafes = snapshot.data!;
                                return GridView.builder(
                                  shrinkWrap: true,
                                  itemCount: cafes.length,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 1,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 5,
                                  ),
                                  itemBuilder: (context, index) {
                                    final Cafe cafe = cafes[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => InfoScreen(cafe.name!)));
                                      },
                                      child:
                                      Stack(
                                        children: [
                                          // 이미지
                                          Container(
                                            margin: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15),
                                                boxShadow: [BoxShadow(
                                                    color: Colors.grey.withOpacity(0.7),
                                                    spreadRadius: 0,
                                                    blurRadius: 5.0,
                                                    offset: Offset(0, 5)
                                                )
                                                ],
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                        cafe.image!)
                                                )
                                            ),
                                          ),

                                          // 별점 정보 - 1. 검은색 깃발 이미지
                                          const Positioned(
                                            top: 17,
                                            child: Image(image: AssetImage('assets/starMark.png'), width: 60, height: 30,),
                                          ),

                                          // 별점 정보 - 2. 별 이미지
                                          const Positioned(
                                            top: 25,
                                            left: 4,
                                            child: const Image(image: AssetImage('assets/star.png'),),
                                          ),

                                          // 별점 정보 - 3. 별점 text
                                          Positioned(
                                              top: 25,
                                              left: 20,
                                              child: Text(cafe.rating!, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),)
                                          ),

                                          //하얀색 컨테이너
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              alignment: Alignment.bottomLeft,
                                              height: 50,
                                              margin: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.only(
                                                    bottomRight: Radius.circular(15),
                                                    bottomLeft: Radius.circular(15),
                                                  ),
                                                  color: Colors.white,
                                                  boxShadow: [BoxShadow(
                                                      color: Colors.grey.withOpacity(0.7),
                                                      spreadRadius: 0,
                                                      blurRadius: 5.0,
                                                      offset: Offset(0, 5)
                                                  )
                                                  ]
                                              ),
                                              child: Container( // 이름, 거리
                                                margin: const EdgeInsets.only(left: 10),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  children: [
                                                    Text(
                                                      cafe.name!,
                                                      style: const TextStyle(
                                                        fontSize: 17,
                                                        color: Colors.black,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                    Text(
                                                      cafe.detail!,
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      maxLines: 1,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }
                              else {
                                return const Center(child: SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: CircularProgressIndicator(color: Colors.blue,),
                                ));
                              }
                            },
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
