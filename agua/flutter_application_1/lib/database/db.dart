import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDatabase() async {
  String caminhoBanco = join(await getDatabasesPath(), 'agua.db');

  return openDatabase(
    caminhoBanco,
    version: 1,
    onCreate: (db, version) {
      db.execute(
          'CREATE TABLE agua(id INTEGER PRIMARY KEY AUTOINCREMENT, data DATE, consumo DECIMAL);');
    },
  );
}
