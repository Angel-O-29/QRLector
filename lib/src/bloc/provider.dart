import 'package:flutter/material.dart';
import 'package:lector_qr/src/bloc/scans_bloc.dart';
export 'package:lector_qr/src/bloc/scans_bloc.dart';

class Provider extends InheritedWidget {
  static Provider _instancia;

  Provider._internal({Key key, Widget child}) : super(key: key, child: child);

  factory Provider({Key key, Widget child}) {
    if (_instancia == null) {
      _instancia = new Provider._internal(key: key, child: child);
    }
    return _instancia;
  }

  final scansBloc = ScansBloc();

  static Provider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>();
  }

  @override
  bool updateShouldNotify(Provider oldWidget) {
    return true;
  }
}
