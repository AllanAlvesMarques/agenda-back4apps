import 'package:agenda/dio/dio_controllers/dio_usuarios_database_controller.dart';
import 'package:agenda/models/contatos_model.dart';
import 'package:agenda/models/telefone_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../dio/dio_controllers/dio_contatos_database_controller.dart';
import '../dio/dio_controllers/dio_telefone_database_controller.dart';

class CadastrarAlterarContatos extends StatefulWidget {
  CadastrarAlterarContatos(this.contato, this.telefone, {Key? key})
      : super(key: key);

  ContatosModel? contato;
  TelefoneModel? telefone;

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

    widget.telefone ??= TelefoneModel(telefones: {});
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
        child: const Icon(Icons.save),
        onPressed: () async {
          final isValid = _form.currentState?.validate();
          if (isValid!) {
            _form.currentState!.save();
            salvarContato(context).then((value) {
              Navigator.pop(context, widget.contato);
            });
          }
        },
      ),
      appBar: AppBar(
        title: const Text('Cadastrar'),
        centerTitle: true,
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

              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    child: const Text(
                      'Adcionar Telefones',
                      textScaleFactor: 1.5,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Form(
                            key: _form2,
                            child: AlertDialog(
                              title: const Center(
                                child: Text('Adicione telefones'),
                              ),
                              content: SizedBox(
                                height: 150,
                                child: adicionarTelefones(),
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
                                    final isValid =
                                        _form2.currentState?.validate();
                                    if (isValid!) {
                                      widget.telefone!.telefones!
                                          .addAll({numeroTel!: valueChoose!});
                                    }
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              )

              //   // Padding(
              //   //   padding: const EdgeInsets.all(16.0),
              //   //   child: TextFormField(
              //   //     validator: (value) {
              //   //       if (value == null || value.trim().isEmpty) {
              //   //         return 'Telefone invalido, informe o telefone';
              //   //       }
              //   //       if (value.trim().length < 13 || value.trim().length > 14) {
              //   //         return 'Digite um telefone valido, ex: (xx) xxxx-xxxx';
              //   //       }
              //   //       return null;
              //   //     },
              //   //     decoration: const InputDecoration(
              //   //       border: OutlineInputBorder(),
              //   //       labelText: 'Telefone:',
              //   //     ),
              //   //     onSaved: (value) => widget.telefone?.numeroTelefone1 = value!,
              //   //   ),
              //   // ),
              //   // Padding(
              //   //   padding: const EdgeInsets.all(16.0),
              //     // child: DropdownButtonFormField<String>(
              //     //   hint: const Text('Selecione o tipo do telefone'),
              //     //   validator: (value) {
              //     //     if (value == null) {
              //     //       return 'Selecione um o tipo do telefone';
              //     //     }
              //     //     return null;
              //     //   },
              //     //   decoration: const InputDecoration(
              //     //     prefixIcon: Icon(Icons.settings_cell),
              //     //     border: OutlineInputBorder(),
              //     //   ),
              //     //   isExpanded: true,
              //     //   value: valueChoose,
              //     //   onChanged: (value) {
              //     //     setState(
              //     //       () {
              //     //         valueChoose = value;
              //     //       },
              //     //     );
              //     //   },
              //     //   items: listaTiposTelefone.map(
              //     //     (e) {
              //     //       return DropdownMenuItem<String>(
              //     //         value: e,
              //     //         child: Text(e),
              //     //       );
              //     //     },
              //     //   ).toList(),
              //     // ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }

  salvarContato(context) async {
    if (widget.contato?.objectId == null) {
      await contatosDB.adicionarContatos(widget.contato!);

      widget.telefone!.idContato = contatosDB.idUltimoContato;

      await telefonesDB.adicionarTelefone(widget.telefone!);
    } else {
      await contatosDB.updateContatos(widget.contato!);

      await telefonesDB.updateTelefone(widget.telefone!);
    }
  }

  Widget adicionarTelefones() {
    return Column(
      children: [
        TextFormField(
            // validator: (value) {
            //   if (value == null || value.trim().isEmpty) {
            //     return 'Telefone invalido, informe o telefone';
            //   }
            //   if (value.trim().length < 13 || value.trim().length > 14) {
            //     return 'Digite um telefone valido, ex: (xx) xxxx-xxxx';
            //   }
            //   return null;
            // },
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
                  valueChoose = value;
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
    );
  }
}
