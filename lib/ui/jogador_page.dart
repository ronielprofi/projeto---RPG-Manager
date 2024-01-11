import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';

import '../helpers/jogador_helper.dart';

import 'package:image_picker/image_picker.dart';

class JogadorPage extends StatefulWidget {

  final Jogador? jogador;

  JogadorPage({ this.jogador});

  @override
  State<JogadorPage> createState() => _JogadorPageState();
}

class _JogadorPageState extends State<JogadorPage> {

  final _jogadorController = TextEditingController();
  final _nomeController = TextEditingController();
  final _racaController = TextEditingController();

  final FocusNode _jogadorFocus = FocusNode();

  bool _userEdited = false;

  Jogador? _editedJogador;

  @override
  void initState() {
    super.initState();

    if(widget.jogador == null){
      _editedJogador = Jogador();
    } else {
      _editedJogador = Jogador.fromMap(widget.jogador!.toMap());

      _jogadorController.text = _editedJogador!.jogador!;
      _nomeController.text = _editedJogador!.nome!;
      _racaController.text = _editedJogador!.raca!;
    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: Text(_editedJogador?.nome ?? "Novo Contato"),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              if(_editedJogador!.jogador != null && _editedJogador!.jogador!.isNotEmpty){
                Navigator.pop(context, _editedJogador);
              } else {
                FocusScope.of(context).requestFocus(_jogadorFocus);
              }
            },
            child: Icon(Icons.save),
            backgroundColor: Colors.red,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    width: 140.0,
                    height: 140.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: _editedJogador?.img != null ?
                          FileImage(File(_editedJogador!.img!)) :
                          AssetImage("images/megaman-x.jpg") as ImageProvider
                      ),
                    ),
                  ),
                  onTap: (){
                    ImagePicker().pickImage(source: ImageSource.camera).then((file){
                      if(file != null) {
                        setState(() {
                          _userEdited = true;
                          _editedJogador!.img = file.path;
                        });
                      }
                    });
                  },
                ),
                TextField(
                  controller: _jogadorController,
                  focusNode: _jogadorFocus,
                  decoration: InputDecoration(labelText: "Jogador"),
                  onChanged: (text){
                    _userEdited = true;
                    setState(() {
                      _editedJogador!.jogador = text;
                    });
                  },
                ),
                TextField(
                  controller: _nomeController,
                  decoration: InputDecoration(labelText: "Nome"),
                  onChanged: (text){
                    _userEdited = true;
                    _editedJogador!.nome = text;
                  },
                ),
                TextField(
                  controller: _racaController,
                  decoration: InputDecoration(labelText: "Raça"),
                  onChanged: (text){
                    _userEdited = true;
                    _editedJogador!.raca = text;
                  },
                ),
              ],
            ),
          ),
        ),
    );
  }
 Future<bool> _requestPop(){
    if(_userEdited){
      showDialog(context: context,
          builder: (context){
            return AlertDialog(
              title: Text("Descarter Alterações?"),
              content: Text ("Se sair as alterações serão perdidas."),
              actions: <Widget>[
                TextButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text("sim"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
        }
      );
      return Future.value(true);
    } else {
      return Future.value(true);
    }
  }
}
