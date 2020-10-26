# IPLookup
Flutter source code for IP Lookup app.

 <p align="center">
   <img width="30%" alt="Screenshot" src="https://github.com/Navid2zp/IPLookup/raw/main/Screenshot_1.jpg" />
   <img width="30%" alt="Screenshot" src="https://github.com/Navid2zp/IPLookup/raw/main/Screenshot_2.jpg" />
 </p>


**Google Play**: https://play.google.com/store/apps/details?id=studio.arvix.iplookup

**CafeBazaar**: https://cafebazaar.ir/app/studio.arvix.iplookup

## Supported IP Information
- City
- Country
- Continent
- Location
- Postal
- RegisteredCountry
- RepresentedCountry
- Subdivisions
- Traits


## API
You should add your API key in [`result.dart`](https://github.com/Navid2zp/IPLookup/blob/e5467f2452de5c3d244b38491f2528ceca87932b/ip_lookup/lib/pages/result.dart#L17) file.

```dart
var client = csplookup.LookupClient(apiKey: 'API_KEY');
```

## Structure
The app is fairly simple. There are only 2 pages (`home.dart` and `result.dart`). Most logic happens in `result.dart`.


## Theme
You can replace the colors by just editing the them in [`colors.dart`](https://github.com/Navid2zp/IPLookup/blob/main/ip_lookup/lib/colors/colors.dart) file.

```dart
final Color primary = Color.fromARGB(255, 1, 22, 39);
final Color white = Color.fromARGB(255, 253, 255, 252);
final Color blue = Color.fromARGB(255, 46, 196, 182);
final Color red = Color.fromARGB(255, 231, 29, 54);
final Color yellow = Color.fromARGB(255, 255, 159, 28);
```


License
----

[MIT][1]


[1]: https://github.com/Navid2zp/IPLookup/blob/main/LICENSE
