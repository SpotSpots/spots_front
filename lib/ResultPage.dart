import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotsfront/InfoScreen.dart';
import 'CafeService.dart';
import 'RecentSearches.dart';

class ResultPage extends StatefulWidget {
  const ResultPage(
      {super.key,
    required this.searchKeyword, required this.cafeQuery});

  final String searchKeyword;
  final Future<List<Cafe>> cafeQuery;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

List<bool> _isFavorite = List.filled(11, false);

Future<void> initUserFavorites(String cafeName, int i) async {
  print("addToUserFavorites " + cafeName); // ok
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

        // Toggle the favorite state
        _isFavorite[i] = userFavorites.contains(cafeReference);

        print('Cafe favorite status updated successfully.');
      }
    }
  } catch (error) {
    print('Error adding cafe to user favorites: $error');
  }
}

class _ResultPageState extends State<ResultPage> {

  @override
  void initState(){
    super.initState();
    print(_isFavorite);
  }

  Future<void> addToUserFavorites(String cafeName, int i) async {
    print("addToUserFavorites " + cafeName); // ok
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
            //cafe.isFavorite = !cafe.isFavorite;
            _isFavorite[i] = userFavorites.contains(cafeReference);
          });

          print('Cafe favorite status updated successfully.');
        }
      }
    } catch (error) {
      print('Error adding cafe to user favorites: $error');
    }
  }


  Widget build(BuildContext context) {
    String searchKeyword = widget.searchKeyword;
    return Scaffold(
      backgroundColor: const Color(0xffD5EAF7),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xffD5EAF7),
        title: Text('Results', style: TextStyle(fontWeight: FontWeight.bold),),
        leading: IconButton(
            icon: Icon(Icons.navigate_before, size: 28),
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.pop(context);
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // 1. 검색창
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.fromLTRB(10,0,10,0),
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                width: MediaQuery.of(context).size.width,
                height: 54,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 20,
                      offset: Offset(0, 11), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Icon(Icons.search),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        initialValue: searchKeyword,
                        style: TextStyle(fontSize:15),
                        decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            border: InputBorder. none,
                            hintText: 'Search cafe, library, study centers...',
                            hintStyle: TextStyle(color: Colors.grey)
                        ),
                        onChanged: (value){
                          searchKeyword = value;
                        },
                        onFieldSubmitted: (value) {
                          context.read<RecentSearches>().addSearchKeyword(searchKeyword);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => ResultPage(searchKeyword: searchKeyword, cafeQuery: CafeService().getCafesBySearchKeyword(searchKeyword))));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 2. 정렬, 필터링 버튼
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(style : ElevatedButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.fromLTRB(7, 7, 7, 7),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ), onPressed : (){}, child: const Icon(Icons.tune)),
                ElevatedButton(style : ElevatedButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.fromLTRB(15, 7, 10, 7),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ), onPressed : (){},
                    child: Row(
                      children: [
                        const Text('Sort'), Icon(Icons.expand_more),
                      ],
                    )),
                ElevatedButton(style : ElevatedButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.fromLTRB(15, 7, 15, 7),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ), onPressed : (){}, child: const Text('Open Now')),
                ElevatedButton(style : ElevatedButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.fromLTRB(15, 7, 10, 7),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ), onPressed : (){}, child: Row(
                  children: [
                    const Text('Price'), Icon(Icons.expand_more),
                  ],
                )),
                ElevatedButton(style : ElevatedButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.fromLTRB(15, 7, 15, 7),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ), onPressed : (){}, child: const Text('Wi-Fi')),
              ],
            ),

            // 3. 카페 이미지 + 정보
            SizedBox(height: 25,),
            Expanded(
              child: FutureBuilder<List<Cafe>>(
                  future: widget.cafeQuery,
                  builder: (context, snapshot){
                    if(snapshot.hasData) {
                      List<Cafe> cafes = snapshot.data!;
                      return ListView.builder(
                          itemCount: cafes.length,
                          itemBuilder: (BuildContext context, int i){
                            Cafe cafe = cafes[i];
                            initUserFavorites(cafe.name!, i);
                            return GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => InfoScreen(cafe.name!)));
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 20.0),
                                child: Column(
                                  children: [
                                    Stack(
                                        children : [
                                          Image( // 카페 이미지 : cafe/image
                                              image: NetworkImage(cafe.image!),
                                              width: 380
                                          ),
                                          Positioned(
                                            bottom: 117,
                                            right: 159,
                                            child: const Image(
                                                image: AssetImage(
                                                    'assets/starMark.png'
                                                ),
                                                width: 380
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 8,
                                            right: 176,
                                            child: const Image(
                                                image: AssetImage(
                                                    'assets/star.png'
                                                ),
                                                width: 380
                                            ),
                                          ),
                                          Positioned(  // 별점 정보 : cafe/rating
                                            bottom: 175,
                                            left: 25,
                                            child: Text(cafes[i].rating!, style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),),
                                          ),
                                          Positioned( // 찜 기능 : 나중에 추가
                                            bottom: 166,
                                            left: 335,
                                            child: Container(
                                              width: 36,
                                              height: 36,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                              ),
                                              child: IconButton(
                                                icon: Icon(
                                                  _isFavorite[i]
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color: _isFavorite[i] ? Colors.red : Colors.red,
                                                  size: 20,
                                                ),
                                                onPressed: () async {
                                                  addToUserFavorites(cafe.name!, i);
                                                },
                                              ),
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
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(11,0,11,0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column( // 이름, 위치 정보 : cafe/name
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(cafe.name!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        //Icon(Icons.location_on),
                                                        Image.asset('assets/${cafe.congestion!}.png', width: 12, height: 12,),
                                                        Text(' Here is '),
                                                        Text(cafe.congestion!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                                                        Text(' now'),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                ElevatedButton( // checkin 버튼 나중에 구현
                                                    style : ElevatedButton.styleFrom(
                                                        minimumSize: Size(60, 30)),
                                                    onPressed: (){
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => InfoScreen(cafe.name!)));
                                                    }, child: Text('See details')
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row( // amenities 정보 : cafe/amenities
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
                                              Text('+ ${cafe.amenNum!} More', style: TextStyle(color: Colors.grey),),
                                              SizedBox(width: 2),
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
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
