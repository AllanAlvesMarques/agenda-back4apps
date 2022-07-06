import 'package:agenda/dio/dio_controllers/dio_usuarios_database_controller.dart';
import 'package:agenda/models/usuario_model.dart';
import 'package:agenda/views/cadastrar_alterar_usuario.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routes/app_routes.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late DioUsuariosDatabaseController usuariosDB;
  final _form = GlobalKey<FormState>();
  bool visible = false;
  List listaUsuarios = [];
  UsuarioModel? valueChoose;
  late TextEditingController senhaController;
  bool permanecerLogado = false;

  @override
  void initState() {
    super.initState();
    senhaController = TextEditingController();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    usuariosDB =
        Provider.of<DioUsuariosDatabaseController>(context, listen: false);
    await atualizarListaUsuarios();
  }

  atualizarListaUsuarios() async {
    await usuariosDB.getUsuarios();

    setState(() {
      listaUsuarios = usuariosDB.usuarios;
      valueChoose = null;
      senhaController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _form,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo.jpg',
                    width: 180,
                  ),
                  DropdownButtonFormField<UsuarioModel>(
                    hint: const Text('Selecione a conta'),
                    validator: (value) {
                      if (value == null) {
                        return 'Selecione um usuário';
                      }

                      return null;
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                    ),
                    isExpanded: true,
                    value: valueChoose,
                    onChanged: (value) {
                      setState(
                        () {
                          valueChoose = value;
                        },
                      );
                    },
                    items: listaUsuarios.map(
                      (e) {
                        return DropdownMenuItem<UsuarioModel>(
                          value: e,
                          child: Text(e.login ?? ''),
                        );
                      },
                    ).toList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 26.0, bottom: 16),
                    child: TextFormField(
                      controller: senhaController,
                      obscureText: !visible,
                      validator: (value) {
                        if (value == '') {
                          return 'Digite a senha correta';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Senha:",
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(
                              () {
                                visible = !visible;
                              },
                            );
                          },
                          icon: Icon(visible
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const Text(
                        'Permanecer logado:',
                        style: TextStyle(fontSize: 16),
                      ),
                      Switch(
                        value: permanecerLogado,
                        onChanged: (value) {
                          setState(
                            () {
                              permanecerLogado = value;
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: SizedBox(
                      height: 50,
                      width: 190,
                      child: Consumer<DioUsuariosDatabaseController>(
                        builder: (context, controller, child) {
                          return listaUsuarios.isNotEmpty
                              ? ElevatedButton(
                                  onPressed: () async {
                                    await usuariosDB.login(
                                        valueChoose!.username!,
                                        senhaController.text);
                                    final isValid =
                                        _form.currentState?.validate();

                                    if (isValid!) {
                                      entranoapp();
                                    }
                                  },
                                  child: const Text(
                                    'Entrar',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return CadastrarAlterarUsuario(null);
                                        },
                                      ),
                                    ).then((value) => atualizarListaUsuarios());
                                  },
                                  child: const Text(
                                    'Cadastrar',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void entranoapp() async {
    Navigator.of(context).pushNamed(AppRoutes.listaContatos).then(
      (_) {
        atualizarListaUsuarios();
      },
    );
    valueChoose!.permanecerLogado = permanecerLogado;
    usuariosDB.usuarioLogado = valueChoose;
    await usuariosDB.updateUsuario(valueChoose!);
  }
}
