import 'package:flutter/material.dart';
import 'fab_with_icons.dart';
import 'layout.dart';

class ExploreButton extends StatelessWidget {
  ExploreButton({Key? key}) : super(key: key);

  final icons = [Icons.school, Icons.local_cafe, Icons.cast_for_education, Icons.book, Icons.bed];

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
              print("Icon tapped: ${icons[index]}");
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
