// import 'dart:ffi';
import 'dart:io';
import 'package:consumo_agua/database/dao/aguadao.dart';
import 'package:consumo_agua/model/agua.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Agua umdia = Agua(data: dateString, consumo: 1.6);
  // insertDia(umdia);

  List dados = await findall();
  debugPrint(dados.toString());

  runApp(MaterialApp(
    home: TelaPrincipal(),
    debugShowCheckedModeBanner: false,
  ));
}

class TelaPrincipal extends StatelessWidget {
  const TelaPrincipal({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Center(
              child: Text("Meu consumo de água",
                  style: TextStyle(color: Colors.white))),
          backgroundColor: const Color.fromRGBO(0, 151, 178, 1)),
      body: ListView(
        children: [
          FutureBuilder(
              initialData: [],
              future: getConsumo(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return const Center(
                        child: Text(
                            "Houve um erro de Conexão com o Banco de Dados"));
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case ConnectionState.done:
                    String consumo = snapshot.data as String;

                    return ListTile(
                      title: Center(
                          child: Text("VOCÊ JÁ BEBEU " + consumo + "ml HOJE")),
                      trailing: Image.asset("img/agua.png"),
                    );
                }
              }),
          FutureBuilder(
              initialData: [],
              future: getQuantia(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return const Center(
                        child: Text(
                            "Houve um erro de Conexão com o Banco de Dados"));
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case ConnectionState.done:
                    String quantiatotal = snapshot.data as String;

                    return ListTile(
                      title: Center(
                          child: Text(quantiatotal,
                              style: TextStyle(color: Colors.white))),
                      tileColor: Color.fromRGBO(0, 151, 178, 1),
                    );
                }
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Cadastro(),
              )).then((value) => null);
        },
        child: Icon(Icons.add),
        elevation: 40,
        backgroundColor: const Color.fromRGBO(0, 151, 178, 1),
        heroTag: "btn1",
      ),
    );
  }
}

class Cadastro extends StatefulWidget {
  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text("Hidrate-se", style: TextStyle(color: Colors.white))),
        backgroundColor: const Color.fromRGBO(0, 151, 178, 1),
      ),
      body: ListView(
        children: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: const Color.fromRGBO(0, 151, 178, 1),
            ),
            onPressed: () {
              Agua bebi = Agua(data: "2024-07-26", consumo: 250.0);
              insertDia(bebi);
              setState(() {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TelaPrincipal(),
                    )).then((value) => null);
              });

              // debugPrint("Coisas salvas: " + findall().toString());
              Future<String> consumo = getConsumo();
              String consumoString = '';
              consumo.then(
                (meuconsumo) {
                  consumoString = meuconsumo;
                  debugPrint(consumoString);
                },
              );
            },
            child: const Text('+1 COPO', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: const Color.fromRGBO(0, 151, 178, 1),
            ),
            onPressed: () {
              Agua bebi = Agua(data: "2024-06-26", consumo: 500.0);
              insertDia(bebi);
              setState(() {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TelaPrincipal(),
                    )).then((value) => null);
              });
              // debugPrint("Coisas salvas: " + findall().toString());

              Future<String> consumo = getConsumo();
              String consumoString = '';
              consumo.then(
                (meuconsumo) {
                  consumoString = meuconsumo;
                  debugPrint(consumoString);
                },
              );
            },
            child: const Text('+1 GARRAFINHA',
                style: TextStyle(color: Colors.white)),
          ),
          ListTile(
              title: Text("Lembre-se", style: TextStyle(color: Colors.white)),
              subtitle:
                  Text("DA SUA META!", style: TextStyle(color: Colors.white)),
              tileColor: Color.fromRGBO(0, 151, 178, 1))
        ],
      ),
      floatingActionButton: null,
    );
  }
}
