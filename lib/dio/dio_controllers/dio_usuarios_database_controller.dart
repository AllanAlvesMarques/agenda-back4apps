import 'package:agenda/models/usuario_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../dio_config.dart';

class DioUsuariosDatabaseController extends ChangeNotifier {
  List _usuarios = [];
  List get usuarios => _usuarios;
  late String idUltimoUsuarios;
  late String sessionToken;
  UsuarioModel? usuarioLogado;

  Future<void> getUsuarios() async {
    var http = DioConfig.getDio();
    var response = await http.get('/users');
    _usuarios = response.data['results'].isNotEmpty
        ? response.data['results'].map((c) => UsuarioModel.fromMap(c)).toList()
        : [];

    notifyListeners();
  }

  Future<void> login(String username, String password) async {
    var http = Dio();
    var response = await http.get(
      'https://parseapi.back4app.com/login',
      queryParameters: {
        "username": username,
        "password": password,
      },
      options: Options(
        headers: {
          "X-Parse-Application-Id": "o4hycDF1uorSATkt2kg48vaMIdm87xFKlytEVUXO",
          "X-Parse-REST-API-Key": "nYmABbSUyKFdNhHEkJhg7G74jWCMBoe44iJn6Bdk",
          "X-Parse-Revocable-Session": "1"
        },
      ),
    );
    sessionToken = response.data["sessionToken"];
    print('TOKEENNNNNNN ${sessionToken}');
    notifyListeners();
  }

  Future<void> adicionarUsuario(UsuarioModel usuario) async {
    var http = Dio();
    var response = await http.post(
      'https://parseapi.back4app.com/users',
      data: usuario.toJson(),
      options: Options(
        headers: {
          "X-Parse-Application-Id": "o4hycDF1uorSATkt2kg48vaMIdm87xFKlytEVUXO",
          "X-Parse-REST-API-Key": "nYmABbSUyKFdNhHEkJhg7G74jWCMBoe44iJn6Bdk",
          "X-Parse-Revocable-Session": "1",
          "Content-Type": "application/json"
        },
      ),
    );
    idUltimoUsuarios = response.data['objectId'];
    usuario.objectId = idUltimoUsuarios;
    usuarios.add(usuario);
    notifyListeners();
  }

  Future<void> updateUsuario(UsuarioModel usuario) async {
    var http = Dio();
    http.put(
      'https://parseapi.back4app.com/users/${usuario.objectId}',
      data: usuario.toJson(),
      options: Options(
        headers: {
          "X-Parse-Application-Id": "o4hycDF1uorSATkt2kg48vaMIdm87xFKlytEVUXO",
          "X-Parse-REST-API-Key": "nYmABbSUyKFdNhHEkJhg7G74jWCMBoe44iJn6Bdk",
          "X-Parse-Session-Token": sessionToken,
          "Content-Type": "application/json"
        },
      ),
    );

    notifyListeners();
  }

  Future<void> deleteUsuario(UsuarioModel usuario) async {
    var http = Dio();
    http.delete(
      'https://parseapi.back4app.com/users/${usuario.objectId}',
      options: Options(
        headers: {
          "X-Parse-Application-Id": "o4hycDF1uorSATkt2kg48vaMIdm87xFKlytEVUXO",
          "X-Parse-REST-API-Key": "nYmABbSUyKFdNhHEkJhg7G74jWCMBoe44iJn6Bdk",
          "X-Parse-Session-Token": sessionToken,
          "Content-Type": "application/json"
        },
      ),
    );
    usuarios.remove(usuario);
    notifyListeners();
  }
}
