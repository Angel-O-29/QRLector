import 'package:flutter/material.dart';
import 'package:lector_qr/src/bloc/provider.dart';
import 'package:lector_qr/src/utils/utils.dart' as utils;

import 'package:lector_qr/src/providers/db_provider.dart';

class MapasPage extends StatelessWidget {
  MapasPage({this.type});
  final type;

  @override
  Widget build(BuildContext context) {
    final scansbloc = Provider.of(context).scansBloc;
    scansbloc.obtenerScans();
    return Container(
      child: StreamBuilder(
        stream: _hacerSink(scansbloc),
        builder:
            (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final scans = snapshot.data;
          if (scans.length == 0) {
            return Center(
              child: Text('No hay informacion'),
            );
          }
          return ListView.builder(
              itemCount: scans.length,
              itemBuilder: (BuildContext context, int index) =>
                  _listOnly(context, scans[index], scansbloc));
        },
      ),
    );
  }

  Stream<List<ScanModel>> _hacerSink(scansbloc) {
    if (type == 'geo') {
      return scansbloc.scansStream;
    } else if (type == 'http') {
      return scansbloc.scansStreamHttp;
    }
    return scansbloc.scansStreamOther;
  }

  String _titulo(scan) {
    if (type == 'geo') {
      return scan.value;
    } else if (type == 'http') {
      return scan.value.substring(8);
    }
    return scan.value;
  }

  Widget _obtenerIcon() {
    if (type == 'geo') {
      return Icon(Icons.location_searching);
    } else if (type == 'http') {
      return Icon(
        Icons.http,
        size: 30,
      );
    }
    return Icon(Icons.cloud_queue);
  }

  Widget _listOnly(BuildContext context, ScanModel scan, scansbloc) => ListTile(
        onLongPress: () => _mostrarAlert(context, scan, scansbloc),
        trailing: Icon(Icons.chevron_right),
        leading: _obtenerIcon(),
        title: Text(
          _titulo(scan),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text('id: ${scan.id.toString()} '),
        onTap: () {
          utils.openScanL(context, scan);
        },
      );
/*
  Widget _dismissible(BuildContext context, ScanModel scan) => Dismissible(
        key: UniqueKey(),
        background: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Colors.red[900],
              Colors.redAccent[100],
            ],
            begin: FractionalOffset(0.0, 0.3),
            end: FractionalOffset(0.0, 1.0),
          )),
        ),
        onDismissed: (direction) => scansbloc.borrarScanID(scan.id),
        child: ListTile(
          trailing: Icon(Icons.chevron_right),
          leading: _obtenerIcon(),
          title: Text(
            _titulo(scansbloc),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text('id: ${scan.id.toString()} '),
          onTap: () {
            utils.openScanL(context, scan);
          },
        ),
      );*/
  void _mostrarAlert(BuildContext context, ScanModel scan, scansbloc) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text(
              '¿Desea eliminar este registro?',
              textAlign: TextAlign.center,
            ),
            content: Text('Esta accion no podra deshacerse'),
            actions: [
              FlatButton(
                  onPressed: () => (Navigator.pop(context)),
                  child: Text('Cancelar', style: TextStyle(color: Colors.red))),
              FlatButton(
                  onPressed: () {
                    scansbloc.borrarScanID(scan.id);
                    Navigator.pop(context);
                  },
                  child: Text('Si'))
            ],
          );
        });
  }
}
