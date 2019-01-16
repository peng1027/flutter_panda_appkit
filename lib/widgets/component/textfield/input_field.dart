import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_panda_foundation/flutter_panda_foundation.dart';

import '../../component/textfield/input_field_interface.dart';

class InputField extends StatefulWidget {
  final String text;
  final String hintText;
  final int maxLength;
  final TextStyle textStyle;
  final TextStyle hintStyle;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String placeHolderText;
  final Widget prefixView;
  final Widget suffixView;
  final Widget hintView;
  final bool obscureMode;
  final OnTextDidChanged onTextDidChanged;
  final OnTextEndEditing onTextEndEditing;
  final ShouldChangeText shouldChangeText;
  final StateOfChangedText stateOfChangedText;

  InputFieldState inputState;

  Image _iconCorrect = ImageInAssets(name: Images.validation_tick).image();
  Image _iconWrong = ImageInAssets(name: Images.error_exclaimation_mark).image(color: Colours.red);

  InputField({
    Key key,
    this.placeHolderText = "",
    this.text = "",
    this.textStyle,
    this.hintText,
    this.hintStyle,
    this.prefixView,
    this.suffixView,
    this.hintView,
    this.obscureMode = false,
    this.maxLength = -1,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.inputState = InputFieldState.normal,
    @required this.onTextDidChanged,
    @required this.onTextEndEditing,
    @required this.shouldChangeText,
    @required this.stateOfChangedText,
  }) : super(key: key);

  @override
  _InputFieldState createState() => _InputFieldState(new TextEditingController(text: text));
}

class _InputFieldState extends State<InputField> {
  final TextEditingController _controller;
  String _oldValue = "";
  FocusNode _focus;

  _InputFieldState(this._controller) : super();

  TextStyle get _defaultTextStyle => this.widget.textStyle ?? PandaTextStyle.sfui.copyWith(color: Colours.dark, fontSize: 18, fontWeight: FontWeight.w500);
  TextStyle get _mainTextStyle => _defaultTextStyle.copyWith();
  TextStyle get _labelTextStyle =>
      _defaultTextStyle.copyWith(color: ((_defaultTextStyle.color != null) ? _defaultTextStyle.color.withAlpha(200) : Colours.darkGrey), fontSize: 14, fontWeight: FontWeight.w500);
  TextStyle get _hintTextStyle => this.widget.hintStyle ?? _defaultTextStyle.copyWith(color: ((_defaultTextStyle.color != null) ? _defaultTextStyle.color.withAlpha(200) : Colours.darkGrey));

  @override
  void initState() {
    this._focus = FocusNode();
    this._controller.addListener(_textFieldWatcher);
    this._controller.text = this.widget.text;
    super.initState();
  }

  @override
  void dispose() {
    this._controller.dispose();
    super.dispose();
  }

  void _textFieldWatcher() {
    String newValue = this._controller.text;
    if (newValue == _oldValue) {
      return;
    }

    if (this.widget.shouldChangeText != null && false == this.widget.shouldChangeText(newValue)) {
      this._controller.text = this._oldValue;
      this._controller.selection = TextSelection(baseOffset: this._oldValue.length, extentOffset: this._oldValue.length);
      return;
    }

    if (this.widget.onTextDidChanged != null) {
      this.widget.onTextDidChanged(newValue);
    }
    _oldValue = newValue;

    if (null != this.widget.stateOfChangedText) {
      var newState = this.widget.stateOfChangedText(newValue);
      if (newState != this.widget.inputState) {
        setState(() {
          this.widget.inputState = newState;
        });
      }
    }
  }

  void _textFieldDidEndEditing(BuildContext context, String value) {
    if (this.widget.shouldChangeText != null && true == this.widget.shouldChangeText(value)) {
      this._oldValue = value;
    }

    if (this.widget.onTextEndEditing != null) {
      this.widget.onTextEndEditing(value);
    }
    FocusScope.of(context).requestFocus(FocusNode());
  }

  InputDecoration _defaultInputDecoration({Color enableBorderColor, Color focusBorderColor}) => InputDecoration(
        hintStyle: this._hintTextStyle,
        hintText: this.widget.hintText,
//        labelText: this.widget.hintText,
//        labelStyle: this._labelTextStyle,
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(width: Spacing.xxxxs, color: enableBorderColor ?? Colours.grey)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(width: Spacing.xxxs, color: focusBorderColor ?? Colours.darkGrey)),
      );

  InputDecoration _inputDecoration() {
    List<Widget> prefixIcon = List<Widget>();
    List<Widget> suffixIcon = List<Widget>();

    bool error = this.widget.inputState == InputFieldState.wrong;
    bool normal = this.widget.inputState == InputFieldState.normal;

    if (this.widget.prefixView != null) {
      prefixIcon.add(this.widget.prefixView);
    }

    if (this.widget.suffixView != null) {
      suffixIcon.add(this.widget.suffixView);
    } else {
      if (false == normal) {
        suffixIcon.add(error ? this.widget._iconWrong : this.widget._iconCorrect);
      }
    }

    Color color = error ? Colours.red : Colours.dark;

    if (prefixIcon.length != 0 && suffixIcon.length != 0) {
      return _defaultInputDecoration(focusBorderColor: color).copyWith(
        prefixIcon: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.start,
          runAlignment: WrapAlignment.center,
          children: prefixIcon,
        ),
        suffixIcon: Wrap(
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          children: suffixIcon,
        ),
      );
    } else if (prefixIcon.length != 0) {
      return _defaultInputDecoration(focusBorderColor: color).copyWith(
        prefixIcon: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.start,
          runAlignment: WrapAlignment.center,
          children: prefixIcon,
        ),
      );
    } else if (suffixIcon.length != 0) {
      return _defaultInputDecoration(focusBorderColor: color).copyWith(
        suffixIcon: Wrap(
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          children: suffixIcon,
        ),
      );
    } else {
      return _defaultInputDecoration(focusBorderColor: color);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (this.widget.inputState == InputFieldState.wrong) {
      return Container(
        child: Column(
          children: <Widget>[
            TextField(
              focusNode: this._focus,
              style: this.widget.textStyle,
              controller: this._controller,
              keyboardType: this.widget.keyboardType,
              textInputAction: this.widget.textInputAction,
              onEditingComplete: () => _textFieldDidEndEditing(context, this._oldValue),
              onSubmitted: (value) => _textFieldDidEndEditing(context, value),
              obscureText: this.widget.obscureMode,
              decoration: _inputDecoration(),
            ),
            Container(
              padding: EdgeInsets.only(top: Spacing.xxxs),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  this.widget.hintView ?? SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        child: TextField(
          focusNode: this._focus,
          style: this.widget.textStyle,
          controller: this._controller,
          keyboardType: this.widget.keyboardType,
          textInputAction: this.widget.textInputAction,
          onEditingComplete: () => _textFieldDidEndEditing(context, this._oldValue),
          onSubmitted: (value) => _textFieldDidEndEditing(context, value),
          obscureText: this.widget.obscureMode,
          decoration: _inputDecoration(),
        ),
      );
    }
  }
}
