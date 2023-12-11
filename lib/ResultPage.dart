import 'package:flutter/material.dart';
import 'package:spotsfront/InfoScreen.dart';
import 'CafeService.dart';

class ResultPage extends StatefulWidget {
  const ResultPage(
      {super.key,
    required this.searchKeyword, required this.cafeQuery});

  final String searchKeyword;
  final Future<List<Cafe>> cafeQuery;

  @override
  State<ResultPage> createState() => _ResultPageState();
}


class _ResultPageState extends State<ResultPage> {

  @override
  void initState(){
    super.initState();
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
                                                icon: Icon(Icons.favorite_border, color: Colors.red, size: 20,),
                                                onPressed: () {},
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
                                                    onPressed: (){}, child: Text('Check In')),
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
