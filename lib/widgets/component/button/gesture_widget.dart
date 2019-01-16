import 'package:flutter/widgets.dart';

class GestureHolder {
  static Widget bindGestureEvent(Widget holder, GestureTapCallback onTapCallback) {
    return GestureDetector(child: holder, onTap: onTapCallback);
  }
}
