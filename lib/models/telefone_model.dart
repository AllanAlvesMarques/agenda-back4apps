// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TelefoneModel {
  String? objectId;
  String idContato = '';
  String numeroTelefone = '';
  String tipoTelefone = '';
  TelefoneModel({
    this.objectId,
    required this.idContato,
    required this.numeroTelefone,
    required this.tipoTelefone,
  });

  TelefoneModel.semDados({
    this.objectId = '',
    this.idContato = '',
    this.numeroTelefone = '',
    this.tipoTelefone = '',
  });

  TelefoneModel copyWith({
    String? objectId,
    String? idContato,
    String? numeroTelefone,
    String? tipoTelefone,
  }) {
    return TelefoneModel(
      objectId: objectId ?? this.objectId,
      idContato: idContato ?? this.idContato,
      numeroTelefone: numeroTelefone ?? this.numeroTelefone,
      tipoTelefone: tipoTelefone ?? this.tipoTelefone,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'objectId': objectId,
      'idContato': idContato,
      'numeroTelefone': numeroTelefone,
      'tipoTelefone': tipoTelefone,
    };
  }

  factory TelefoneModel.fromMap(Map<String, dynamic> map) {
    return TelefoneModel(
      objectId: map['objectId'] != null ? map['objectId'] as String : null,
      idContato: map['idContato'] as String,
      numeroTelefone: map['numeroTelefone'] as String,
      tipoTelefone: map['tipoTelefone'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TelefoneModel.fromJson(String source) =>
      TelefoneModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TelefoneModel(objectId: $objectId, idContato: $idContato, numeroTelefone: $numeroTelefone, tipoTelefone: $tipoTelefone)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TelefoneModel &&
        other.objectId == objectId &&
        other.idContato == idContato &&
        other.numeroTelefone == numeroTelefone &&
        other.tipoTelefone == tipoTelefone;
  }

  @override
  int get hashCode {
    return objectId.hashCode ^
        idContato.hashCode ^
        numeroTelefone.hashCode ^
        tipoTelefone.hashCode;
  }
}
