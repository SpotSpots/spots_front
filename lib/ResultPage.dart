import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spotsfront/InfoScreen.dart';

class Cafe {
  Cafe({
    this.name,
    this.rating,
    this.amenNum,
    this.congestion,
    this.reference,
  });

  String? name;
  String? rating;
  String? amenNum;
  String? congestion;
  DocumentReference? reference;

  Cafe.fromJson(dynamic json,this.reference){
    name = json['name'];
    rating = json['rating'];
    amenNum = json['amenNum'];
    congestion = json['congestion'];
  }
  Cafe.fromSnapShot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(),snapshot.reference);

  Cafe.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(),snapshot.reference);
}

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

List<Cafe> cafes = [];
class _ResultPageState extends State<ResultPage> {

  Future<List<Cafe>> getCafes() async {
    CollectionReference<Map<String, dynamic>> collectionReference =
    FirebaseFirestore.instance.collection('cafe');
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await collectionReference.get();
    for (var doc in querySnapshot.docs) {
      Cafe cafe = Cafe.fromQuerySnapshot(doc);
      cafes.add(cafe);
    }
    return cafes;
  }

  @override
  void initState(){
    super.initState();
    getCafes();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE9E9E9),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xffE9E9E9),
        title: Text('Results', style: TextStyle(fontWeight: FontWeight.bold),),
        leading: IconButton(
            icon: Icon(Icons.navigate_before, size: 28),
            onPressed: () {
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
              child: ElevatedButton(style : ElevatedButton.styleFrom(
                minimumSize: Size.zero,
                padding: EdgeInsets.fromLTRB(10, 15, 0, 15),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ), onPressed : (){},
                child: const Row(
                  children: [
                    Icon(Icons.search),
                    SizedBox(width: 10),
                    Text(
                      'Cafes  ',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Current Location',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

            // 2. 정렬, 필터링 버튼 // 작동 되도록 수정
            // SizedBox(
            //   height: 25,
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     ElevatedButton(style : ElevatedButton.styleFrom(
            //       minimumSize: Size.zero,
            //       padding: EdgeInsets.fromLTRB(7, 7, 7, 7),
            //       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //     ), onPressed : (){}, child: const Icon(Icons.tune)),
            //     ElevatedButton(style : ElevatedButton.styleFrom(
            //       minimumSize: Size.zero,
            //       padding: EdgeInsets.fromLTRB(15, 7, 10, 7),
            //       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //     ), onPressed : (){},
            //         child: Row(
            //       children: [
            //         const Text('Sort'), Icon(Icons.expand_more),
            //       ],
            //     )),
            //     ElevatedButton(style : ElevatedButton.styleFrom(
            //       minimumSize: Size.zero,
            //       padding: EdgeInsets.fromLTRB(15, 7, 15, 7),
            //       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //     ), onPressed : (){}, child: const Text('Open Now')),
            //     ElevatedButton(style : ElevatedButton.styleFrom(
            //       minimumSize: Size.zero,
            //       padding: EdgeInsets.fromLTRB(15, 7, 10, 7),
            //       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //     ), onPressed : (){}, child: Row(
            //       children: [
            //         const Text('Price'), Icon(Icons.expand_more),
            //       ],
            //     )),
            //     ElevatedButton(style : ElevatedButton.styleFrom(
            //       minimumSize: Size.zero,
            //       padding: EdgeInsets.fromLTRB(15, 7, 15, 7),
            //       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //     ), onPressed : (){}, child: const Text('Wi-Fi')),
            //   ],
            // ),

            // 3. 카페 이미지 + 정보
            SizedBox(height: 25,),
            Expanded(
              child: ListView.builder(
                  itemCount: cafes.length,
                  itemBuilder: (BuildContext context, int i){
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => InfoScreen(cafes[i].name!)));
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20.0),
                        child: Column(
                          children: [
                            Stack(
                                children : [
                                  const Image( // 카페 이미지 : cafe/image
                                      image: AssetImage(
                                          'assets/cafe1.png'
                                      ),
                                      width: 380
                                  ),
                                  Positioned(
                                    bottom: 117,
                                    right: 153,
                                    child: const Image(
                                        image: AssetImage(
                                            'assets/starMark.png'
                                        ),
                                        width: 380
                                    ),
                                  ),
                                  // Positioned(
                                  //   bottom: 9,
                                  //   right: 176,
                                  //   child: const Image(
                                  //       image: AssetImage(
                                  //           'assets/star.png'
                                  //       ),
                                  //       width: 380
                                  //   ),
                                  // ),
                                  Positioned(
                                    top: 26,
                                    left: 6,
                                    child: Image.asset('assets/${cafes[i].congestion!}.png', width: 10, height: 10,),
                                  ),
                                  // Positioned(  // 별점 정보 : cafe/rating
                                  //   bottom: 176,
                                  //   left: 25,
                                  //   child: Text(cafes[i].rating!, style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),),
                                  // ),
                                  Positioned(  // 혼잡도 정보 : cafe/congestion
                                    bottom: 177,
                                    left: 20,
                                    child: Text(cafes[i].congestion!, style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w500),),
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
                                      Column( // 이름, 위치 정보 : cafe/name
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(cafes[i].name!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
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
                                      ElevatedButton( // checkin 버튼 나중에 구현
                                          style : ElevatedButton.styleFrom(
                                              minimumSize: Size(60, 30)),
                                          onPressed: (){}, child: Text('Check In')),
                                    ],
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
                                      Text('+ ${cafes[i].amenNum!} More', style: TextStyle(color: Colors.grey),),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
