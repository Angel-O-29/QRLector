import 'package:flutter/material.dart';
import 'package:lector_qr/src/pages/home_page.dart';
import 'package:lector_qr/src/bloc/provider.dart';
import 'package:lector_qr/src/pages/map_page.dart';
import 'package:lector_qr/src/pages/otros_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            canvasColor: Colors.indigo[510],
            primaryColor: Colors.indigo,
            splashColor: Colors.indigoAccent,
            accentColor: Colors.indigo[600]),
        title: 'QRLector',
        initialRoute: 'home',
        routes: {
          'home': (BuildContext context) => HomePage(),
          'map': (BuildContext context) => MapaPage(),
          'other': (BuildContext context) => OtrosPage(),
        },
      ),
    );
  }
}
