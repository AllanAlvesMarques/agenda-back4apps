import 'package:agenda/models/contatos_model.dart';
import 'package:agenda/models/telefone_model.dart';
import 'package:agenda/views/cadastrar_alterar_contatos.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../dio/dio_controllers/dio_contatos_database_controller.dart';
import '../dio/dio_controllers/dio_telefone_database_controller.dart';

// ignore: must_be_immutable
class ContatosInfo extends StatefulWidget {
  ContatosInfo(this.contato, {Key? key}) : super(key: key);

  ContatosModel contato;

  @override
  State<ContatosInfo> createState() => _ContatosInfoState();
}

class _ContatosInfoState extends State<ContatosInfo> {
  late DioContatosDatabaseController contatosDB;
  late DioTelefoneDatabeseController telefonesDB;
  List<TelefoneModel> telefoneContato = [];

  final personIcon = 'assets/images/person_icon.png';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    contatosDB =
        Provider.of<DioContatosDatabaseController>(context, listen: false);
    telefonesDB =
        Provider.of<DioTelefoneDatabeseController>(context, listen: false);
    telefoneContato = telefonesDB.telefone
        .where((element) => element.idContato == widget.contato.objectId)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      appBar: AppBar(
        title: const Text('Contatos Info'),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.create),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return CadastrarAlterarContatos(
                        widget.contato, telefoneContato);
                  },
                ),
              ).then(
                (value) {
                  setState(() {
                    widget.contato = value;
                  });
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => dialogDeleteContato()).then(
                (value) {
                  if (value) {
                    Navigator.pop(context);
                  }
                },
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 190.0,
                    height: 190.0,
                    child: getAvatarImage(widget.contato),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: SizedBox(
                    child: Text(
                      widget.contato.nome!,
                      style: const TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 4),
                    child: Card(
                      elevation: 0.0,
                      color: const Color.fromARGB(0, 255, 16, 16),
                      child: ListTile(
                        leading: const Icon(
                          Icons.select_all,
                          size: 30,
                          color: Colors.indigo,
                        ),
                        title: Text(widget.contato.objectId!),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 4),
                    child: Card(
                      elevation: 0.0,
                      color: const Color.fromARGB(0, 255, 16, 16),
                      child: ListTile(
                        leading: const Icon(
                          Icons.mail,
                          size: 30,
                          color: Colors.indigo,
                        ),
                        title: Text(widget.contato.email!),
                      ),
                    ),
                  ),
                  ListView.builder(
                    controller: ScrollController(keepScrollOffset: false),
                    shrinkWrap: true,
                    itemCount: telefoneContato.length,
                    itemBuilder: ((context, index) {
                      const blueColor = Colors.indigo;
                      Widget tipoInfo = const Text('');
                      Widget icone = const Icon(Icons.error, size: 30);

                      switch (telefoneContato[index].tipoTelefone) {
                        case 'wha':
                          tipoInfo =
                              Text(telefoneContato[index].numeroTelefone);
                          icone = Image.asset(
                            'assets/images/whatsapp.png',
                            width: 25,
                            height: 25,
                          );

                          break;

                        case 'cel':
                          tipoInfo =
                              Text(telefoneContato[index].numeroTelefone);
                          icone = const Icon(
                            Icons.smartphone,
                            size: 30,
                            color: blueColor,
                          );
                          break;

                        case 'res':
                          tipoInfo =
                              Text(telefoneContato[index].numeroTelefone);
                          icone = const Icon(
                            Icons.home,
                            size: 30,
                            color: blueColor,
                          );
                          break;

                        case 'com':
                          tipoInfo =
                              Text(telefoneContato[index].numeroTelefone);
                          icone = const Icon(
                            Icons.business,
                            size: 30,
                            color: blueColor,
                          );
                          break;

                        case 'rec':
                          tipoInfo =
                              Text(telefoneContato[index].numeroTelefone);
                          icone = const Icon(
                            Icons.comment,
                            size: 30,
                            color: blueColor,
                          );
                          break;
                      }

                      return Padding(
                        padding: const EdgeInsets.only(left: 8, top: 4),
                        child: Card(
                          elevation: 0.0,
                          color: const Color.fromARGB(0, 255, 16, 16),
                          child: ListTile(leading: icone, title: tipoInfo),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 35),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dialogDeleteContato() {
    return AlertDialog(
      title: const Text('Excluir contato'),
      content: const Text('Você tem certeza que deseja excluir este contato?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text('Não'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context, true);
            deletar(context);
          },
          child: const Text('Sim'),
        ),
      ],
    );
  }

  deletar(context) async {
    await telefonesDB.deleteTelefones(telefoneContato);
    await contatosDB.deleteContato(widget.contato.objectId!, widget.contato);
  }

  getAvatarImage(ContatosModel contato) {
    if (contato.foto == null || contato.foto == '') {
      return CircleAvatar(
        backgroundColor: Colors.white,
        backgroundImage: AssetImage(
          personIcon,
        ),
      );
    }
    return CircleAvatar(
      backgroundImage: NetworkImage(
        contato.foto.toString(),
      ),
    );
  }
}
