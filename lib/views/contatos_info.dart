import 'package:agenda/models/contatos_model.dart';
import 'package:agenda/models/telefone_model.dart';
import 'package:agenda/views/cadastrar_alterar_contatos.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../dio/dio_controllers/dio_contatos_database_controller.dart';
import '../dio/dio_controllers/dio_telefone_database_controller.dart';

class ContatosInfo extends StatefulWidget {
  ContatosInfo(this.contato, this.telefone, {Key? key}) : super(key: key);

  ContatosModel contato;
  TelefoneModel telefone;

  @override
  State<ContatosInfo> createState() => _ContatosInfoState();
}

class _ContatosInfoState extends State<ContatosInfo> {
  late DioContatosDatabaseController contatosDB;
  late DioTelefoneDatabeseController telefonesDB;

  final personIcon = 'assets/images/person_icon.png';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    contatosDB =
        Provider.of<DioContatosDatabaseController>(context, listen: false);
    telefonesDB =
        Provider.of<DioTelefoneDatabeseController>(context, listen: false);
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
                        widget.contato, widget.telefone);
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
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  infoContatoLayout('Id'),
                  infoContatoLayout('Email'),
                  infoContatoLayout('Telefone1'),
                  // widget.telefone.numeroTelefone2 != null
                  //     ? infoContatoLayout('Telefone2')
                  //     : Container(),
                  // widget.telefone.numeroTelefone3 != null
                  //     ? infoContatoLayout('Telefone3')
                  //     : Container(),
                  // widget.telefone.numeroTelefone4 != null
                  //     ? infoContatoLayout('Telefone4')
                  //     : Container(),
                  // widget.telefone.numeroTelefone5 != null
                  //     ? infoContatoLayout('Telefone5')
                  //     : Container(),
                  const SizedBox(
                    height: 35,
                  )
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
    await telefonesDB.deleteTelefone(
        widget.telefone.objectId!, widget.telefone);
    await contatosDB.deleteContato(widget.contato.objectId!, widget.contato);
  }

  infoContatoLayout(String nomeDoDado) {
    const blueColor = Colors.indigo;
    Widget tipoInfo = const Text('');
    Widget icone = const Icon(
      Icons.error,
      size: 30,
    );

    /*switch (nomeDoDado) {
      case 'Id':
        tipoInfo = Text(widget.contato.objectId!);

        icone = const Icon(
          Icons.select_all,
          size: 30,
          color: blueColor,
        );
        break;

      case 'Email':
        tipoInfo = Text(widget.contato.email ?? 'Não informado');

        icone = Icon(
          Icons.email,
          size: 30,
          color: widget.contato.email != null ? blueColor : Colors.grey,
        );
        break;

      case 'Telefone1':
        tipoInfo = Text(widget.telefone.numeroTelefone1 ?? 'Não informado');

        switch (widget.telefone.tipoTelefone1 ?? '') {
          case 'Whatsapp':
            icone = Image.asset(
              'assets/images/whatsapp.png',
              width: 25,
              height: 25,
            );

            break;

          case 'Celular':
            icone = const Icon(
              Icons.smartphone,
              size: 30,
              color: blueColor,
            );
            break;

          case 'Residencial':
            icone = const Icon(
              Icons.home,
              size: 30,
              color: blueColor,
            );
            break;

          case 'Comercial':
            icone = const Icon(
              Icons.business,
              size: 30,
              color: blueColor,
            );
            break;

          case 'Recados':
            icone = const Icon(
              Icons.comment,
              size: 30,
              color: blueColor,
            );
            break;
        }
        break;

      case 'Telefone2':
        tipoInfo = Text(widget.telefone.numeroTelefone2!);

        switch (widget.telefone.tipoTelefone2 ?? '') {
          case 'Whatsapp':
            icone = Image.asset(
              'assets/images/whatsapp.png',
              width: 30,
              height: 30,
            );

            break;

          case 'Celular':
            icone = const Icon(
              Icons.smartphone,
              size: 30,
              color: blueColor,
            );
            break;

          case 'Residencial':
            icone = const Icon(
              Icons.home,
              size: 30,
              color: blueColor,
            );
            break;

          case 'Comercial':
            icone = const Icon(
              Icons.business,
              size: 30,
              color: blueColor,
            );
            break;

          case 'Recados':
            icone = const Icon(
              Icons.comment,
              size: 30,
              color: blueColor,
            );
            break;
        }
        break;

      case 'Telefone3':
        tipoInfo = Text(widget.telefone.numeroTelefone3!);

        switch (widget.telefone.tipoTelefone3 ?? '') {
          case 'Whatsapp':
            icone = Image.asset(
              'assets/images/whatsapp.png',
              width: 30,
              height: 30,
            );

            break;

          case 'Celular':
            icone = const Icon(
              Icons.smartphone,
              size: 30,
              color: blueColor,
            );
            break;

          case 'Residencial':
            icone = const Icon(
              Icons.home,
              size: 30,
              color: blueColor,
            );
            break;

          case 'Comercial':
            icone = const Icon(
              Icons.business,
              size: 30,
              color: blueColor,
            );
            break;

          case 'Recados':
            icone = const Icon(
              Icons.comment,
              size: 30,
              color: blueColor,
            );
            break;
        }
        break;

      case 'Telefone4':
        tipoInfo = Text(widget.telefone.numeroTelefone4!);

        switch (widget.telefone.tipoTelefone4 ?? '') {
          case 'Whatsapp':
            icone = Image.asset(
              'assets/images/whatsapp.png',
              width: 30,
              height: 30,
            );

            break;

          case 'Celular':
            icone = const Icon(
              Icons.smartphone,
              size: 30,
              color: blueColor,
            );
            break;

          case 'Residencial':
            icone = const Icon(
              Icons.home,
              size: 30,
              color: blueColor,
            );
            break;

          case 'Comercial':
            icone = const Icon(
              Icons.business,
              size: 30,
              color: blueColor,
            );
            break;

          case 'Recados':
            icone = const Icon(
              Icons.comment,
              size: 30,
              color: blueColor,
            );
            break;
        }
        break;

      case 'Telefone5':
        tipoInfo = Text(widget.telefone.numeroTelefone5!);

        switch (widget.telefone.tipoTelefone5 ?? '') {
          case 'Whatsapp':
            icone = Image.asset(
              'assets/images/whatsapp.png',
              width: 30,
              height: 30,
            );

            break;

          case 'Celular':
            icone = const Icon(
              Icons.smartphone,
              size: 30,
              color: blueColor,
            );
            break;

          case 'Residencial':
            icone = const Icon(
              Icons.home,
              size: 30,
              color: blueColor,
            );
            break;

          case 'Comercial':
            icone = const Icon(
              Icons.business,
              size: 30,
              color: blueColor,
            );
            break;

          case 'Recados':
            icone = const Icon(
              Icons.comment,
              size: 30,
              color: blueColor,
            );
            break;
        }
        break;
    }*/

    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 4),
      child: Card(
        elevation: 0.0,
        color: const Color.fromARGB(0, 255, 16, 16),
        child: ListTile(leading: icone, title: tipoInfo),
      ),
    );
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
