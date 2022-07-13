import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../dio/dio_controllers/dio_usuarios_database_controller.dart';
import '../models/usuario_model.dart';
import 'cadastrar_alterar_usuario.dart';

class ListaUsuarios extends StatefulWidget {
  const ListaUsuarios({Key? key}) : super(key: key);

  @override
  State<ListaUsuarios> createState() => _ListaUsuariosState();
}

class _ListaUsuariosState extends State<ListaUsuarios> {
  late DioUsuariosDatabaseController usuariosDB;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    usuariosDB =
        Provider.of<DioUsuariosDatabaseController>(context, listen: false);
    await usuariosDB.getUsuarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return CadastrarAlterarUsuario(null);
              },
            ),
          );
        },
      ),
      appBar: AppBar(
        title: const Text('Usuários'),
        centerTitle: true,
      ),
      body: Consumer<DioUsuariosDatabaseController>(
        builder: (context, controller, child) {
          return ListView.builder(
            itemCount: controller.usuarios.length,
            itemBuilder: (BuildContext context, int index) {
              return _listaUsuarios(context, controller.usuarios[index], index);
            },
          );
        },
      ),
    );
  }

  _listaUsuarios(BuildContext context, UsuarioModel usuario, int index) {
    return ListTile(
      title: Text(usuario.username),
      leading: const Icon(Icons.person, size: 45),
      trailing: SizedBox(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return CadastrarAlterarUsuario(usuario);
                    },
                  ),
                );
              },
              icon: const Icon(Icons.create),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Deseja deletar este Usuário?'),
                      content: const Text('Este Usuário será apagado'),
                      actions: [
                        TextButton(
                          child: const Text('Cancelar'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        TextButton(
                          child: const Text('Deletar'),
                          onPressed: () async {
                            Navigator.pop(context);
                            if (usuario == usuariosDB.usuarioLogado) {
                              Navigator.pop(context, true);
                            }
                            await usuariosDB.deleteUsuario(usuario);
                            snackBarErro();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget snackBarErro() {
    return SnackBar(
      backgroundColor: Colors.red,
      content: Text('a'),
      action: SnackBarAction(
        label: 'Ok',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
  }
}
