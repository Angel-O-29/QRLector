// Generated by https://quicktype.io

import 'package:latlong/latlong.dart';

class ScanModel {
  int id;
  String type;
  String value;

  ScanModel({
    this.id,
    this.type,
    this.value,
  }) {
    if (this.value.contains('http')) {
      this.type = 'http';
    } else if (this.value.contains('geo')) {
      this.type = 'geo';
    } else {
      this.type = 'other';
    }
  }
  ScanModel.fromJson(json) {
    id = json['id'];
    type = json['type'];

    value = json['value'];
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "value": value,
      };
  LatLng getLatLng() {
    final lalo = value.substring(4).split(',');
    final lat = double.parse(lalo[0]);
    final lon = double.parse(lalo[1]);
    return LatLng(lat, lon);
  }
}