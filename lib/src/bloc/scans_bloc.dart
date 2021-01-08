import 'dart:async';
import 'package:lector_qr/src/bloc/validators.dart';
import 'package:lector_qr/src/providers/db_provider.dart';

class ScansBloc with Validators {
  final _scansController = StreamController<List<ScanModel>>.broadcast();
  bool _loading = false;

  Stream<List<ScanModel>> get scansStream =>
      _scansController.stream.transform(validarGeo);
  Stream<List<ScanModel>> get scansStreamHttp =>
      _scansController.stream.transform(validarHttp);
  Stream<List<ScanModel>> get scansStreamOther =>
      _scansController.stream.transform(validarOther);
  Function get scansSink => _scansController.sink.add;

  dispose() {
    _scansController?.close();
  }

  obtenerScans() async {
    if (!_loading) {
      _loading = true;
      scansSink(await DBProvider.db.getAllScan());
      _loading = false;
    }
  }

  agregarScan(ScanModel scan) async {
    await DBProvider.db.nuevoScan(scan);
    obtenerScans();
  }

  borrarScanID(int id) async {
    await DBProvider.db.deleteScannId(id);
    obtenerScans();
  }

  borrarAllScans() async {
    await DBProvider.db.deleteAllScann();
    List<ScanModel> list = [];
    scansSink(list);
  }
}
