import 'package:agenda/models/telefone_model.dart';
import 'package:flutter/material.dart';

import '../dio_config.dart';

class DioTelefoneDatabeseController extends ChangeNotifier {
  List _telefone = [];
  List get telefone => _telefone;

  getTelefones() async {
    var http = DioConfig.getDio();
    var response = await http.get('/classes/telefone');
    _telefone = response.data['results'].isNotEmpty
        ? response.data['results'].map((c) => TelefoneModel.fromMap(c)).toList()
        : [];
    notifyListeners();
  }

  adicionarTelefone(TelefoneModel tel) async {
    var http = DioConfig.getDio();
    var response = await http.post('/classes/telefone', data: tel.toJson());
    tel.objectId = response.data['objectId'];
    telefone.add(tel);
    notifyListeners();
  }

  Future<void> updateTelefone(TelefoneModel tel) async {
    var http = DioConfig.getDio();
    http.put('/classes/telefone/${tel.objectId}', data: tel.toJson());
    notifyListeners();
  }

  Future<void> deleteTelefone(String id, TelefoneModel tel) async {
    var http = DioConfig.getDio();
    http.delete('/classes/telefone/$id');
    telefone.remove(tel);
    notifyListeners();
  }
}
