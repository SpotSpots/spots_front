import 'package:flutter/material.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({Key? key}) : super(key: key);

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE9E9E9),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent, // 고정 색상 지정
        // backgroundColor: Color(0xffE9E9E9),
        title: Text('Saved', style: TextStyle(fontWeight: FontWeight.bold),),
        leading: IconButton(
          icon: Icon(Icons.navigate_before, size: 28,),
          onPressed: () {
            print("navigage_before icon clicked");
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_horiz),
            onPressed: () {
              print("more_horiz icon clicked");
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(20.0),
          child: Container(
            //padding: EdgeInsets.all(8.0),
            alignment: Alignment.center,
            // child: Text(
            //   'drag and drop to groups',
            //   style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            // ),
          ),
        ),
      ),


      body: Column(
        children: [
          // 1. Cafe Spots
          const SizedBox(height: 20,),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Cafe Spots',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 10,),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal, // 가로로 스크롤 해서 collections 확인
              itemCount: 4,
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                return Container(
                  width: 150,
                  height: 210,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Card(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                              ),
                              width: 150,
                              height: 150,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: Image.asset(
                                  'assets/cafe1.png',
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: IconButton(
                                icon: Icon(Icons.favorite, color: Colors.pink),
                                onPressed: () {
                                  print('heart button clicked');
                                },
                                iconSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        'Fev cafes in OC',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // 2. Study Spots
          const SizedBox(height: 20,),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Study Spots',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 10,),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal, // 가로로 스크롤 해서 collections 확인
              itemCount: 4,
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                return Container(
                  width: 150,
                  height: 210,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Card(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                              ),
                              width: 150,
                              height: 150,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: Image.asset(
                                  'assets/cafe1.png',
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: IconButton(
                                icon: Icon(Icons.favorite, color: Colors.pink),
                                onPressed: () {
                                  print('heart button clicked');
                                },
                                iconSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        'Fev cafes in OC',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}