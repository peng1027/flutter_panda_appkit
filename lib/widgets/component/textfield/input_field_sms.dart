/*
 * input_field_sms.dart
 * flutter_panda_appkit
 *
 * Developed by zhudelun on 1/29/19 10:12 PM
 * Copyright (c) 2019. Farfetch. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_panda_foundation/flutter_panda_foundation.dart';

import 'input_field_interface.dart';

class InputFieldSMS extends StatefulWidget {
  final String text;
  final Widget hintView;
  final int maxLength;
  final Color normalColor;
  final Color focusColor;
  final Color errorColor;
  final ShouldChangeText shouldChangeText;
  final OnTextDidChanged onTextDidChanged;
  final OnTextEndEditing onTextEndEditing;
  final StateOfChangedText stateOfChangedText;

  TextEditingController _controller = TextEditingController();
  String _preValue = "";
  InputFieldState _inputState;

  InputFieldSMS({
    Key key,
    this.maxLength = 6,
    this.text = "",
    this.hintView,
    @required this.shouldChangeText,
    @required this.onTextDidChanged,
    @required this.onTextEndEditing,
    @required this.stateOfChangedText,
    this.normalColor = Colours.grey,
    this.focusColor = Colours.dark,
    this.errorColor = Colours.red,
  }) : super(key: key);

  @override
  _InputFieldSMSState createState() => _InputFieldSMSState();
}

class _InputFieldSMSState extends State<InputFieldSMS> {
  List<String> _allSMSCode = List<String>();
  FocusNode _focusNode;
  bool _inEditing = false;

  @override
  void initState() {
    this._focusNode = FocusNode();
    this._allSMSCode = List<String>(this.widget.maxLength);
    for (int idx = 0; idx < this.widget.maxLength; ++idx) {
      if (idx < this.widget.text.length) {
        this._allSMSCode[idx] = this.widget.text[idx];
      } else {
        this._allSMSCode[idx] = "";
      }
    }

    this.widget._controller.addListener(_textFieldWatcher);
    this.widget._controller.text = this.widget.text;

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose()
    this.widget._controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colours.clear,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(fit: StackFit.loose, alignment: AlignmentDirectional.centerStart, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _codeWidgetsList(context),
            ),
            TextField(
              focusNode: this._focusNode,
              controller: this.widget._controller,
              style: TextStyle(color: Colours.clear),
              onEditingComplete: () => _textFieldDidEndEditing(context, this.widget._preValue),
              onSubmitted: (value) => _textFieldDidEndEditing(context, value),
              onTap: () => _textFieldOnTap(),
              keyboardType: TextInputType.number,
              cursorColor: Colours.clear,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colours.clear)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colours.clear)),
              ),
            ),
          ]),
          SizedBox(height: Spacing.xxxs),
          Opacity(
            opacity: (this.widget._inputState == InputFieldState.wrong ? 1.0 : 0.0),
            child: this.widget.hintView ?? Container(),
          ),
        ],
      ),
    );
  }

  List<Widget> _codeWidgetsList(BuildContext context) {
    const double kGap = Spacing.xxs + Spacing.xxxs;
    List<Widget> fakeInputField = List<Widget>();

    for (int idx = 0; idx < this.widget.maxLength; ++idx) {
      String content = this._allSMSCode[idx] != null ? this._allSMSCode[idx] : "";

      fakeInputField.add(Expanded(
        child: Container(
          padding: EdgeInsets.only(top: kGap, bottom: kGap, right: kGap),
          child: _SMSCodeWidget(
            text: content,
            textColor: this.widget.normalColor,
            normalColor: this.widget.normalColor,
            focusColor: this.widget.focusColor,
            errorColor: this.widget.errorColor,
            error: (this.widget._inputState == InputFieldState.wrong),
            highLight: (this._inEditing && this.widget._preValue.length == idx),
          ),
        ),
      ));
    }

    return fakeInputField;
  }

  void _textFieldWatcher() {
    String newValue = this.widget._controller.text;

    if (_whetherValueAcceptable(newValue) == false) {
      this._justResetToPreValue();
      return;
    }

    if (this.widget._preValue == newValue) return;

    if (this.widget.shouldChangeText != null && ((false == this.widget.shouldChangeText(newValue)) || (newValue.length > this.widget.maxLength))) {
      this._justResetToPreValue();
      return;
    }

    if (null != this.widget.onTextDidChanged) {
      this.widget.onTextDidChanged(newValue);
    }
    this.widget._preValue = newValue;

    this._refulfillEachSMSCode(newValue);

    if (null != this.widget.stateOfChangedText) {
      var newState = this.widget.stateOfChangedText(newValue);
      if (newState != this.widget._inputState && newValue.length == this.widget.maxLength) {
        setState(() {
          this.widget._inputState = newState;
        });
      }
    }
  }

  void _textFieldDidEndEditing(BuildContext context, String value) {
    if (this.widget.shouldChangeText != null && true == this.widget.shouldChangeText(value)) {
      this.widget._preValue = value;
    }

    if (this.widget.onTextEndEditing != null) {
      this.widget.onTextEndEditing(value);
    }

    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      this._inEditing = false;
    });
  }

  void _textFieldOnTap() {
    this._justResetToPreValue();
    this._refulfillEachSMSCode(this.widget._preValue);

    setState(() {
      this._inEditing = true;
    });
  }

  void _refulfillEachSMSCode(String value) {
    if (value.length > this.widget.maxLength) {
      value = value.substring(0, this.widget.maxLength);
    }

    setState(() {
      for (int idx = 0; idx < this.widget.maxLength; ++idx) {
        if (idx < value.length) {
          this._allSMSCode[idx] = value[idx];
        } else {
          this._allSMSCode[idx] = "";
        }
      }
    });
  }

  void _justResetToPreValue() {
    this.widget._controller.text = this.widget._preValue;
    this.widget._controller.selection = TextSelection(
      baseOffset: this.widget._preValue.length,
      extentOffset: this.widget._preValue.length,
    );
  }

  bool _whetherValueAcceptable(String value) {
    RegExp smsReg = RegExp(r"^[0-9]*$");
    Iterable<Match> matches = smsReg.allMatches(value);
    return matches.length > 0;
  }
}

class _SMSCodeWidget extends StatelessWidget {
  final String text;
  final Color textColor;
  final bool highLight;
  final bool error;

  final Color normalColor;
  final Color focusColor;
  final Color errorColor;

  const _SMSCodeWidget({
    Key key,
    this.text = "",
    this.textColor = Colours.dark,
    this.highLight = false,
    this.error = false,
    this.normalColor,
    this.focusColor,
    this.errorColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color curColor = this.normalColor;
    double focusWidth = 1.0;

    if (this.highLight) {
      curColor = this.focusColor;
      focusWidth = 2.0;
    }
    if (this.error) {
      curColor = this.errorColor;
    }

    return Container(
      constraints: BoxConstraints.loose(Size(44, 44)),
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(
          color: curColor,
          width: focusWidth,
        )),
        color: Colours.clear,
      ),
      child: Center(
        child: Stack(children: <Widget>[
          Text(
            this.text,
            style: PandaTextStyle.sfui.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ]),
      ),
    );
  }
}
