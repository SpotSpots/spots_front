import 'package:flutter/material.dart';
import 'fab_with_icons.dart';
import 'layout.dart';
import 'ResultPage.dart';
import 'CafeService.dart';

class ExploreButton extends StatelessWidget {
  ExploreButton({Key? key}) : super(key: key);

  final icons = [Icons.electric_bolt, Icons.computer, Icons.person, Icons.people, Icons.apartment];

  @override
  Widget build(BuildContext context) {
    return AnchoredOverlay(
      showOverlay: true,
      overlayBuilder: (context, offset) {
        return CenterAbout(
          position: Offset(offset.dx, offset.dy - icons.length * 35.0),
          child: FabWithIcons(
            icons: icons,
            onIconTapped: (int index) {
              //(승표) SUPER HARD CODING
              if(index == 0)
              {
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ResultPage(searchKeyword: '207', cafeQuery: CafeService().getCafesBySearchKeyword('207'))));
              }
              else if (index == 1)
              {
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ResultPage(searchKeyword: '208', cafeQuery: CafeService().getCafesBySearchKeyword('208'))));
              }
              else if(index == 2)
              {
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ResultPage(searchKeyword: '308', cafeQuery: CafeService().getCafesBySearchKeyword('308'))));
              }
              else if(index == 3)
              {
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ResultPage(searchKeyword: '309', cafeQuery: CafeService().getCafesBySearchKeyword('309'))));
              }
              else if(index == 4)
              {
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ResultPage(searchKeyword: '310', cafeQuery: CafeService().getCafesBySearchKeyword('310'))));
              }
            },
          ),
        );
      },
      child: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.explore),
        elevation: 2.0,
        shape: CircleBorder(),
      ),
    );
  }
}
