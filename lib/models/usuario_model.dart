// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UsuarioModel {
  String? objectId;
  String? username;
  String? login;
  String? password;
  bool permanecerLogado = false;
  UsuarioModel({
    this.objectId,
    this.username,
    this.login,
    this.password,
    required this.permanecerLogado,
  });

  UsuarioModel copyWith({
    String? objectId,
    String? username,
    String? login,
    String? password,
    bool? permanecerLogado,
  }) {
    return UsuarioModel(
      objectId: objectId ?? this.objectId,
      username: username ?? this.username,
      login: login ?? this.login,
      password: password ?? this.password,
      permanecerLogado: permanecerLogado ?? this.permanecerLogado,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'objectId': objectId,
      'username': username,
      'login': login,
      'password': password,
      'permanecerLogado': permanecerLogado,
    };
  }

  factory UsuarioModel.fromMap(Map<String, dynamic> map) {
    return UsuarioModel(
      objectId: map['objectId'] != null ? map['objectId'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      login: map['login'] != null ? map['login'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      permanecerLogado: map['permanecerLogado'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory UsuarioModel.fromJson(String source) =>
      UsuarioModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UsuarioModel(objectId: $objectId, username: $username, login: $login, password: $password, permanecerLogado: $permanecerLogado)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UsuarioModel &&
        other.objectId == objectId &&
        other.username == username &&
        other.login == login &&
        other.password == password &&
        other.permanecerLogado == permanecerLogado;
  }

  @override
  int get hashCode {
    return objectId.hashCode ^
        username.hashCode ^
        login.hashCode ^
        password.hashCode ^
        permanecerLogado.hashCode;
  }
}
