import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:intl/intl.dart';

/// A quick example "keyboard" widget for Numeric.
class CharKeyboard extends StatelessWidget
    with KeyboardCustomPanelMixin<String>
    implements PreferredSizeWidget {
  final ValueNotifier<String> notifier;
  final FocusNode focusNode;

  CharKeyboard({
    Key key,
    this.notifier,
    this.focusNode,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(300);

  void _onTapChar(String value) {
    final currentValue = notifier.value;
    final temp = currentValue + value;
    updateValue(temp);
  }

  void _onTapIcon(IconData icon) {
    if (icon == Icons.done) {
      focusNode.unfocus();
      return;
    }
    final currentValue = notifier.value;
    final temp = currentValue.substring(0, currentValue.length > 0 ? currentValue.length - 1 : currentValue.length);
    updateValue(temp);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
//        crossAxisCount: 10,
//        childAspectRatio: 0.8,
//        crossAxisSpacing: 5,
//        mainAxisSpacing: 5,
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildButton(text: "A"),
                _buildButton(text: "B"),
                _buildButton(text: "C"),
                _buildButton(text: "D"),
                _buildButton(text: "E"),
                _buildButton(text: "F"),
                _buildButton(text: "G"),
                _buildButton(text: "H"),
                _buildButton(text: "I"),
                _buildButton(text: "J"),
              ]
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildButton(text: "K"),
                _buildButton(text: "L"),
                _buildButton(text: "M"),
                _buildButton(text: "N"),
                _buildButton(text: "O"),
                _buildButton(text: "P"),
                _buildButton(text: "Q"),
                _buildButton(text: "R"),
                _buildButton(text: "S"),
              ]
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildButton(text: "T"),
                  _buildButton(text: "U"),
                  _buildButton(text: "V"),
                  _buildButton(text: "W"),
                  _buildButton(text: "X"),
                  _buildButton(text: "Y"),
                  _buildButton(text: "Z")
                ],
              ),
              _buildButton(icon: Icons.backspace, color: Colors.black)
            ]
          ),
          Row(
            children: <Widget>[
              _buildButton(text: "123", color: Colors.black),
              Expanded(child: _buildButton(text: " ")),
              _buildButton(icon: Icons.done, color: Colors.black)
            ]
          )
        ]
      )
    );
  }

  Widget _buildButton({
    String text,
    IconData icon,
    Color color,
  }) {
    return NumericButton(
      text: text,
      icon: icon,
      color: color,
      onTap: () => icon != null ? _onTapIcon(icon) : _onTapChar(text),
    );
  }
}

class NumericButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final IconData icon;
  final Color color;

  const NumericButton({
    Key key,
    this.text,
    this.onTap,
    this.icon,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width / 8,
      width: icon != null ? MediaQuery.of(context).size.width / 8 : MediaQuery.of(context).size.width / 10,
      padding: const EdgeInsets.all(4.0),
      child: Material(
        borderRadius: BorderRadius.circular(5.0),
        color: color ?? Colors.white,
        elevation: 5,
        child: InkWell(
          onTap: onTap,
          child: FittedBox(
            child: Padding(
              padding: EdgeInsets.all(icon != null ? 6.0 : 2.0),
              child: icon != null
                  ? Icon(
                icon,
                color: Colors.white,
              )
                  : Text(
                text,
                style: TextStyle(
                  fontFamily: 'CustomFont',
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}