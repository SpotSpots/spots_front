import 'package:flutter/cupertino.dart';

class RecentSearches with ChangeNotifier {
  List<String> searchList = [];

  addSearchKeyword(String keyword){
    searchList.insert(0, keyword);
    notifyListeners();
  }
}