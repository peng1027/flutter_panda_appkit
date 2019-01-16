import 'package:flutter/material.dart';
import 'package:flutter_panda_foundation/flutter_panda_foundation.dart';

import '../border_style.dart';

enum ButtonType { primary, secondary, tertiary, flat }

enum ButtonLayout { fluid, block }

enum ButtonIconAlign { left, right }

class Button extends StatelessWidget {
  final String title;
  final Widget icon;
  final Widget accessoryIcon;
  final double fontSize;
  final EdgeInsets contentEdgetInsets;
  final ButtonStyle style;
  final bool inverted;
  final ButtonLayout layout;
  final ButtonIconAlign iconAlign;
  final GestureTapCallback onPressed;

  Button({
    Key key,
    this.title,
    this.icon,
    this.accessoryIcon,
    this.fontSize = 15.0,
    @required this.onPressed,
    this.layout = ButtonLayout.fluid,
    this.iconAlign = ButtonIconAlign.right,
    this.contentEdgetInsets = const EdgeInsets.fromLTRB(Spacing.s, Spacing.s, Spacing.s, Spacing.s),
    this.style = ButtonStyle.defaultStyle,
    this.inverted = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget iconLayer;
    if (this.icon != null || this.accessoryIcon != null) {
      List<Widget> children = List<Widget>();
      if (this.icon != null) children.add(this.icon);
      children.add(Spacer());
      if (null != this.accessoryIcon) children.add(this.accessoryIcon);
      if (children.isNotEmpty) {
        iconLayer = Row(
          children: children,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        );
      }
    } else {
      iconLayer = Container();
    }

    Widget titleLayer;
    if (this.title != null && this.title.isNotEmpty) {
      List<Widget> titleList = List<Widget>();
      titleList.add(SizedBox(width: 20));

      titleList.add(Expanded(
        child: Container(
          child: Text(
            this.title,
            style: TextStyle(fontSize: this.fontSize, fontWeight: FontWeight.w500, color: this.style.textColor()),
            textAlign: this.style.textAlign(),
          ),
        ),
      ));
      titleList.add(SizedBox(width: 20));
      titleLayer = Row(children: titleList, mainAxisAlignment: MainAxisAlignment.center);
    } else {
      titleLayer = Container();
    }

    return RawMaterialButton(
      padding: this.contentEdgetInsets,
      shape: BoarderStyleBuilder.borderBuilder(borderColor: style.borderColor()),
      child: Stack(
        alignment: const FractionalOffset(0.5, 0.5),
        children: [iconLayer, titleLayer],
      ),
      fillColor: this.style.backgroundColor(),
      highlightColor: this.style.highlightColor(),
      animationDuration: Duration(milliseconds: 40),
      onPressed: this.onPressed,
      elevation: 0,
      highlightElevation: 0,
      disabledElevation: 0.0,
    );
  }
}

class ButtonStyle {
  final ButtonType type;
  final ButtonLayout layout;

  final Color colorText;
  final TextAlign alignText;
  final Color colorBackground;
  final Color colorHighlight;
  final Color colorBorder;
  final double widthBorder;

  const ButtonStyle({
    this.layout = ButtonLayout.fluid,
    this.type,
    this.colorText,
    this.alignText,
    this.colorBackground,
    this.colorHighlight,
    this.colorBorder,
    this.widthBorder,
  });

  static const ButtonStyle defaultStyle = const ButtonStyle(
    type: ButtonType.primary,
    layout: ButtonLayout.fluid,
  );

  // constants
  static const double _buttonBorderWidth = 1.0;
  static const double _tertiaryBorderColorAlpha = 0.1;

  ButtonStyle copyWith({
    ButtonType type,
    ButtonLayout layout,
    Color textColor,
    TextAlign alignText,
    Color colorBackground,
    Color colorHighlight,
    Color colorBorder,
    double widthBorder,
  }) {
    return ButtonStyle(
      type: type ?? this.type,
      layout: layout ?? this.layout,
      colorText: textColor ?? this.colorText,
      alignText: alignText ?? this.alignText,
      colorBackground: colorBackground ?? this.colorBackground,
      colorHighlight: colorHighlight ?? this.colorHighlight,
      colorBorder: colorBorder ?? this.colorBorder,
      widthBorder: widthBorder ?? this.widthBorder,
    );
  }

  Color textColor({bool inverted = false}) {
    if (null != colorText) return colorText;

    switch (this.type) {
      case ButtonType.primary:
        return inverted ? Colours.dark : Colours.white;

      case ButtonType.secondary:
        return Colours.dark;

      case ButtonType.tertiary:
        return inverted ? Colours.white : Colours.dark;

      case ButtonType.flat:
        return inverted ? Colours.white : Colours.dark;

      default:
        return Colours.dark;
    }
  }

  TextAlign textAlign() {
    if (null != alignText) return alignText;

    if (this.layout == ButtonLayout.fluid) {
      return TextAlign.center;
    } else if (this.layout == ButtonLayout.block) {
      return TextAlign.start;
    } else {
      return TextAlign.start;
    }
  }

  Color backgroundColor({bool inverted = false}) {
    if (null != colorBackground) return colorBackground;

    switch (this.type) {
      case ButtonType.primary:
        return inverted ? Colours.white : Colours.dark;

      case ButtonType.secondary:
        return Colours.grey;

      case ButtonType.tertiary:
      case ButtonType.flat:
        return inverted ? Colours.grey : Colours.white;

      default:
        return Colours.white;
    }
  }

  Color highlightColor() {
    if (null != colorHighlight) return colorHighlight;

    if (this.type == ButtonType.secondary)
      return Colours.white.withAlpha(128);
    else
      return this.backgroundColor(inverted: true).withAlpha(128);
  }

  Color borderColor({bool inverted = false}) {
    if (null != colorBorder) return colorBorder;

    switch (this.type) {
      case ButtonType.primary:
      case ButtonType.secondary:
      case ButtonType.flat:
        return Colours.clear;

      case ButtonType.tertiary:
        return inverted ? Colours.white.withAlpha((_tertiaryBorderColorAlpha * 255).toInt()) : Colours.dark.withAlpha((_tertiaryBorderColorAlpha * 255).toInt());

      default:
        return Colours.clear;
    }
  }

  double borderWidth() {
    if (null != widthBorder) return widthBorder;
    switch (this.type) {
      case ButtonType.primary:
      case ButtonType.secondary:
      case ButtonType.flat:
        return 0.0;

      case ButtonType.tertiary:
        return _buttonBorderWidth;

      default:
        return 0.0;
    }
  }
}
