import 'package:custom_keyboard/numeric_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'dart:async';

import 'package:overlay_support/overlay_support.dart';

void main() => runApp(OverlaySupport(child: MyApp()));

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

class _MyHomePageState extends State<MyHomePage> with KeyboardCustomPanelMixin<String> {
  final FocusNode _focusNode = FocusNode();

  // has to be notifier because the class implements KeyboardCustomPanelMixin
  final ValueNotifier<String> notifier = ValueNotifier<String>("");

  bool _isBlue = true;

  bool _isTyping = false;

  List<Future<dynamic>> futures = [];

  Timer _timer;

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  void _initializeTimer() {
    setState(() {
      _isTyping = true;
    });

    if (_timer != null) {
      _timer.cancel();
    }

    _timer = Timer(const Duration(milliseconds: 500), () => _resetTimer());
  }

   void _resetTimer() {
     setState(() {
       _isTyping = false;

       _isBlue = false;
     });
   }

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
            onCallback: () async {
              _initializeTimer();
            },
            focusNode: _focusNode,
            notifier: notifier,
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _focusNode.addListener(() {
      _isBlue = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        appBar: AppBar(
          title: Text("Keyboard"),
        ),
        body: KeyboardActions(
            config: _buildConfig(context),
            child: Center(
                child: KeyboardCustomInput(
                    focusNode: _focusNode,
                    notifier: notifier,
                    builder: (context, val, hasFocus) {
                      Color color;

                      if (hasFocus) {
                        if (_isTyping) {
                          color = Colors.blue[600];
                        } else {
                          if (_isBlue) {
                            color = Colors.blue[600];
                          } else {
                            color = Colors.white;
                          }
                        }
                      } else {
                        color = Colors.white;
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Stack(
                            alignment: AlignmentDirectional.centerStart,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text(val == "" ? "Say something" : "",
                                    style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 28.0)),
                              ),
                              FlatButton(
                                onPressed: () async {
                                  if (!hasFocus) {
                                    _focusNode.requestFocus();
                                  } else {
                                    print(1);
                                    final data = await Clipboard.getData("text/plain");

                                    final currentValue = notifier.value;
                                    final temp = currentValue + data.text;
                                    updateValue(temp);
                                  }
                                },
                                onLongPress: () {
                                  Clipboard.setData(ClipboardData(text: val));

                                  showSimpleNotification(Text("Copied to clipboard!"));
                                },
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text.rich(TextSpan(text: val, children: <InlineSpan>[
                                    WidgetSpan(alignment: PlaceholderAlignment.middle, child: AnimatedContainer(
                                        duration: Duration(milliseconds: 500),
                                        height: 28.0,
                                        width: 2.0,
                                        color: color,
                                        onEnd: () {
                                          setState(() {
                                            _isBlue = !_isBlue;
                                          });
                                        })),
                                  ]),
                                      style: TextStyle(
                                          fontFamily: "CustomFont",
                                          fontSize: 40.0)),
                                ),
                              )
                            ],
                          ),
                          Divider(
                              height: 0.0,
                              thickness: 2.0,
                              color: hasFocus ? Colors.blue[600] : Colors.grey)
                        ],
                      );
                    }))));
  }
}
