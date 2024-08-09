// MANIPULAÇÕES DA TABELA
import 'dart:async';

import 'package:consumo_agua/database/db.dart';
import 'package:flutter/material.dart';
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
  DateTime now = DateTime.now();
  String dateFormat = DateFormat('yyyy-MM-dd').format(now);

  // data.data = dateFormat;
  debugPrint(dateFormat.toString());
  // requesitando do banco
  Database db = await getDatabase();
  List<Map<String, dynamic>> consumototal = await db.rawQuery(
      "select sum(consumo) from agua WHERE data LIKE '" + dateFormat + "'");

  // consumototal.forEach((agua) {
  //   print(agua);
  // });
  return consumototal[0]['sum(consumo)'].toString();
}

Future<String> getConsumoPorData(String data) async {
  // requesitando do banco
  Database db = await getDatabase();
  List<Map<String, dynamic>> consumototal = await db
      .rawQuery("select sum(consumo) from agua WHERE data LIKE '" + data + "'");

  // consumototal.forEach((agua) {
  //   print(agua);
  // });
  return consumototal[0]['sum(consumo)'].toString();
}

Future<String> getQuantia() async {
  DateTime now = DateTime.now();
  String dateFormat = DateFormat('yyyy-MM-dd').format(now);

  // data.data = dateFormat;
  debugPrint(dateFormat.toString());
  // requesitando do banco

  Database db = await getDatabase();
  List<Map<String, dynamic>> consumototal = await db.rawQuery(
      "select sum(consumo) from agua WHERE data LIKE '" + dateFormat + "'");

  int consumo = int.parse(consumototal[0]['sum(consumo)'].toString());
  int meta = 2000;
  int quantia = meta - consumo;
  int extrapolacao = consumo - meta;
  {
    if (consumo == meta) {
      return "Parábens, você atingiu a sua meta diária!";
    } else if (consumo < meta) {
      return "Ainda faltam $quantia ml para você atingir a sua meta diária!";
    } else if (consumo > meta) {
      return "Você extrapolou a sua meta diária em $extrapolacao ml, parabéns!";
    } else {
      return "beba";
    }
  }
}


  // String quantiafinal = quantia.toString();

