// import 'dart:ffi';
import 'dart:io';
import 'package:consumo_agua/database/dao/aguadao.dart';
import 'package:consumo_agua/local_notification.dart';
import 'package:consumo_agua/model/agua.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lottie/lottie.dart';
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
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ))),
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
                                style: TextStyle(
                                    fontSize: 34.0, color: Colors.black),
                                children: <TextSpan>[
                              TextSpan(
                                text: consumo + "ml",
                                style: TextStyle(
                                  fontSize: 34.0,
                                  color: Color.fromRGBO(0, 151, 178, 1),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: " HOJE!",
                                style: TextStyle(
                                    fontSize: 34.0, color: Colors.black),
                              ),
                            ])),
                      ),
                      // trailing: Image.asset("img/agua.png"),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 50.0),
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
                    String quantiatotal = '0';
                    if (snapshot.hasData) {
                      quantiatotal = snapshot.data as String;
                    }

                    return ListTile(
                      title: Center(
                          child: Text(quantiatotal,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.0,
                              ))),
                      tileColor: Color.fromRGBO(0, 151, 178, 1),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 10.0), // Espaçamento interno
                    );
                }
              }),
          SizedBox(height: 20),
          ElevatedButton.icon(
            icon: Icon(Icons.timer_outlined),
            onPressed: () {
              LocalNotifications.showPeriodicNotifications(
                  title: "Periodic Notification",
                  body: "This is a Periodic Notification",
                  payload: "This is periodic data");
            },
            label: Text("Notificações periódicas"),
          ),
          SizedBox(height: 20),
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
            child: Text("Hidratando-se",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ))),
        backgroundColor: const Color.fromRGBO(0, 151, 178, 1),
      ),
      body: ListView(
        children: [
          SizedBox(height: 10),
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
            child: const Text('+1 COPO',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )),
          ),
          SizedBox(height: 10),
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
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )),
          ),
          SizedBox(height: 20),
          Center(
            child: Container(
              width: 200.0,
              height: 100.0,
              child: ListTile(
                  title: Text("Lembre-se",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
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
//

final navigatorKey = GlobalKey<NavigatorState>();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void notificacao() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotifications.init();

//  handle in terminated state
  var initialNotification =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if (initialNotification?.didNotificationLaunchApp == true) {
    // LocalNotifications.onClickNotification.stream.listen((event) {
    Future.delayed(Duration(seconds: 3), () {
      // print(event);
      navigatorKey.currentState!.pushNamed('/another',
          arguments: initialNotification?.notificationResponse?.payload);
    });
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const TelaPrincipal(),
        '/another': (context) => Cadastro(),
      },
    );
  }
}
