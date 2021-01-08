import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:lector_qr/src/models/scan_model.dart';

class MapaPage extends StatelessWidget {
  final MapController map = MapController();
  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: _appBar(scan),
      body: _crearMapa(scan),
    );
  }

  Widget _appBar(scan) => AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () {
              map.move(scan.getLatLng(), 14.5);
            },
          )
        ],
        centerTitle: true,
        title: RichText(
          text: TextSpan(
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
              children: [
                TextSpan(
                  text: 'Geo',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(text: 'Mapa'),
              ]),
        ),
      );

  _crearMapa(ScanModel scan) {
    //pk.eyJ1IjoiYW5nZWxvbHVpcyIsImEiOiJja2l1bTJqanUwOW04MnlzYmV5Ym02cGt6In0.RmwQeFpQFGfDKZD-xrtVGg
    //geo:40.724233047051705,-74.00731459101564
    return FlutterMap(
      mapController: map,
      options: MapOptions(center: scan.getLatLng(), zoom: 14.5),
      layers: [_crearMapaFondo(), _crearIcon(scan)],
    );
  }

  TileLayerOptions _crearMapaFondo() {
    return TileLayerOptions(
        urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
        subdomains: ['a', 'b', 'c']);
  }

  MarkerLayerOptions _crearIcon(ScanModel scan) {
    return MarkerLayerOptions(
      markers: [
        new Marker(
          width: 80.0,
          height: 80.0,
          point: scan.getLatLng(),
          builder: (context) => Container(
            child: Icon(
              Icons.location_pin,
              color: Colors.deepPurple,
              size: 40,
            ),
          ),
        ),
      ],
    );
  }
}
