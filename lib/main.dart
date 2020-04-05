import 'package:custom_keyboard/numeric_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final FocusNode _focusNode = FocusNode();

  final ValueNotifier<String> _notifier = ValueNotifier<String>("");

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardAction(
          focusNode: _focusNode,
          displayActionBar: false,
          footerBuilder: (_) => CharKeyboard(
            focusNode: _focusNode,
            notifier: _notifier,
          ),
        ),
      ],
    );
  }

  bool _hasFocus = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _focusNode.addListener(() {
      _hasFocus = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Keyboard"),
      ),
      body: KeyboardActions(
        config: _buildConfig(context),
        child: Center(
          child: KeyboardCustomInput(
            focusNode: _focusNode,
            notifier: _notifier,
            builder: (context, val, hasFocus) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  val != "" ? Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      val,
                      style: TextStyle(
                          fontFamily: 'CustomFont',
                          fontSize: 44.0
                      )
                    ),
                  ) : Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text("Say Something",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 28.0
                        )),
                  ),
                  Divider(color: _hasFocus ? Colors.blue : Colors.grey, thickness: 2.0)
                ],
              );
            }
          )
        )
      )
    );
  }
}
