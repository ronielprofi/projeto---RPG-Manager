import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';

import '../helpers/jogador_helper.dart';

import 'package:image_picker/image_picker.dart';

enum Options {codigo,nada}

class JogadorPage extends StatefulWidget {

  final Jogador? jogador;

  JogadorPage({ this.jogador});

  @override
  State<JogadorPage> createState() => _JogadorPageState();
}

class _JogadorPageState extends State<JogadorPage> {
  int AzulPetrolioLight = 0xFF110274;
  int AzulPetrolio = 0xff040b28;

  final _jogadorController = TextEditingController();
  final _nomeController = TextEditingController();
  final _racaController = TextEditingController();

  final FocusNode _jogadorFocus = FocusNode();

  bool _userEdited = false;

  Jogador? _editedJogador;

  TextEditingController _codigoController = TextEditingController();
  String _codigo = "";
  bool _admModo = false;

  @override
  void initState() {
    super.initState();

    if(widget.jogador == null){
      _editedJogador = Jogador();
      _admModo = true;
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
            backgroundColor: Colors.blue,
            title: _admModo ? Text("${_editedJogador?.nome ?? "Novo Jogador"}") : Text(_editedJogador?.nome ?? "Novo Jogador"),
            centerTitle: true,
            actions: <Widget>[
              PopupMenuButton<Options>(
                icon: Icon(
                  Icons.more_vert, // Ícone padrão de três pontos
                  color: Colors.blue, // Cor desejada
                ),
                itemBuilder: (context) => <PopupMenuEntry<Options>>[
                  const PopupMenuItem(
                    child: Text("Códigos"),
                    value: Options.codigo,
                  ),
                  const PopupMenuItem(
                    child: Text("nada"),
                    value: Options.nada,
                  ),
                ],
                onSelected: _OptionsList,
              )
            ],
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
            backgroundColor: Colors.blue,
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
                  enabled: _admModo,
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
                  enabled: _admModo,
                  controller: _nomeController,
                  decoration: InputDecoration(labelText: "Nome"),
                  onChanged: (text){
                    _userEdited = true;
                    _editedJogador!.nome = text;
                  },
                ),
                TextField(
                  enabled: _admModo,
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
  void _OptionsList(Options result){
    switch(result){
      case Options.nada:
        showReview(context,
          "Essa função ainda esta em desenvovimento",
          "images/megaman-x.jpg",
          "Ok",
              () {
            Navigator.of(context).pop();
          },
        );
        break;
      case Options.codigo:
        showDialog(context: context,
            builder: (context){
              return AlertDialog(
                title: Text("Digite o código",
                  style: TextStyle(color: Colors.blue),),
                content: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: TextFormField(
                    controller: _codigoController,
                    onChanged: (text){
                      _codigo = text;
                    },
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: EdgeInsets.all(8),
                      hintStyle: TextStyle(color: Colors.blue),
                      labelStyle: TextStyle(color: Colors.blue),
                      hintText: "Código",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 2.0,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
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
                      if(_codigo == "adm1306"){
                        setState(() {
                          _admModo = _admModo ? false : true;
                          print(" aqui ------------------------------------ $_admModo");
                        });
                        Navigator.of(context).pop();
                      } else{
                        showReview(context,
                          "Esse código não é válido",
                          "images/megaman-x.jpg",
                          "Ok",
                              () {
                            Navigator.of(context).pop();
                          },
                        );
                      }
                      _codigoController.text = "";
                    },
                  ),
                ],
              );
            }
        );
        break;
    }
    setState(() {

    });
  }
  showReview(context, String mensagem, String pit, String textbtn, rota, {bool clickFora = true}) {
    showDialog(
        context: context,
        barrierDismissible: clickFora,
        builder: (BuildContext context) {
          return Dialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            child: Container(
              height: 350,
              decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0)),
                      color: Colors.blue,
                    ),
                  ),

                  SizedBox(height: 20.0),
                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        mensagem, //mensagem referente a resposta
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 20.0,
                          fontWeight: FontWeight.w300,
                        ),
                      )),

                  Image.asset(
                    pit,
                    height: 100,
                  ), //carinha do pit

                  TextButton(
                      child: Center(
                        child: Text(
                          textbtn, //nome do botão
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 20.0,
                              color: Colors.blue),
                        ),
                      ),
                      onPressed: rota, //caminho apos o botão ser clicado
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent))
                ],
              ),
            ),
          );
        });
  }
}
