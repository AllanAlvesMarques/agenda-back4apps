// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class TelefoneModel {
  String? objectId;
  String? idContato;
  Map<String, String>? telefones = {};
  TelefoneModel({
    this.objectId,
    this.idContato,
    this.telefones,
  });

  TelefoneModel copyWith({
    String? objectId,
    String? idContato,
    Map<String, String>? telefones,
  }) {
    return TelefoneModel(
      objectId: objectId ?? this.objectId,
      idContato: idContato ?? this.idContato,
      telefones: telefones ?? this.telefones,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'objectId': objectId,
      'idContato': idContato,
      'telefones': telefones,
    };
  }

  factory TelefoneModel.fromMap(Map<String, dynamic> map) {
    return TelefoneModel(
      objectId: map['objectId'] != null ? map['objectId'] as String : null,
      idContato: map['idContato'] != null ? map['idContato'] as String : null,
      telefones: map['telefones'] != null
          ? Map<String, String>.from((map['telefones'] as Map<String, String>))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TelefoneModel.fromJson(String source) =>
      TelefoneModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'TelefoneModel(objectId: $objectId, idContato: $idContato, telefones: $telefones)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TelefoneModel &&
        other.objectId == objectId &&
        other.idContato == idContato &&
        mapEquals(other.telefones, telefones);
  }

  @override
  int get hashCode =>
      objectId.hashCode ^ idContato.hashCode ^ telefones.hashCode;
}
