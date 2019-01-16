import 'package:flutter/material.dart';
import 'package:flutter_panda_foundation/flutter_panda_foundation.dart';

import '../protocols/protocol_tab_bar_item.dart';

class TabBarIconItem implements TabBarItemProtocol {
  final BottomNavigationBarItem item;

  TabBarIconItem({String title, Widget icon, Widget activeIcon})
      : item = BottomNavigationBarItem(
          title: Text(
            title,
            style: PandaTextStyle.sfui.copyWith(fontSize: 15, fontWeight: FontWeight.w300),
          ),
          icon: icon,
          activeIcon: activeIcon,
          backgroundColor: Colours.white,
        );
}
