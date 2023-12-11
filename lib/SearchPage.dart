import 'package:flutter/material.dart';
import 'ResultPage.dart';
import 'CafeService.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchKeyword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE9E9E9),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xffE9E9E9),
          title: Text('Search', style: TextStyle(fontWeight: FontWeight.bold),),
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
              }
            ),
          ],
        ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: Expanded(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                width: MediaQuery.of(context).size.width,
                height: 54,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 20,
                      offset: Offset(0, 11), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Icon(Icons.search),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        style: TextStyle(fontSize:15),
                        decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            border: InputBorder. none,
                            hintText: 'Search cafe, library, study centers...',
                            hintStyle: TextStyle(color: Colors.grey)
                        ),
                        onChanged: (value){
                          setState(() {
                            searchKeyword = value;
                          });
                        },
                        onSubmitted: (value) {
                          Navigator.push(context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ResultPage(searchKeyword: searchKeyword, cafeQuery: CafeService().getCafesBySearchKeyword(searchKeyword))));
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 20,
                  shadowColor: Colors.grey.withOpacity(0.5),
                  backgroundColor: Colors.white,
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.fromLTRB(10, 15, 0, 15),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ResultPage(searchKeyword: 'Current Location', cafeQuery: CafeService().getAllCafes()),));
                },
                child: const Row(
                  children: [
                    Icon(Icons.location_on),
                    SizedBox(width: 10),
                    Text(
                      'Current Location',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15,15,0,0),
                        child: const Text(
                          "Recent Searches",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Expanded(
                        child: ListView(
                            scrollDirection: Axis.vertical,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.search),
                                title: const Text('310'),
                                onTap: (){},
                              ),
                              ListTile(
                                leading: const Icon(Icons.search),
                                title: const Text('208'),
                                onTap: (){},
                              ),
                            ]
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
