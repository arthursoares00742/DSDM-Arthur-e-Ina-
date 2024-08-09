import 'dart:io';

void main() {
  List<int> totalPorDia = [];
  int totalMlSemana = 0;
  bool encerrarSemana = false;

  while (!encerrarSemana) {
    int totalMlDia = 0;

    print(
        "Digite 'comecar' para iniciar um novo dia ou 'encerrar' para fechar a semana:");
    String? comando = stdin.readLineSync();

    if (comando == 'encerrar') {
      encerrarSemana = true;
    } else if (comando == 'comecar') {
      for (int dia = 1; dia <= 7; dia++) {
        print(
            "Quantos ml de água você bebeu hoje? (Digite '0' para encerrar o dia)");
        String? input = stdin.readLineSync();
        int? ml = int.tryParse(input!);

        if (ml == 0) {
          totalPorDia.add(int.parse(ml.toString()));
          totalMlSemana += totalMlDia;
          print("Dia $dia encerrado. Total de hoje: $totalMlDia ml\n");
          break;
        } else if (ml != null && ml > 0) {
          totalPorDia.add(int.parse(ml.toString()));
          totalMlDia += ml;
          print("Total acumulado hoje: $totalMlDia ml");
        } else {
          print(
              "Entrada inválida. Por favor, digite um número inteiro positivo.");
        }

        if (dia == 7 && !encerrarSemana) {
          print("A semana está completa.");
          totalPorDia.add(int.parse(ml.toString()));
          totalMlSemana += totalMlDia;
        }
      }
    } else {
      print("Comando inválido.");
    }
  }

  print("\nTotal de ml consumidos na semana: $totalMlSemana ml");
  print("Total por dia: " + totalPorDia.toString());
  for (int i = 0; i < totalPorDia.length; i++) {
    print("Dia ${i}: ${totalPorDia[i]} ml");
  }
}
