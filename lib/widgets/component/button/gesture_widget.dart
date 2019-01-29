/*
 * gesture_widget.dart
 * flutter_panda_appkit
 *
 * Developed by zhudelun on 1/29/19 10:12 PM
 * Copyright (c) 2019. Farfetch. All rights reserved.
 */

import 'package:flutter/widgets.dart';

class GestureHolder {
  static Widget bindGestureEvent(Widget holder, GestureTapCallback onTapCallback) {
    return GestureDetector(child: holder, onTap: onTapCallback);
  }
}
