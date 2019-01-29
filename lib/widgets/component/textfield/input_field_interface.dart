/*
 * input_field_interface.dart
 * flutter_panda_appkit
 *
 * Developed by zhudelun on 1/29/19 10:12 PM
 * Copyright (c) 2019. Farfetch. All rights reserved.
 */

enum InputFieldState {
  normal,
  correct,
  wrong,
}

typedef OnTextDidChanged = void Function(String newValue);
typedef OnTextEndEditing = void Function(String newValue);
typedef ShouldChangeText = bool Function(String newValue);
typedef StateOfChangedText = InputFieldState Function(String newValue);
