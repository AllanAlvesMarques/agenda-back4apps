import 'package:agenda/models/telefone_model.dart';
import 'package:agenda/views/cadastrar_alterar_contatos.dart';
import 'package:agenda/views/contatos_info.dart';
import 'package:agenda/views/lista_usuarios.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/dialog_status_pedido.dart';
import '../components/usuario_logado_sistema_bottom_widget.dart';
import '../dio/dio_controllers/dio_contatos_database_controller.dart';
import '../dio/dio_controllers/dio_telefone_database_controller.dart';
import '../models/contatos_model.dart';

class ListaContatos extends StatefulWidget {
  const ListaContatos({Key? key}) : super(key: key);

  @override
  State<ListaContatos> createState() => _ListaContatosState();
}

class _ListaContatosState extends State<ListaContatos> {
  late DioContatosDatabaseController contatosDB;
  late DioTelefoneDatabeseController telefonesDB;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    contatosDB =
        Provider.of<DioContatosDatabaseController>(context, listen: false);
    telefonesDB =
        Provider.of<DioTelefoneDatabeseController>(context, listen: false);
    await carregaContatos(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await showWarning(context);

        return false;
      },
      child: Scaffold(
        bottomSheet: const UsuarioLogadoSistemaBottomWidget(),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.person_add),
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return CadastrarAlterarContatos(null, null);
                },
              ),
            ).then((value) async {
              await carregaContatos(context);
            });
          },
        ),
        appBar: AppBar(
          title: const Text('Agenda'),
          centerTitle: true,
          leading: TextButton(
            child: const Text(
              'Sair',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              await showWarning(context);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const ListaUsuarios();
                    },
                  ),
                ).then((value) => value ? Navigator.pop(context) : null);
              },
            )
          ],
        ),
        body: Consumer<DioContatosDatabaseController>(
          builder: (context, controller, child) {
            return ListView.builder(
              itemCount: controller.contatos.length,
              itemBuilder: (BuildContext context, int index) {
                return _listaContatos(
                    context, controller.contatos[index], index);
              },
            );
          },
        ),
      ),
    );
  }

  _listaContatos(BuildContext context, ContatosModel contato, int index) {
    adicionaAvatar() {
      if (contato.foto == null || contato.foto == '') {
        return const CircleAvatar(
            backgroundColor: Color.fromARGB(255, 226, 226, 226),
            radius: 25,
            backgroundImage: AssetImage('assets/images/person_icon.png'));
      } else {
        return CircleAvatar(
            radius: 25, backgroundImage: NetworkImage(contato.foto!));
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 5, top: 5),
      child: ListTile(
        leading: adicionaAvatar(),
        title: Text(contato.nome!),
        subtitle: Text(telefonesDB.telefone
            .firstWhere((telefone) => telefone.idContato == contato.objectId,
                orElse: () => TelefoneModel.semDados())
            .numeroTelefone),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ContatosInfo(contato);
            },
          ),
        ),
      ),
    );
  }

  carregaNumero() {
    if (telefonesDB.telefone.length == contatosDB.contatos.length) {
      return null;
    }
  }

  carregaContatos(context) async {
    await telefonesDB.getTelefones();
    await contatosDB.getContatos();
  }
}
