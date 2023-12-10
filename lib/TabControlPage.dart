import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'SavedPage.dart';
import 'TabItem.dart';
import 'CustomBottomNavigationBar.dart';
import 'ExploreButton.dart';

Map<TabItem, Widget> tabPages = {
  TabItem.home: const HomePage(),
  TabItem.saved: const SavedPage(),
};

class TabControlPage extends StatefulWidget {
  const TabControlPage({super.key});

  @override
  State<TabControlPage> createState() => _TabControlPageState();
}

class _TabControlPageState extends State<TabControlPage> {
  var _currentTab = TabItem.home;

  final _navigatorKeys = {
    TabItem.home: GlobalKey<NavigatorState>(),
    TabItem.saved: GlobalKey<NavigatorState>(),
    TabItem.explore: GlobalKey<NavigatorState>(),
  };

  void _selectTab(TabItem tabItem) {
    if (tabItem != _currentTab) {
      setState(() => _currentTab = tabItem);
    }
    else {
      _navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildOffstageNavigator(TabItem.home),
          _buildOffstageNavigator(TabItem.saved),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentTab: _currentTab,
        onSelectTab: _selectTab,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ExploreButton(),
    );
  }

  Widget _buildOffstageNavigator(TabItem tabItem) {
    return Offstage(
        offstage: _currentTab != tabItem,
        child: TabNavigator(
          navigatorKey: _navigatorKeys[tabItem],
          tabItem: tabItem,
        ));
  }
}

class TabNavigatorRoutes {
  static const String root = '/';
}

class TabNavigator extends StatelessWidget {
  TabNavigator({required this.navigatorKey, required this.tabItem});
  final GlobalKey<NavigatorState>? navigatorKey;
  final TabItem tabItem;

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    return {
      TabNavigatorRoutes.root: (context) => tabPages[tabItem]!,
    };
  }

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders(context);
    return Navigator(
      key: navigatorKey,
      initialRoute: TabNavigatorRoutes.root,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => routeBuilders[routeSettings.name!]!(context),
        );
      },
    );
  }
}
