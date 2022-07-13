import 'package:agenda/models/contatos_model.dart';
import 'package:agenda/models/telefone_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../dio/dio_controllers/dio_contatos_database_controller.dart';
import '../dio/dio_controllers/dio_telefone_database_controller.dart';

// ignore: must_be_immutable
class CadastrarAlterarContatos extends StatefulWidget {
  CadastrarAlterarContatos(this.contato, this.telefoneContato, {Key? key})
      : super(key: key);

  ContatosModel? contato;
  List<TelefoneModel>? telefoneContato;

  @override
  State<CadastrarAlterarContatos> createState() =>
      _CadastrarAlterarContatosState();
}

class _CadastrarAlterarContatosState extends State<CadastrarAlterarContatos> {
  late DioContatosDatabaseController contatosDB;
  late DioTelefoneDatabeseController telefonesDB;

  @override
  void initState() {
    super.initState();

    widget.contato ??= ContatosModel();

    widget.telefoneContato ??= <TelefoneModel>[];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    contatosDB =
        Provider.of<DioContatosDatabaseController>(context, listen: false);
    telefonesDB =
        Provider.of<DioTelefoneDatabeseController>(context, listen: false);
  }

  final _form = GlobalKey<FormState>();
  final _form2 = GlobalKey<FormState>();

  List<String> listaTiposTelefone = [
    'Whatsapp',
    'Residencial',
    'Comercial',
    'Celular',
    'Recados'
  ];

  String? numeroTel;
  String? valueChoose;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_call),
        onPressed: () {
          dialogAddTelefone('Adicionar telefone', null, null);
        },
      ),
      appBar: AppBar(
        title: const Text('Cadastrar'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              final isValid = _form.currentState?.validate();
              if (isValid!) {
                _form.currentState!.save();
                salvarContato(context).then((value) {
                  Navigator.pop(context, widget.contato);
                });
              }
            },
          )
        ],
      ),
      body: Form(
        key: _form,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  initialValue: widget.contato?.nome,
                  validator: (value) {
                    if (value == '' || value == null) {
                      return 'Informe o nome';
                    }
                    if (value.length < 3) {
                      return 'Nome muito curto';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nome:',
                  ),
                  onSaved: (value) => widget.contato?.nome = value!,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  initialValue: widget.contato?.foto,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Url da foto:",
                  ),
                  onSaved: (value) => widget.contato?.foto = value,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  initialValue: widget.contato?.email,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'E-mail invalido, informe o E-mail';
                    }
                    if (value.trim().contains('@') == false &&
                        value.trim().length < 2) {
                      return 'Digite um E-mail valido';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'E-mail:',
                  ),
                  onSaved: (value) => widget.contato!.email = value!,
                ),
              ),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: widget.telefoneContato!.length,
                itemBuilder: ((context, index) {
                  return ListTile(
                    title: Text(widget.telefoneContato![index].numeroTelefone),
                    leading: adicionaIconeTelefone(
                        widget.telefoneContato![index].tipoTelefone),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              dialogAddTelefone('Editar telefone',
                                  widget.telefoneContato![index], index);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                        'Deseja deletar este telefone?'),
                                    content: const Text(
                                        'Este telefone será apagado'),
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
                                          await telefonesDB.deleteEsseTelefone(
                                              widget.telefoneContato![index]);
                                          widget.telefoneContato!
                                              .removeAt(index);
                                          setState(() {
                                            widget.telefoneContato;
                                          });
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
                }),
              )
            ],
          ),
        ),
      ),
    );
  }

  salvarContato(context) async {
    if (widget.contato?.objectId == null) {
      await contatosDB.adicionarContatos(widget.contato!);

      for (var element in widget.telefoneContato!) {
        element.idContato = contatosDB.idUltimoContato;
      }

      await telefonesDB.adicionarTelefone(
          widget.telefoneContato!, widget.contato!.objectId!);
    } else {
      await contatosDB.updateContatos(widget.contato!);

      await telefonesDB.updateTelefone(
          widget.telefoneContato!, widget.contato!.objectId!);
    }
  }

  adicionaIconeTelefone(String tipoTelefone) {
    const blueColor = Colors.indigo;
    Widget icone = const Icon(Icons.error, size: 30);

    switch (tipoTelefone) {
      case 'wha':
        icone = Image.asset(
          'assets/images/whatsapp.png',
          width: 25,
          height: 25,
        );

        break;

      case 'cel':
        icone = const Icon(
          Icons.smartphone,
          size: 30,
          color: blueColor,
        );
        break;

      case 'res':
        icone = const Icon(
          Icons.home,
          size: 30,
          color: blueColor,
        );
        break;

      case 'com':
        icone = const Icon(
          Icons.business,
          size: 30,
          color: blueColor,
        );
        break;

      case 'rec':
        icone = const Icon(
          Icons.comment,
          size: 30,
          color: blueColor,
        );
        break;
    }
    return icone;
  }

  dialogAddTelefone(String title, TelefoneModel? telefone, int? index) {
    valueChoose = telefone?.tipoTelefone;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: _form2,
          child: AlertDialog(
            title: Center(
              child: Text(title),
            ),
            content: SizedBox(
              height: 150,
              child: Column(
                children: [
                  TextFormField(
                      keyboardType: TextInputType.phone,
                      initialValue: telefone?.numeroTelefone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Telefone invalido, informe o telefone';
                        }
                        if (value.trim().length < 13 ||
                            value.trim().length > 14) {
                          return 'Digite um telefone valido, ex: (xx) xxxx-xxxx';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Número:',
                      ),
                      onSaved: (value) => numeroTel = value),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: DropdownButtonFormField<String>(
                      hint: const Text('Selecione o tipo do telefone'),
                      validator: (value) {
                        if (value == null) {
                          return 'Selecione um o tipo do telefone';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.settings_cell),
                      ),
                      isExpanded: true,
                      value: valueChoose,
                      onChanged: (value) {
                        setState(
                          () {
                            valueChoose = converteTipoTelefone(value!);
                          },
                        );
                      },
                      items: listaTiposTelefone.map(
                        (e) {
                          return DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('Adicionar'),
                onPressed: () async {
                  final isValid = _form2.currentState?.validate();
                  if (isValid!) {
                    _form2.currentState?.save();
                    if (telefone == null) {
                      widget.telefoneContato!.add(TelefoneModel(
                          idContato: '',
                          numeroTelefone: numeroTel!,
                          tipoTelefone: valueChoose!));
                    } else {
                      widget.telefoneContato!.removeAt(index!);
                      telefone.numeroTelefone = numeroTel!;
                      telefone.tipoTelefone = valueChoose!;
                      widget.telefoneContato!.add(telefone);
                    }
                    setState(() {
                      widget.telefoneContato;
                    });

                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String converteTipoTelefone(String value) {
    String tipoValue = '';
    switch (value) {
      case 'Whatsapp':
        tipoValue = 'wha';
        break;
      case 'Residencial':
        tipoValue = 'res';
        break;
      case 'Comercial':
        tipoValue = 'com';
        break;
      case 'Celular':
        tipoValue = 'cel';
        break;
      case 'Recados':
        tipoValue = 'rec';
        break;
    }
    return tipoValue;
  }
}
