// DEFINIR A ESTRUTURA DE AutofillGroupStat
// CLONE DA TABELA SÓ QUE EM CÓDIGO

class Agua {
  int? id;
  String data;
  final double consumo;

  Agua({this.id, required this.data, required this.consumo});

  Map<String, Object?> toMap() {
    return {'id': id, 'data': data, 'consumo': consumo};
  }
}
