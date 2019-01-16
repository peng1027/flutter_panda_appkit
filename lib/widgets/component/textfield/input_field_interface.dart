enum InputFieldState {
  normal,
  correct,
  wrong,
}

typedef OnTextDidChanged = void Function(String newValue);
typedef OnTextEndEditing = void Function(String newValue);
typedef ShouldChangeText = bool Function(String newValue);
typedef StateOfChangedText = InputFieldState Function(String newValue);
