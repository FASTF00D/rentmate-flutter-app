import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rive/rive.dart';

import '../../model/menu.dart';

class SideMenuTile extends StatelessWidget {
  const SideMenuTile({
    Key? key, required this.menu, required this.press, required this.riveOnInit, required this.isActive,
  }) : super(key: key);

  final Menu menu;
  final VoidCallback press;
  final ValueChanged<Artboard> riveOnInit;
  final bool isActive;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 24),
          child: Divider(color: Colors.white24,
            height: 2,),
        ),
        ListTile(
          onTap: press,
          leading:  SizedBox(
            height: 34,
            width: 34,
            child: RiveAnimation.asset(
            menu.rive.src,
            artboard: menu.rive.artboard,
            onInit: riveOnInit,
            ),
          ),
          title: Text(
            menu.title
          ),
        ),
      ],
    );
  }
}