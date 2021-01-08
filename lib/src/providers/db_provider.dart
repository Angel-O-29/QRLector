import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:lector_qr/src/models/scan_model.dart';
export 'package:lector_qr/src/models/scan_model.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._private();
  factory DBProvider() {
    return db;
  }
  DBProvider._private();

  get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

//crear base de datos
  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'ScansDB.db');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Scans ( '
          'id INTEGER PRIMARY KEY, '
          'type TEXT, '
          'value TEXT '
          ')');
    });
  }

  //crear registro
  nuevoScanRow(ScanModel nuevoScan) async {
    final db = await database;

    final res = await db.rawInsert("INSERT INTO Scans (id, type , value)"
        "VALUES (${nuevoScan.id},'${nuevoScan.type}', '${nuevoScan.value}' )");
    return res;
  }

  nuevoScan(ScanModel nuevoScan) async {
    final db = await database;

    final res = await db.insert('Scans', nuevoScan.toJson());
    return res;
  }

  //select - obtener info

  Future<ScanModel> getScanID(int id) async {
    final db = await database;

    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]);
    return (res.isNotEmpty) ? ScanModel.fromJson(res.first) : null;
  }

  Future<List<ScanModel>> getAllScan() async {
    final db = await database;

    final List<Map<String, dynamic>> res = await db.query('Scans');

    List<ScanModel> list =
        (res.isNotEmpty) ? res.map((s) => ScanModel.fromJson(s)).toList() : [];
    return list;
  }

  Future<List<ScanModel>> getAllScanType(String type) async {
    final db = await database;

    final res = await db.query('Scans', where: 'type: ? ', whereArgs: [type]);
    List<ScanModel> list =
        (res.isNotEmpty) ? res.map((s) => ScanModel.fromJson(s)).toList() : [];
    return list;
  }

  //actualizar registros

  Future<ScanModel> updateScanID(ScanModel nuevoScan) async {
    final db = await database;

    final res = await db.update('Scans', nuevoScan.toJson(),
        where: 'id = ?', whereArgs: [nuevoScan.id]);
    return (res.isNotEmpty) ? ScanModel.fromJson(res.first) : null;
  }

  //borrar
  deleteScannId(int id) async {
    final db = await database;

    final res = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  deleteAllScann() async {
    final db = await database;

    final res = await db.rawDelete('DELETE FROM Scans');
    return res;
  }
}
