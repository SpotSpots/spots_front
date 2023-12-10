import 'package:flutter/material.dart';
import 'TabItem.dart';
import 'fab_bottom_app_bar.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key, required this.currentTab, required this.onSelectTab});
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return FABBottomAppBar(
      centerItemText: 'Explore',
      color: Colors.blue,
      selectedColor: Colors.red,
      notchedShape: CircularNotchedRectangle(),
      onTabSelected: (index) => onSelectTab(
        TabItem.values[index],
      ),
      items: [
        FABBottomAppBarItem(iconData: Icons.home, text: 'Home'),
        FABBottomAppBarItem(iconData: Icons.favorite, text: 'Saved'),
        FABBottomAppBarItem(iconData: Icons.chat_bubble, text: 'Activity'),
        FABBottomAppBarItem(iconData: Icons.person, text: 'Profile'),
      ],
      backgroundColor: Colors.white,
      currentIndex: currentTab.index,
    );
  }
}
