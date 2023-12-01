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
      backgroundColor: Color(0xFFD5EAF7),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFFD5EAF7),
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
            child: Text(
              'drag and drop to groups',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),


      body: Column(
        children: [

          // 1. Collection horizontal view
          const SizedBox(height: 20,),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Collections',
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
                if (index == 0) {
                  return Container(
                    width: 120,
                    height: 150,
                    margin: EdgeInsets.only(right: 8),
                    child: Column(
                      children: [
                        Card(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: Container(
                              width: 120,
                              height: 120,
                              child: const Center(
                                child: Text(
                                  '+',
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  // Regular treatment for the other containers
                  return Container(
                    width: 120,
                    height: 150,
                    margin: EdgeInsets.only(right: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: Container(
                              width: 120,
                              height: 120,
                              child: Image.asset(
                                'assets/cafe1.png',
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                        ),
                        const Text(
                          'Fev cafes in OC',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          'saved',
                          style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            ),

          // 2. Saved Spots (46) view
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Saved Spots ()',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 10,),
          Flexible(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                //crossAxisSpacing: 6.0, // 아이템 간의 가로 간격
                mainAxisSpacing: 8.0, // 아이템 간의 세로 간격
              ),
              itemCount: 6,
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
                      const Text(
                        'Costa Mesa, CA',
                        style: TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold),
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