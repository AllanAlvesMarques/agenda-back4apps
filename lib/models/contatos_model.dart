// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ContatosModel {
  String? objectId;
  String? nome;
  String? foto;
  String? email;
  ContatosModel({
    this.objectId,
    this.nome,
    this.foto,
    this.email,
  });

  ContatosModel copyWith({
    String? objectId,
    String? nome,
    String? foto,
    String? email,
  }) {
    return ContatosModel(
      objectId: objectId ?? this.objectId,
      nome: nome ?? this.nome,
      foto: foto ?? this.foto,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'objectId': objectId,
      'nome': nome,
      'foto': foto,
      'email': email,
    };
  }

  factory ContatosModel.fromMap(Map<String, dynamic> map) {
    return ContatosModel(
      objectId: map['objectId'] != null ? map['objectId'] as String : null,
      nome: map['nome'] != null ? map['nome'] as String : null,
      foto: map['foto'] != null ? map['foto'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ContatosModel.fromJson(String source) =>
      ContatosModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ContatosModel(objectId: $objectId, nome: $nome, foto: $foto, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ContatosModel &&
        other.objectId == objectId &&
        other.nome == nome &&
        other.foto == foto &&
        other.email == email;
  }

  @override
  int get hashCode {
    return objectId.hashCode ^ nome.hashCode ^ foto.hashCode ^ email.hashCode;
  }
}
