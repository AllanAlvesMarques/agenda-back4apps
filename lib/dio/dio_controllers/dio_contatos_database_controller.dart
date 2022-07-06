import 'package:agenda/dio/dio_config.dart';
import 'package:agenda/models/contatos_model.dart';
import 'package:flutter/material.dart';

class DioContatosDatabaseController extends ChangeNotifier {
  List _contatos = [];
  List get contatos => _contatos;
  late String idUltimoContato;

  Future<void> getContatos() async {
    var http = DioConfig.getDio();
    var response = await http.get('/classes/contatos?include=idTelefone');
    _contatos = response.data['results'].isNotEmpty
        ? response.data['results'].map((c) => ContatosModel.fromMap(c)).toList()
        : [];
    notifyListeners();
  }

  Future<void> adicionarContatos(ContatosModel contato) async {
    var http = DioConfig.getDio();
    var response = await http.post('/classes/contatos', data: contato.toJson());
    idUltimoContato = response.data['objectId'];
    contato.objectId = idUltimoContato;
    contatos.add(contato);
    notifyListeners();
  }

  Future<void> updateContatos(ContatosModel contato) async {
    var http = DioConfig.getDio();
    http.put('/classes/contatos/${contato.objectId}', data: contato.toJson());
    notifyListeners();
  }

  Future<void> deleteContato(String id, ContatosModel contato) async {
    var http = DioConfig.getDio();
    http.delete('/classes/contatos/$id');
    contatos.remove(contato);
    notifyListeners();
  }
}
