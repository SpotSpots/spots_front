import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'SearchPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    @override
    Widget build(BuildContext context) {
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
              child: const Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/cafe1.png'),
                  ),
                  SizedBox(width: 7),
                  Text(
                    'Hello Emma!',
                    style: TextStyle(fontWeight: FontWeight.bold),
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
                        Navigator.push(context, MaterialPageRoute(builder: (
                            context) => const SearchPage()));
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
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Seeking the perfect",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          const Text(
                            "work spot today?",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
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
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
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
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
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
                                    padding: const EdgeInsets.fromLTRB(
                                        15, 7, 15, 7),
                                    tapTargetSize: MaterialTapTargetSize
                                        .shrinkWrap,
                                  ),
                                  onPressed: () {},
                                  child: const Text('Cafes',
                                    style: TextStyle(color: Colors.white),),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size.zero,
                                    padding: const EdgeInsets.fromLTRB(
                                        15, 7, 15, 7),
                                    tapTargetSize: MaterialTapTargetSize
                                        .shrinkWrap,
                                  ),
                                  onPressed: () {},
                                  child: const Text('Libraries'),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size.zero,
                                    padding: const EdgeInsets.fromLTRB(
                                        15, 7, 15, 7),
                                    tapTargetSize: MaterialTapTargetSize
                                        .shrinkWrap,
                                  ),
                                  onPressed: () {},
                                  child: const Text('Study Centers'),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size.zero,
                                    padding: const EdgeInsets.fromLTRB(
                                        15, 7, 15, 7),
                                    tapTargetSize: MaterialTapTargetSize
                                        .shrinkWrap,
                                  ),
                                  onPressed: () {},
                                  child: const Text('Outdoors'),
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),

                          // 3-3. 장소 카드 뷰
                          GridView.builder(
                            shrinkWrap: true,
                            // padding: const EdgeInsets.symmetric(horizontal: 30),
                            itemCount: 4,
                            itemBuilder: (ctx, i) {
                              return Card(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20)),
                                  margin: const EdgeInsets.all(5),
                                  padding: const EdgeInsets.all(5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Expanded(
                                        child: Image.asset('assets/cafe1.png',
                                            fit: BoxFit.fill),
                                      ),
                                      const SizedBox(height: 5),
                                      const Text(
                                        'KRISP Fresh Living',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Text(
                                        '2.4 km',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 8,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.0,
                              crossAxisSpacing: 2,
                              mainAxisSpacing: 5,
                              // mainAxisExtent: 200,
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