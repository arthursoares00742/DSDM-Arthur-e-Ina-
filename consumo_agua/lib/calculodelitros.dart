// import 'dart:io';

// void main() {
//   List<int> totalPorDia = [];
//   int totalMlSemana = 0;
//   bool encerrarSemana = false;

//   Map<String, int> testebanco = {
//     '2024-08-01': 2000,
//     '2024-07-31': 800,
//     '2024-07-30': 1000
//   };

//   while (!encerrarSemana) {
//     int totalMlDia = 0;

//     print(
//         "Digite 'começar' para iniciar um novo dia ou 'encerrar' para fechar a semana:");
//     String? comando = stdin.readLineSync();

//     if (comando == 'encerrar') {
//       encerrarSemana = true;
//     } else if (comando == 'começar') {
//       for (int dia = 1; dia <= 7; dia++) {
//         print(
//             "Quantos ml de água você bebeu hoje? (Digite '0' para encerrar o dia)");
//         String? input = stdin.readLineSync();
//         int? ml = int.tryParse(input!);

//         if (ml == 0) {
//           totalPorDia.add(totalMlDia);
//           totalMlSemana += totalMlDia;
//           print("Dia $dia encerrado. Total de hoje: $totalMlDia ml\n");
//           break;
//         } else if (ml != null) {
//           totalMlDia += ml;
//           print("Total acumulado hoje: $totalMlDia ml");
//         } else {
//           print("Entrada inválida. Por favor, digite um número inteiro.");
//         }
//       }
//     } else {
//       print("Comando inválido.");
//     }
//   }
//   print("\nTotal de ml consumidos na semana: $totalMlSemana ml");
//   print("Detalhes por dia:");
//   for (int i = 0; i < totalPorDia.length; i++) {
//     print("Dia ${i + 1}: ${totalPorDia[i]} ml");
//   }
// }
