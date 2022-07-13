import 'package:agenda/dio/dio_controllers/dio_usuarios_database_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsuarioLogadoSistemaBottomWidget extends StatefulWidget {
  const UsuarioLogadoSistemaBottomWidget({Key? key}) : super(key: key);

  @override
  State<UsuarioLogadoSistemaBottomWidget> createState() =>
      _UsuarioLogadoSistemaBottomWidgetState();
}

class _UsuarioLogadoSistemaBottomWidgetState
    extends State<UsuarioLogadoSistemaBottomWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15),
          topLeft: Radius.circular(15),
        ),
      ),
      height: 40,
      width: double.infinity,
      //color: Colors.indigo,
      child: Padding(
        padding: const EdgeInsets.all(11),
        child: Text(
          'O usuário: ${Provider.of<DioUsuariosDatabaseController>(context).usuarioLogado!.username}, está logado no sistema',
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
