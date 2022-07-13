import 'package:agenda/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dio/dio_controllers/dio_contatos_database_controller.dart';
import 'dio/dio_controllers/dio_telefone_database_controller.dart';
import 'dio/dio_controllers/dio_usuarios_database_controller.dart';
import 'views/lista_contatos.dart';
import 'views/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DioUsuariosDatabaseController>(
            create: (context) => DioUsuariosDatabaseController()),
        ChangeNotifierProvider<DioContatosDatabaseController>(
            create: (context) => DioContatosDatabaseController()),
        ChangeNotifierProvider<DioTelefoneDatabeseController>(
            create: (context) => DioTelefoneDatabeseController()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          // appBarTheme:
          //     const AppBarTheme(color: Color.fromARGB(255, 40, 141, 192)),
          // buttonTheme: const ButtonThemeData(
          //     buttonColor: Color.fromARGB(255, 37, 125, 169),
          //     focusColor: Color.fromARGB(255, 0, 0, 0)),
          // colorScheme: const ColorScheme(
          //   background: Color.fromARGB(255, 37, 125, 169),
          //   brightness: Brightness.light,
          //   error: Colors.red,
          //   onBackground: Colors.white,
          //   onError: Colors.red,
          //   onPrimary: Colors.white,
          //   onSecondary: Colors.white,
          //   onSurface: Color.fromARGB(255, 37, 125, 169),
          //   primary: Color.fromARGB(255, 37, 125, 169),
          //   secondary: Color.fromARGB(255, 34, 108, 146),
          //   surface: Color.fromARGB(255, 37, 125, 169),
          // ),
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          AppRoutes.loginPage: (_) => const Login(),
          AppRoutes.listaContatos: (_) => const ListaContatos(),
        },
      ),
    );
  }
}
