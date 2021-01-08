import 'package:flutter/material.dart';
import 'package:lector_qr/src/models/scan_model.dart';

class OtrosPage extends StatelessWidget {
  const OtrosPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: _appBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Center(
          child: Text(
            scan.value,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _appBar() => AppBar(
        centerTitle: true,
        title: RichText(
          text: TextSpan(
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
              children: [
                TextSpan(
                  text: 'Info-',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(text: 'Otros'),
              ]),
        ),
      );
}
