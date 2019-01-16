import 'package:flutter/material.dart';

import 'button.dart';

class ButtonFactory {
  static Button primaryButton(BuildContext context, String title, VoidCallback onPressed) => Button(
        title: title,
        onPressed: onPressed,
      );

  static Button secondaryButton(BuildContext context, String title, VoidCallback onPressed) => Button(
        title: title,
        onPressed: onPressed,
        style: ButtonStyle(type: ButtonType.secondary),
      );

  static Button tertiaryButton(BuildContext context, String title, VoidCallback onPressed) => Button(
        title: title,
        onPressed: onPressed,
        style: ButtonStyle(type: ButtonType.tertiary),
      );

  static Button flatButton(BuildContext context, String title, VoidCallback onPressed) => Button(
        title: title,
        onPressed: onPressed,
        style: ButtonStyle(type: ButtonType.flat),
      );
}
