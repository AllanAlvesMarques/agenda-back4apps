import 'package:agenda/dio/dio_controllers/dio_usuarios_database_controller.dart';
import 'package:agenda/models/usuario_model.dart';
import 'package:agenda/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<bool?> showWarning(BuildContext context) async => showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Fazer Logof'),
        content: const Text('Você deseja sair da sua conta?'),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text('Sair'),
            onPressed: () async {
              UsuarioModel? usuarioLogado =
                  Provider.of<DioUsuariosDatabaseController>(context,
                          listen: false)
                      .usuarioLogado!;
              await Provider.of<DioUsuariosDatabaseController>(context,
                      listen: false)
                  .updateUsuario(usuarioLogado);
              usuarioLogado = null;
              Navigator.pushNamedAndRemoveUntil(
                  context, AppRoutes.loginPage, (route) => false);
            },
          )
        ],
      ),
    );
