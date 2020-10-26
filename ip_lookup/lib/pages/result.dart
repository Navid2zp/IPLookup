import 'dart:io';
import 'dart:math';

import 'package:csplookup/csplookup.dart' as csplookup;
import 'package:flutter/material.dart';
import 'package:iplookup/colors/colors.dart';

class Result extends StatefulWidget {
  final String ip;

  Result({this.ip});
  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  var client = csplookup.LookupClient(
      apiKey: 'API_KEY');
  csplookup.LookupResponse _response;
  String _errorMsg = '';
  IconData _errorIcon = Icons.error_outline;
  bool _loading = true;

  void responseHandler(csplookup.LookupResponse response) {
    try {
      response.checkAPIError();
    } on csplookup.TimeLimitReachedException {
      setState(() {
        _errorMsg = 'Request timed out!';
        _errorIcon = Icons.error_outline;
      });
    } on csplookup.InvalidIpException {
      setState(() {
        _errorMsg = 'Invalid IP!';
        _errorIcon = Icons.error_outline;
      });
      setState(() {
        _errorMsg = 'Something went wrong while requesting lookup result!';
        _errorIcon = Icons.error_outline;
      });
    }
    setState(() {
      _loading = false;
      _response = response;
      _errorIcon = Icons.error_outline;
    });
  }

  void responseErrorHandler(Exception exception) {
    var msg = "Something went wrong while requesting lookup result!";
    var errorIcon = Icons.error_outline;

    if (exception is SocketException) {
      msg = "No internet connection!";
      errorIcon = Icons.signal_wifi_off;
    }
    setState(() {
      _loading = false;
      _errorMsg = msg;
      _errorIcon = errorIcon;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    try {
      client.ipLookup(widget.ip).then((response) => responseHandler(response)).catchError((exception) => responseErrorHandler(exception));
    } catch (e) {
      setState(() {
        _errorMsg = 'Something went wrong while requesting lookup result!';
      });
    }
  }

  Widget _getBody() {
    if (_loading) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(yellow),
          ),
          SizedBox(height: 20),
          Text(
            "Requesting lookup ...",
            style: TextStyle(color: yellow),
          )
        ],
      ));
    } else if (_errorMsg != '') {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              _errorIcon,
              size: 100.0,
              color: red,
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                _errorMsg,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: red,
                  fontSize: 18,
                ),
              ),
            )
          ],
        ),
      );
    } else if (_response != null) {
      return ListView(children: <Widget>[
        Column(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Center(
                child: Text(
              _response.ip,
              style: TextStyle(
                  color: yellow,
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3.0),
            )),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: getResultRows(_response),
          ),
        )
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: _getBody(),
    );
  }
}

Widget getResultRowText(String text) {
  return Text(
    (text != 'null' && text != null && text != '') ? text : " - ",
    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: white),
  );
}

Widget getResultRowWidget(String field, value) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        getResultRowText(field),
        getResultRowText(value),
      ],
    ),
  );
}

List<Widget> getResultRows(csplookup.LookupResponse response) {
  List<Widget> rows = List<Widget>();

  // Country Section
  if (response.result.country != null) {
    rows.add(Text(
      " County:",
      style:
          TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: yellow),
    ));
    rows.add(Divider(
      color: white,
    ));
    rows.add(Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: <Widget>[
          getResultRowWidget(
              "Country Name:",
              response.result.country.names != null
                  ? response.result.country.names['en']
                  : " - "),
          getResultRowWidget("ISO Code:", response.result.country.isoCode),
          getResultRowWidget("European Union:",
              response.result.country.isInEuropeanUnion == true ? "Yes" : "No"),
        ],
      ),
    ));
  }

  // City Section
  if (response.result.city != null) {
    rows.add(Text(
      " City:",
      style:
          TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: yellow),
    ));
    rows.add(Divider(
      color: white,
    ));
    rows.add(Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: <Widget>[
          getResultRowWidget(
              "City Name:",
              response.result.city.names != null
                  ? response.result.city.names['en']
                  : " - "),
        ],
      ),
    ));
  }

  // Location Section
  if (response.result.location != null) {
    rows.add(Text(
      " Location:",
      style:
          TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: yellow),
    ));
    rows.add(Divider(
      color: white,
    ));
    rows.add(Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: <Widget>[
          getResultRowWidget(
              "Latitude:", response.result.location.latitude.toString()),
          getResultRowWidget(
              "Longitude:", response.result.location.longitude.toString()),
          getResultRowWidget("Accuracy Radius:",
              response.result.location.accuracyRadius.toString()),
          getResultRowWidget("Time Zone:", response.result.location.timeZone),
        ],
      ),
    ));
  }

  // Continent Section
  if (response.result.continent != null) {
    rows.add(Text(
      " Continent:",
      style:
          TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: yellow),
    ));
    rows.add(Divider(
      color: white,
    ));
    rows.add(Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: <Widget>[
          getResultRowWidget(
              "Continent Name:",
              response.result.continent.names != null
                  ? response.result.continent.names['en']
                  : " - "),
          getResultRowWidget("Code:", response.result.continent.code),
        ],
      ),
    ));
  }

  // RegisteredCountry Section
  if (response.result.registeredCountry != null) {
    rows.add(Text(
      " Registered Country:",
      style:
          TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: yellow),
    ));
    rows.add(Divider(
      color: white,
    ));
    rows.add(Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: <Widget>[
          getResultRowWidget(
              "Country Name:",
              response.result.registeredCountry.names != null
                  ? response.result.registeredCountry.names['en']
                  : " - "),
          getResultRowWidget(
              "ISO Code:", response.result.registeredCountry.isoCode),
          getResultRowWidget(
              "European Union:",
              response.result.registeredCountry.isInEuropeanUnion == true
                  ? "Yes"
                  : "No"),
        ],
      ),
    ));
  }

  // RegisteredCountry Section
  if (response.result.representedCountry != null) {
    rows.add(Text(
      " Represented Country:",
      style:
          TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: yellow),
    ));
    rows.add(Divider(
      color: white,
    ));
    rows.add(Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: <Widget>[
          getResultRowWidget(
              "Country Name:",
              response.result.representedCountry.names != null
                  ? response.result.representedCountry.names['en']
                  : " - "),
          getResultRowWidget(
              "ISO Code:", response.result.representedCountry.isoCode),
          getResultRowWidget(
              "European Union:",
              response.result.representedCountry.isInEuropeanUnion == true
                  ? "Yes"
                  : "No"),
          getResultRowWidget("Type:", response.result.representedCountry.type),
        ],
      ),
    ));
  }

  // Postal Section
  if (response.result.postal != null) {
    rows.add(Text(
      " Postal:",
      style:
          TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: yellow),
    ));
    rows.add(Divider(
      color: white,
    ));
    rows.add(Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: <Widget>[
          getResultRowWidget("Code:", response.result.postal.code),
        ],
      ),
    ));
  }

  // Traits Section
  if (response.result.traits != null) {
    rows.add(Text(
      " Traits:",
      style:
          TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: yellow),
    ));
    rows.add(Divider(
      color: white,
    ));
    rows.add(Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: <Widget>[
          getResultRowWidget("Anonymous Proxy:",
              response.result.traits.isAnonymousProxy == true ? "Yes" : "No"),
          getResultRowWidget(
              "Satellite Provider:",
              response.result.traits.isSatelliteProvider == true
                  ? "Yes"
                  : "No"),
        ],
      ),
    ));
  }


  return rows;
}
