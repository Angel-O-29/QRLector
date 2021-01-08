import 'package:flutter/material.dart';
import 'package:lector_qr/src/models/scan_model.dart';
import 'package:url_launcher/url_launcher.dart';

openScanL(BuildContext context, ScanModel scan) async {
  if (scan.type == 'http') {
    if (await canLaunch(scan.value)) {
      await launch(scan.value);
    } else {
      throw 'Could not launch ${scan.value}';
    }
  } else if (scan.type == 'geo') {
    Navigator.pushNamed(context, 'map', arguments: scan);
  } else {
    Navigator.pushNamed(context, 'other', arguments: scan);
  }
}
