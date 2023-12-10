import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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

  Future<void> fetchSpotsByCategory(String category) async {
    final CollectionReference _cafe = FirebaseFirestore.instance.collection('cafe');

    try {
      QuerySnapshot cafeSnapshot = await _cafe.where('category', isEqualTo: category).get();

      if (cafeSnapshot.docs.isNotEmpty) {
        // cafeSnapshot.docs에는 category가 'cafe'인 문서들이 들어있습니다.
        // 여기에서 필요한 작업을 수행하면 됩니다.
        for (QueryDocumentSnapshot documentSnapshot in cafeSnapshot.docs) {
          // documentSnapshot을 이용하여 각 문서의 데이터에 접근할 수 있습니다.
          spotName = documentSnapshot['name'];
          spotDetail = documentSnapshot['detail'];
          // 추가로 필요한 작업 수행
        }
      } else {
        // 해당 카테고리의 데이터가 없을 경우 처리
        print('No cafes found in the selected category');
      }
    } catch (error) {
      print('Error: $error');
    }
  }




  @override
  Widget build(BuildContext context) {
    final CollectionReference _cafe = FirebaseFirestore.instance.collection('cafe');

    // DatabaseReference starCountRef =
    // FirebaseDatabase.instance.ref('posts/$postId/starCount');
    // starCountRef.onValue.listen((DatabaseEvent event) {
    //   final data = event.snapshot.value;
    //   updateStarCount(data);
    // });

    return Scaffold(
      backgroundColor: const Color(0xffE9E9E9),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xffE9E9E9),
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
                  backgroundImage: AssetImage('assets/cafe1.png'),
                ),
                const SizedBox(width: 7),
                Row(
                  children: [
                    const Text(
                      'Hello, ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('$userName!',
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
              icon: const Icon(Icons.more_horiz),
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
                  Container(
                    padding: const EdgeInsets.all(15),
                    height: 195,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Seeking the perfect",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        const Text(
                          "work spot today?",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "Complete the Questionnaire!",
                          style: TextStyle(fontSize: 17),
                        ),
                        const SizedBox(height: 10,),
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: const EdgeInsets.all(10),
                            ),
                            onPressed: () {
                              print('설문 클릭');
                            },
                            child: const Text("Questionnaire"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 임시로 Stack Widget Slider 모양만 만들어 놓음
                  // 설문 위젯 뒤에 무슨 내용의 위젯 넣을 건지??
                  Container(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                          height: 10,
                          width: 10,
                          decoration: const BoxDecoration(
                            color: Colors.deepPurple,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                          height: 10,
                          width: 10,
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                          height: 10,
                          width: 10,
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  // 3. Recommended Spots
                  Container(
                    padding: const EdgeInsets.all(15),
                    width: MediaQuery.of(context).size.width,
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
                        SingleChildScrollView(
                          padding: const EdgeInsets.all(5),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                  minimumSize: Size.zero,
                                  padding: const EdgeInsets.fromLTRB(15, 7, 15, 7),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {
                                  fetchSpotsByCategory('cafe');
                                },
                                child: const Text('Cafes', style: TextStyle(color: Colors.white),),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size.zero,
                                  padding: const EdgeInsets.fromLTRB(15, 7, 15, 7),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {
                                  fetchSpotsByCategory('studyspot');
                                },
                                child: const Text('Study Spots'),
                              ),
                              const SizedBox(width: 10),
                              // ElevatedButton(
                              //   style: ElevatedButton.styleFrom(
                              //     minimumSize: Size.zero,
                              //     padding: const EdgeInsets.fromLTRB(15, 7, 15, 7),
                              //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              //   ),
                              //   onPressed: () {},
                              //   child: const Text('Study Centers'),
                              // ),
                              // const SizedBox(width: 10),
                              // ElevatedButton(
                              //   style: ElevatedButton.styleFrom(
                              //     minimumSize: Size.zero,
                              //     padding: const EdgeInsets.fromLTRB(15, 7, 15, 7),
                              //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              //   ),
                              //   onPressed: () {},
                              //   child: const Text('Outdoors'),
                              // ),
                              // const SizedBox(width: 10),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        // 3-3. 장소 카드 뷰
                    StreamBuilder(
                      stream: _cafe.snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                        if (streamSnapshot.hasData) {
                          return GridView.builder(
                            shrinkWrap: true,
                            itemCount: streamSnapshot.data!.docs.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 5,
                            ),
                            itemBuilder: (context, index) {
                              final DocumentSnapshot documentSnapshot = streamSnapshot.data!
                                  .docs[index];
                              return GestureDetector(
                                onTap: () {
                                  print('카페 이름을 resultPage로 전달하기');
                                },
                                child:
                                Stack(
                                  children: [
                                    // 이미지
                                    Container(
                                      margin: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
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
                                                  documentSnapshot['image'])
                                          )
                                      ),
                                    ),

                                    // 하트
                                    Positioned(
                                      top: 15,
                                      right: 15,
                                      child: Container(
                                        width: 32,
                                        height: 32,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                        child: IconButton(
                                          icon: Icon(Icons.favorite_border, color: Colors.pink),
                                          onPressed: () {
                                            print('heart button clicked');
                                          },
                                          iconSize: 16,
                                        ),
                                      ),
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
                                                bottomRight: Radius.circular(20)),
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
                                                documentSnapshot['name'],
                                                style: const TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.black,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Text(
                                                documentSnapshot['detail'],
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
