import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

/// A quick example "keyboard" widget for Numeric.
class CharKeyboard extends StatefulWidget
    with KeyboardCustomPanelMixin<String>
    implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(250);
  final ValueNotifier<String> notifier;
  final FocusNode focusNode;
  final VoidCallback onCallback;

  CharKeyboard({
    Key key,
    this.notifier,
    this.focusNode,
    this.onCallback
  }) : super(key: key);

  @override
  _CharKeyboardState createState() => _CharKeyboardState();
}

class _CharKeyboardState extends State<CharKeyboard> with KeyboardCustomPanelMixin<String> {
  ValueNotifier<String> notifier;

  bool _isChanged = true;

  bool _isCapitalize = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    notifier = widget.notifier;
  }

  void _onTapChar(String value) {
    final currentValue = widget.notifier.value;
    final temp = currentValue + value;
    updateValue(temp);
  }

  void _onTapIcon(IconData icon) {
    if (icon == Icons.done) {
      widget.focusNode.unfocus();
    } else if (icon == MdiIcons.numeric) {
      setState(() {
        _isChanged = false;
      });
    } else if (icon == MdiIcons.alphabetical) {
      setState(() {
        _isChanged = true;
      });
    } else if (icon == MdiIcons.appleKeyboardShift) {
      setState(() {
        _isCapitalize = false;
      });
    } else if (icon == MdiIcons.appleKeyboardCaps) {
      setState(() {
        _isCapitalize = true;
      });
    } else {
      final currentValue = widget.notifier.value;
      final temp = currentValue.substring(0, currentValue.length > 0 ? currentValue.length - 1 : currentValue.length);
      updateValue(temp);
    }
  }

  String getChar(String letter, String number) {
    return _isChanged ? letter : number;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildButton(text: getChar("A", "1")),
                _buildButton(text: getChar("B", "2")),
                _buildButton(text: getChar("C", "3")),
                _buildButton(text: getChar("D", "4")),
                _buildButton(text: getChar("E", "5")),
                _buildButton(text: getChar("F", "6")),
                _buildButton(text: getChar("G", "7")),
                _buildButton(text: getChar("H", "8")),
                _buildButton(text: getChar("I", "9")),
                _buildButton(text: getChar("J", "0")),
              ]
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildButton(text: getChar("K", "-")),
                _buildButton(text: getChar("L", "/")),
                _buildButton(text: getChar("M", ":")),
                _buildButton(text: getChar("N", ";")),
                _buildButton(text: getChar("O", "(")),
                _buildButton(text: getChar("P", ")")),
                _buildButton(text: getChar("Q", "€")),
                _buildButton(text: getChar("R", '%')),
                _buildButton(text: getChar("S", "&")),
              ]
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildButton(icon: _isCapitalize ? MdiIcons.appleKeyboardShift : MdiIcons.appleKeyboardCaps, color: Colors.grey, iconColor: Colors.black),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildButton(text: getChar("T", "@")),
                  _buildButton(text: getChar("U", ".")),
                  _buildButton(text: getChar("V", ",")),
                  _buildButton(text: getChar("W", "?")),
                  _buildButton(text: getChar("X", "!")),
                  _buildButton(text: getChar("Y", "'")),
                  _buildButton(text: getChar("Z", '"'))
                ],
              ),
              _buildButton(icon: Icons.backspace, color: Colors.grey, iconColor: Colors.black)
            ]
          ),
          Row(
            children: <Widget>[
              _buildButton(icon: _isChanged ? MdiIcons.numeric : MdiIcons.alphabetical, color: Colors.grey, iconColor: Colors.black),
              Expanded(child: _buildButton(text: " ")),
              _buildButton(icon: Icons.done, color: Colors.blue[600])
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
    Color iconColor = Colors.white
  }) {
    return CharButton(
      text: text,
      icon: icon,
      color: color,
      iconColor: iconColor,
      onTap: () {
        widget.onCallback();

        icon != null ? _onTapIcon(icon) : _onTapChar(text);
      },
    );
  }
}

class CharButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final IconData icon;
  final Color color;
  final Color iconColor;

  const CharButton({
    Key key,
    this.text,
    this.onTap,
    this.icon,
    this.color,
    this.iconColor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width / 8,
      width: icon != null ? MediaQuery.of(context).size.width / 8 : MediaQuery.of(context).size.width / 10,
      padding: const EdgeInsets.all(3.0),
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
                color: iconColor,
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