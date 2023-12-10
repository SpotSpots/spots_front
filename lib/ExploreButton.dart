import 'package:flutter/material.dart';
import 'fab_with_icons.dart';
import 'layout.dart';

class ExploreButton extends StatelessWidget {
  ExploreButton({super.key});

  final icons = [ Icons.school, Icons.local_cafe, Icons.more];

  @override
  Widget build(BuildContext context) {
    return AnchoredOverlay(
      showOverlay: true,
      overlayBuilder: (context, offset) {
        return CenterAbout(
          position: Offset(offset.dx, offset.dy - icons.length * 35.0),
          child: FabWithIcons(
            icons: icons,
            onIconTapped: (int value) {  },
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
