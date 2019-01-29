/*
 * protocol_main_page.dart
 * flutter_panda_appkit
 *
 * Developed by zhudelun on 1/29/19 10:12 PM
 * Copyright (c) 2019. Farfetch. All rights reserved.
 */

import 'package:flutter/widgets.dart';

import 'protocol_tab_bar_item.dart';

abstract class MainPageProtocol {
  Widget navigatorHeaderView(BuildContext context);
  List<Widget> navigatorLeftButtons(BuildContext context);
  List<Widget> navigatorRightButtons(BuildContext context);
  TabBarItemProtocol tabBarItem(BuildContext context);
}
