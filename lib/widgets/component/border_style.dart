import 'dart:ui';

import 'package:flutter/material.dart';

class BoarderStyleBuilder {
  static const int topLeft = 1 << 0;
  static const int topRight = 1 << 1;
  static const int bottomLeft = 1 << 2;
  static const int bottomRight = 1 << 3;
  static const int all = topLeft + topRight + bottomLeft + bottomRight;

  static RoundedRectangleBorder borderBuilder({
    Color borderColor,
    double borderWidth = 1.0,
    double cornerRadius = 4.0,
    int cornerStyle = all,
  }) {
    if (borderWidth == 0.0) {
      return RoundedRectangleBorder(side: BorderSide.none);
    } else {
      BorderRadius radius = BorderRadius.all(Radius.circular(cornerRadius));
      if (cornerStyle != all) {
        Radius tl = Radius.zero;
        Radius tr = Radius.zero;
        Radius bl = Radius.zero;
        Radius br = Radius.zero;

        if (cornerStyle & topLeft != 0) tl = Radius.circular(cornerRadius);
        if (cornerStyle & topRight != 0) tr = Radius.circular(cornerRadius);
        if (cornerStyle & bottomLeft != 0) bl = Radius.circular(cornerRadius);
        if (cornerStyle & bottomRight != 0) br = Radius.circular(cornerRadius);

        radius = BorderRadius.only(topLeft: tl, topRight: tr, bottomLeft: bl, bottomRight: br);
      }

      return RoundedRectangleBorder(
        side: BorderSide(
          color: borderColor,
          width: borderWidth,
          style: BorderStyle.solid,
        ),
        borderRadius: radius,
      );
    }
  }
}
