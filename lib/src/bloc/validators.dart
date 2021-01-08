import 'dart:async';

import 'package:lector_qr/src/models/scan_model.dart';

class Validators {
  final validarGeo =
      StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
    handleData: (data, sink) {
      final geoScans = data.where((element) => element.type == 'geo').toList();
      sink.add(geoScans);
    },
  );
  final validarHttp =
      StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
    handleData: (data, sink) {
      final httpScans =
          data.where((element) => element.type == 'http').toList();
      sink.add(httpScans);
    },
  );
  final validarOther =
      StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
    handleData: (data, sink) {
      final httpScans =
          data.where((element) => element.type == 'other').toList();
      sink.add(httpScans);
    },
  );
}
