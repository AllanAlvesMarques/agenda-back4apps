import 'package:agenda/dio/dio_controllers/dio_usuarios_database_controller.dart';
import 'package:agenda/models/usuario_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CadastrarAlterarUsuario extends StatefulWidget {
  CadastrarAlterarUsuario(this.usuario, {Key? key}) : super(key: key);

  UsuarioModel? usuario;

  @override
  State<CadastrarAlterarUsuario> createState() =>
      _CadastrarAlterarUsuarioState();
}

class _CadastrarAlterarUsuarioState extends State<CadastrarAlterarUsuario> {
  late DioUsuariosDatabaseController usuariosDB;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    usuariosDB =
        Provider.of<DioUsuariosDatabaseController>(context, listen: false);
    widget.usuario ??= UsuarioModel(permanecerLogado: false);
  }

  late String? senha1;

  late String? senha2;

  bool visible = false;

  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Usuários'),
        centerTitle: true,
      ),
      body: Form(
        key: _form,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 28, left: 16, right: 16, bottom: 26),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Nome:",
                    prefixIcon: Icon(Icons.person),
                  ),
                  initialValue: widget.usuario!.username,
                  validator: (value) {
                    if (value == null || value == '') {
                      return 'Este campo é obrigatorio';
                    }
                    return null;
                  },
                  onSaved: (value) => widget.usuario!.username = value!,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, left: 16, right: 16, bottom: 26),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Login:",
                    prefixIcon: Icon(Icons.account_circle_rounded),
                  ),
                  initialValue: widget.usuario!.login,
                  validator: (value) {
                    if (value == null || value == '') {
                      return 'Este campo é obrigatorio';
                    }
                    return null;
                  },
                  onSaved: (value) => widget.usuario!.login = value!,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, left: 16, right: 16, bottom: 26),
                child: TextFormField(
                  obscureText: !visible,
                  decoration: InputDecoration(
                    labelText: "Senha:",
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          visible = !visible;
                        });
                      },
                      icon: Icon(
                          visible ? Icons.visibility : Icons.visibility_off),
                    ),
                  ),
                  initialValue: widget.usuario!.password,
                  validator: (value) {
                    senha1 = value;
                    if (value == null || value == '') {
                      return 'Crie uma senha';
                    }
                    return null;
                  },
                  onSaved: (value) => widget.usuario!.password = value!,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, left: 16, right: 16, bottom: 26),
                child: TextFormField(
                  obscureText: !visible,
                  decoration: InputDecoration(
                    labelText: "Confirme a senha:",
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          visible = !visible;
                        });
                      },
                      icon: Icon(
                          visible ? Icons.visibility : Icons.visibility_off),
                    ),
                  ),
                  initialValue: widget.usuario!.password,
                  validator: (value) {
                    senha2 = value;
                    if (senha1 == senha2) {
                      return null;
                    } else {
                      return 'As senhas devem ser iguais';
                    }
                  },
                ),
              ),
              SizedBox(
                height: 60,
                width: 190,
                child: ElevatedButton(
                  child: const Text(
                    'Confirmar',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    final isValid = _form.currentState?.validate();
                    if (isValid!) {
                      _form.currentState!.save();
                      salvaUsuario(context, widget.usuario!);
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> salvaUsuario(BuildContext context, UsuarioModel usuario) async {
    Navigator.pop(context, usuario);
    if (usuario.objectId == null) {
      await usuariosDB.adicionarUsuario(usuario);
    } else {
      await usuariosDB.updateUsuario(usuario);
    }
  }
}
