import 'package:flutter/material.dart';

class Building {
  final String name;
  final List<String> studySpots;
  final VoidCallback? onTap;

  Building({required this.name, required this.studySpots, this.onTap});
}

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Explore'),
      ),
      body: Column(
        children: [
          // 위 절반: 이미지
          Expanded(
            child: Image.asset(
              'assets/cau.png',
              fit: BoxFit.cover,
            ),
          ),
          // 아래 절반: 건물 리스트
          Expanded(
            child: MyBuildingList(),
          ),
        ],
      ),
    );
  }
}

class MyBuildingList extends StatefulWidget {
  @override
  State<MyBuildingList> createState() => _MyBuildingListState();
}

class _MyBuildingListState extends State<MyBuildingList> {
  Building? selectedBuilding;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: buildings.length,
      itemBuilder: (context, index) {
        return MyBuildingCard(
          building: buildings[index],
            onTap: () {
              setState(() {
                selectedBuilding = buildings[index];
              });
            },
            isSelected: buildings[index] == selectedBuilding,
        );
      },
    );
  }
}

class MyBuildingCard extends StatelessWidget {
  final Building building;
  final VoidCallback? onTap;
  final bool isSelected;

  MyBuildingCard({required this.building, this.onTap, required this.isSelected,});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(building.name),
            onTap: () {
              onTap?.call();
            },
          ),
          // 선택한 건물이라면 스터디 스팟을 나타냅니다.
          if (isSelected)
            Column(
              children: building.studySpots
                  .map((spot) => Card(
                color: Colors.yellow, // study spot의 배경 색을 노란색으로 지정
                child: ListTile(
                  title: Text(spot),
                ),
              ))
                  .toList(),
            ),
        ],
      ),
    );
  }
}

class ExploreBuildingDetails extends StatelessWidget {
  final Building building;

  ExploreBuildingDetails({required this.building});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: building.studySpots.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(building.studySpots[index]),
          ),
        );
      },
    );
  }
}

List<Building> buildings = [
  Building(
    name: '207관',
    studySpots: ['4층 공학 도서관'],
    onTap: () {
      print('207 clicked!');
    },
  ),
  Building(
    name: '208관',
    studySpots: ['4층 PC실', '5층 PC실', '6층 PC실'],
    onTap: () {
      print('208 clicked!');
    },
  ),
  Building(
    name: '310관',
    studySpots: ['B3층 뚜레쥬르', '1층 커피니', '3층 라운지', '4층 라운지'],
    onTap: () {
      print('310 clicked!');
    },
  ),
  Building(
    name: '308관 블루미르홀',
    studySpots: ['1층 스터디룸', '1층 라운지'],
    onTap: () {
      print('308 clicked!');
    },
  ),
  Building(
    name: '309관 블루미르홀',
    studySpots: ['2층 라운지'],
    onTap: () {
      print('309 clicked!');
    },
  ),
];
