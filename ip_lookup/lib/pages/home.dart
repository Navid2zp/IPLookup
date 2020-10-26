import 'package:flutter/material.dart';
import 'package:iplookup/colors/colors.dart';
import 'package:iplookup/pages/result.dart';
import 'package:iplookup/utils/validators.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _ip;
  String _ipError = '';
  OutlineInputBorder _inputFocusedBorder = OutlineInputBorder();

  void inputChangeHandler(String ip) {
    if (ip.length == 0) {
      setState(() {
        _ip = null;
        _ipError = '';
        _inputFocusedBorder = OutlineInputBorder();
      });
    } else {
      if (ip.length < 7 || !ipValidator(ip)) {
        setState(() {
          _ip = null;
          _ipError = 'Please enter a valid IP';
          _inputFocusedBorder = OutlineInputBorder(
              borderSide: BorderSide(color: red, width: 2.0));
        });
      } else {
        setState(() {
          _ip = ip;
          _ipError = '';
          _inputFocusedBorder = OutlineInputBorder(
              borderSide: BorderSide(color: blue, width: 2.0));
        });
      }
    }
  }

  void submitHandler() {
    if (_ip == null) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Result(
                ip: _ip,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      appBar: AppBar(
        backgroundColor: primary,
        title: Text(
          widget.title,
          style: TextStyle(color: yellow),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 12),
              child: TextField(
                decoration: InputDecoration(
                  fillColor: white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: yellow, width: 2.0)),
                  focusedBorder: _inputFocusedBorder,
                  hintText: '4.2.2.4',
                  hintStyle: TextStyle(),
                ),
                onChanged: (ip) => inputChangeHandler(ip),
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              _ipError,
              style: TextStyle(color: red),
            ),
            SizedBox(height: 12.0),
            ButtonTheme(
              minWidth: 200,
              height: 60,
              child: RaisedButton(
                child: Text('Lookup'),
                textColor: yellow,
                disabledTextColor: Colors.grey,
                onPressed: (_ipError == '') ? submitHandler : null,
                color: primary,
                disabledColor: primary,
                shape: RoundedRectangleBorder(side: BorderSide(color: yellow)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
