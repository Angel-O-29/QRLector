import 'package:flutter/material.dart';
import 'package:lector_qr/src/bloc/provider.dart';
import 'package:lector_qr/src/pages/mapas_page.dart';
import 'package:lector_qr/src/models/scan_model.dart';
import 'package:lector_qr/src/utils/utils.dart' as utils;
import 'package:qrscan/qrscan.dart' as scanner;

import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _pagActual = 0;
  bool primeraVez = true;
  final _pageController = PageController(initialPage: 0);
  @override
  @override
  Widget build(BuildContext context) {
    final scansBloc = Provider.of(context).scansBloc;
    return Container(
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            actions: [
              IconButton(
                  icon: Icon(Icons.delete_forever),
                  onPressed: () {
                    print('borrados');
                    scansBloc.borrarAllScans();
                    Future.delayed(Duration(milliseconds: 300))
                        .then((value) => scansBloc.obtenerScans());
                  })
            ],
            title: RichText(
              text: TextSpan(style: TextStyle(fontSize: 24), children: [
                TextSpan(
                  text: 'QR',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(text: 'Lector'),
              ]),
            ),
          ),
          body: _pageview(), //_callPage(_pagActual),
          floatingActionButton: _actionButton(scansBloc),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          bottomNavigationBar: _bottonNav()),
    );
  }

  Widget _actionButton(ScansBloc scansBloc) => FloatingActionButton(
        onPressed: () => _scanQR(scansBloc),
        child: Icon(Icons.filter_center_focus),
      );

  Widget _bottonNav() => BottomNavigationBar(
        currentIndex: _pagActual,
        onTap: (i) {
          _pagActual = i;
          _pageController.animateToPage(_pagActual,
              duration: Duration(milliseconds: 350), curve: Curves.easeIn);
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.devices), label: 'Navegacion'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Mapas'),
          BottomNavigationBarItem(
              icon: Icon(Icons.brightness_5), label: 'Otros'),
        ],
      );

  Widget _pageview() {
    return PageView(
      controller: _pageController,
      onPageChanged: (value) async {
        await Future.delayed(Duration(milliseconds: 250));
        setState(() {
          _pagActual = value;
        });
      },
      children: [
        MapasPage(
          type: 'http',
        ),
        MapasPage(
          type: 'geo',
        ),
        MapasPage(
          type: 'other',
        ),
      ],
    );
  }

/*
  Widget _callPage(int paginaActual) {
    switch (paginaActual) {
      case 0:
        return MapasPage();
      case 1:
        return DireccionesPage();
      default:
        return MapasPage();
    }
  }
*/
  void _scanQR(ScansBloc scansBloc) async {
    //https://www.qrcode.es/es/
    //https://www.google.com/

    //geo:40.724233047051705,-74.00731459101564
    PermissionStatus status = await Permission.camera.status;
    PermissionStatus storage = await Permission.storage.status;
    if (status.isUndetermined || storage.isUndetermined) {
      await Permission.camera.request();
      await Permission.storage.request();
    }

    String futureString = '';
    try {
      futureString = await scanner.scan();
    } catch (e) {
      futureString = e.toString();
    }
    if (futureString != null) {
      print('hay info: $futureString');
      final scan = ScanModel(value: futureString);
      scansBloc.agregarScan(scan);
      if (!(scan.type == 'other')) {
        utils.openScanL(context, scan);
      }
      /*
      en caso de desarrollar para ios es necesario esto para que la animacion de cerrar la camara no moleste con la apertura del navegador
      import 'dart:io'; 

      if (Platform.isIOS) {
        Future.delayed(Duration(milliseconds: 750), () {
          utils.openScanL(scan);
        });
      }*/
    }
  }
}
