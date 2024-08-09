// MANIPULAÇÕES DA TABELA
import 'dart:async';

import 'package:consumo_agua/database/db.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import '../../model/agua.dart';

Future<int> insertDia(Agua agua) async {
  DateTime now = DateTime.now();
  String dateFormat = DateFormat('yyyy-MM-dd').format(now);

  agua.data = dateFormat;

  // debugPrint("Data: " + dateFormat);

  Database db = await getDatabase();
  return db.insert('agua', agua.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);
}

Future<List<Map<String, dynamic>>> findall() async {
  Database db = await getDatabase();
  List<Map<String, dynamic>> dados =
      await db.query('agua'); // requesitando do banco

  dados.forEach((agua) {
    print(agua);
  });
  return dados;
}

Future<String> getConsumo() async {
  // DateTime now = DateTime.now();
  // String dateFormat = DateFormat('yyyy-MM-dd').format(now);
  
   // requesitando do banco
  Database db = await getDatabase();
  List<Map<String, dynamic>> consumototal = await db
      .rawQuery("select sum(consumo) from agua WHERE data LIKE '2024-08-02';");

  // consumototal.forEach((agua) {
  //   print(agua);
  // });
  return consumototal[0]['sum(consumo)'].toString();
}
