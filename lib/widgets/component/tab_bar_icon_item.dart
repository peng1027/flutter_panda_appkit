/*
 * tab_bar_icon_item.dart
 * flutter_panda_appkit
 *
 * Developed by zhudelun on 1/29/19 10:12 PM
 * Copyright (c) 2019. Farfetch. All rights reserved.
 */

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
