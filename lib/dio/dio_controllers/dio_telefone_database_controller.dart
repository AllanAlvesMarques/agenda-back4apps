import 'package:agenda/models/telefone_model.dart';
import 'package:flutter/material.dart';

import '../dio_config.dart';

class DioTelefoneDatabeseController extends ChangeNotifier {
  List<TelefoneModel> _telefone = [];
  List<TelefoneModel> get telefone => _telefone;

  getTelefones() async {
    var http = DioConfig.getDio();
    var response = await http.get('/classes/telefone');
    if (response.data['results'].isNotEmpty) {
      _telefone = (response.data['results'] as List)
          .map((c) => TelefoneModel.fromMap(c))
          .toList();
    }

    // _telefone = response.data['results'].isNotEmpty
    //     ? response.data['results'].map((c) => TelefoneModel.fromMap(c)).toList()
    //     : <TelefoneModel>[];

    notifyListeners();
  }

  adicionarTelefone(List<TelefoneModel> tels, String id) async {
    var http = DioConfig.getDio();
    for (var tel in tels) {
      tel.idContato = id;
      var response = await http.post('/classes/telefone', data: tel.toJson());
      tel.objectId = response.data['objectId'];
      _telefone.add(tel);
    }
    notifyListeners();
  }

  Future<void> updateTelefone(List<TelefoneModel> tels, String id) async {
    var http = DioConfig.getDio();
    for (var tel in tels) {
      if (tel.objectId == null) {
        await adicionarTelefone(<TelefoneModel>[tel], id);
        continue;
      }
      http.put('/classes/telefone/${tel.objectId}', data: tel.toJson());
    }
    notifyListeners();
  }

  Future<void> deleteTelefones(List<TelefoneModel> tels) async {
    var http = DioConfig.getDio();
    for (var tel in tels) {
      http.delete('/classes/telefone/${tel.objectId}');
      _telefone.remove(tel);
    }
    notifyListeners();
  }

  Future<void> deleteEsseTelefone(TelefoneModel tel) async {
    var http = DioConfig.getDio();
    http.delete('/classes/telefone/${tel.objectId}');
    _telefone.remove(tel);
    notifyListeners();
  }
}
