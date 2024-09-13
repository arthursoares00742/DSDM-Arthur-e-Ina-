// import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/database/dao/aguadao.dart';
import 'package:flutter_application_1/model/agua.dart';
// import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  List dados = await findall();
  debugPrint(dados.toString());

  runApp(const MaterialApp(
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
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ))),
          backgroundColor: const Color.fromRGBO(0, 151, 178, 1)),
      body: ListView(
        children: [
          FutureBuilder(
              initialData: const [],
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
                    String consumo = '0';
                    if (snapshot.hasData &&
                        (snapshot.data as String) != "null") {
                      consumo = snapshot.data as String;
                    }

                    return ListTile(
                      title: Center(
                        child: RichText(
                            text: TextSpan(
                                text: "VOCÊ JÁ BEBEU ",
                                style: const TextStyle(
                                    fontSize: 34.0, color: Colors.black),
                                children: <TextSpan>[
                              TextSpan(
                                text: "${consumo}ml",
                                style: const TextStyle(
                                  fontSize: 34.0,
                                  color: Color.fromRGBO(0, 151, 178, 1),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const TextSpan(
                                text: " HOJE!",
                                style: TextStyle(
                                    fontSize: 34.0, color: Colors.black),
                              ),
                            ])),
                      ),
                      // trailing: Image.asset("img/agua.png"),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 50.0),
                    );
                }
              }),
          FutureBuilder(
              initialData: const [],
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
                    String quantiatotal = '0';
                    if (snapshot.hasData) {
                      quantiatotal = snapshot.data as String;
                    }

                    return ListTile(
                      title: Center(
                          child: Text(quantiatotal,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24.0,
                              ))),
                      tileColor: const Color.fromRGBO(0, 151, 178, 1),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 10.0), // Espaçamento interno
                    );
                }
              }),
          const SizedBox(height: 20),
          const Center(
            child: SnackBarAlerta(),
          ),
          const SizedBox(height: 10),
          Expanded(
              child: Container(
            color: Colors.white,
            child: Lottie.asset(
              'animacao/animacao1.json', // Caminho para o arquivo Lottie
              width: 20,
              height: 200,
              fit: BoxFit.contain,
              repeat: true,
            ),
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Cadastro(),
              )).then((value) => null);
        },
        elevation: 40,
        backgroundColor: const Color.fromRGBO(0, 151, 178, 1),
        heroTag: "btn1",
        child: const Icon(Icons.add),
      ),
    );
  }
}

class SnackBarAlerta extends StatelessWidget {
  const SnackBarAlerta({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text('Sempre vale a pena clicar'),
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            action: SnackBarAction(
              label: 'Indo beber água',
              onPressed: () {
                // Code to execute.
              },
            ),
            content: const Text(
                'Para manter seu corpo saudável a OMS recomenda que você deixe de ser preguiçoso e vá beber mais água!',
                style: TextStyle(color: Colors.white, fontSize: 18)),
            duration: const Duration(seconds: 20),
            width: 280.0, // Width of the SnackBar.
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0, // Inner padding for SnackBar content.
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            backgroundColor: Color.fromRGBO(0, 151, 178, 1),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          textStyle:
              TextStyle(fontSize: 18, color: Color.fromRGBO(0, 151, 178, 1)),
          shadowColor: Colors.black,
          elevation: 5),
    );
  }
}

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text("Hidratando-se",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ))),
        backgroundColor: const Color.fromRGBO(0, 151, 178, 1),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),
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
                      builder: (context) => const TelaPrincipal(),
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
            child: const Text('+1 COPO',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )),
          ),
          const SizedBox(height: 10),
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
                      builder: (context) => const TelaPrincipal(),
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
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )),
          ),
          const SizedBox(height: 20),
          const Center(
            child: SizedBox(
              width: 150.0,
              height: 80.0,
              child: ListTile(
                  title: Text("Lembre-se",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold)),
                  subtitle: Text("DA SUA META!",
                      style: TextStyle(
                        color: Colors.white,
                      )),
                  tileColor: Color.fromRGBO(0, 151, 178, 1)),
            ),
          )
        ],
      ),
      floatingActionButton: null,
    );
  }
}
