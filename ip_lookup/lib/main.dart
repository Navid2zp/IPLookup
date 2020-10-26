import 'package:flutter/material.dart';
import 'package:iplookup/colors/colors.dart';
import 'package:iplookup/pages/home.dart';

void main() {
  runApp(MaterialApp(
    title: 'IP Lookup',

    // Start the app with the "/" named route. In this case, the app starts
    // on the FirstScreen widget.
    initialRoute: '/',
    theme: ThemeData(
        fontFamily: "Roboto", primaryColor: primary),
    routes: {
      // When navigating to the "/" route, build the FirstScreen widget.
      '/': (context) => IpLookup(),
      // When navigating to the "/second" route, build the SecondScreen widget.
      // '/result': (context) => WordSearch(),
      // '/word': (context) => WordSearch(),
      // '/wordsAlphabetList': (context) => WordsAlphabetList(),
    },
  ));
}

class IpLookup extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IP Lookup',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(title: 'IP Lookup'),
    );
  }
}

