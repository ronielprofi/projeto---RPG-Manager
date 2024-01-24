
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

final String jogadorTable = "jogadorTable";
final String idColumn = "idColumn";
final String imgColumn = "imgColumn";

final String jogadorColumn = "jogadorColumn";
final String nomeColumn = "nomeColumn";
final String racaColumn = "racaColumn";
final String elementoColumn = "elementoColumn";
final String nivelColumn = "nivelColumn";
final String xpColumn = "xpColumn";
final String classeColumn = "classeColumn";
final String classeLvColumn = "classeLvColumn";
final String tituloColumn = "tituloColumn";
final String idadeColumn = "idadeColumn";
final String moedaColumn = "moedaColumn";

final String forcaColumn = "forcaColumn";
final String agilidadeColumn = "agilidadeColumn";
final String destrezaColumn = "destrezaColumn";
final String esquivaColumn = "esquivaColumn";
final String constituicaoColumn = "constituicaoColumn";
final String sabedoriaColumn = "sabedoriaColumn";

final String armaduraCorporalColumn = "armaduraCorporalColumn";
final String resistenciaColumn = "resistenciaColumn";
final String sorteColumn = "sorteColumn";
final String inteligenciaColumn = "inteligenciaColumn";
final String percepcaoColumn = "percepcaoColumn";
final String carismaColumn = "carismaColumn";

final String ataqueColumn = "ataqueColumn";
final String defesaColumn = "defesaColumn";
final String criticoColumn = "criticoColumn";
final String vidaColumn = "vidaColumn";
final String manaColumn = "manaColumn";
final String magiaColumn = "magiaColumn";

class JogadorHelper {

  static final JogadorHelper _instance = JogadorHelper.internal();

  factory JogadorHelper() => _instance;

  JogadorHelper.internal() ;

  Database? _db ;

  Future<Database> get db async {
    if (_db != null){
      return _db!;
    } else {
      _db = await initDb();
      return _db!;
    }
  }
  Future<Database> initDb () async{
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "jogadorsnew.db");

    return await openDatabase(path, version: 1,onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $jogadorTable($idColumn INTEGER PRIMARY KEY, $imgColumn TEXT, $jogadorColumn TEXT, $nomeColumn TEXT,"
              "$racaColumn TEXT, $elementoColumn TEXT, $nivelColumn TEXT, $xpColumn TEXT, $classeColumn TEXT, $classeLvColumn TEXT, $tituloColumn TEXT, $moedaColumn TEXT, $idadeColumn TEXT,"
              "$forcaColumn TEXT, $agilidadeColumn TEXT, $destrezaColumn TEXT, $esquivaColumn TEXT, $constituicaoColumn TEXT, $sabedoriaColumn TEXT,"
              "$armaduraCorporalColumn TEXT, $resistenciaColumn TEXT, $sorteColumn TEXT, $inteligenciaColumn TEXT, $percepcaoColumn TEXT, $carismaColumn TEXT,"
              "$ataqueColumn TEXT, $defesaColumn TEXT, $criticoColumn TEXT, $vidaColumn TEXT, $manaColumn TEXT, $magiaColumn TEXT)"
      );
    });
  }
  Future<Jogador> saveJogador(Jogador jogador) async {
    Database? dbJogador = await db;
    jogador.id = await dbJogador.insert(jogadorTable, jogador.toMap());
    return jogador;
  }

  Future<Jogador?> getJogador(int id) async{
    Database? dbJogador = await db;
    List<Map> maps = await dbJogador.query(jogadorTable,
    columns: [idColumn, imgColumn, jogadorColumn, nomeColumn, racaColumn, elementoColumn, nivelColumn , xpColumn, classeColumn, classeLvColumn, tituloColumn, idadeColumn, moedaColumn,
      forcaColumn, agilidadeColumn, destrezaColumn, esquivaColumn, constituicaoColumn, sabedoriaColumn, armaduraCorporalColumn,
      resistenciaColumn, sorteColumn, inteligenciaColumn, percepcaoColumn, carismaColumn, ataqueColumn, defesaColumn, criticoColumn,
      vidaColumn, manaColumn, magiaColumn],
    where: "$idColumn = ?",
    whereArgs: [id]);
    if(maps.length > 0){
      return Jogador.fromMap(maps.first);
    } else{
      return null;
    }
  }

  Future<int> deleteJogador(int id) async{
    Database dbJogador = await db;
    return await dbJogador.delete(jogadorTable, where: "$idColumn = ?", whereArgs: [id]);
  }

 Future<int> updateJogador(Jogador jogador) async {
   Database dbJogador = await db;
   return await dbJogador.update(jogadorTable,
       jogador.toMap(),
       where: "$idColumn = ?",
       whereArgs: [jogador.id]);
  }

  Future<List> getAllJogador()  async {
    Database dbJogador = await db;
    List listMap = await dbJogador.rawQuery("SELECT * FROM $jogadorTable");
    List<Jogador> listJogador = [];
    for(Map m in listMap){
      listJogador.add(Jogador.fromMap(m));
    }
    return listJogador;
  }

  Future<int?>getNumber() async {
    Database dbJogador = await db;
    return Sqflite.firstIntValue(await dbJogador.rawQuery("SELECT COUNT(*) FROM $jogadorTable"));
  }

  Future Close () async {
    Database dbJogador = await db;
    dbJogador.close();
  }

}

class Jogador{

  int? id;
  String? img;

  String? jogador;
  String? nome;
  String? raca;
  String? elemento;
  int? nivel;
  int? xp;
  String? classe;
  int? classeLv;
  String? titulo;
  int? idade;
  int? moeda;

  int? forca;
  int? agilidade;
  int? destreza;
  int? esquiva;
  int? constituicao;
  int? sabedoria;

  int? armaduraCorporal;
  int? resistencia;
  int? sorte;
  int? inteligencia;
  int? percepcao;
  int? carisma;

  int? ataque;
  int? defesa;
  int? critico;
  int? vida;
  int? mana;
  int? magia;

  Jogador();

  Jogador.fromMap(Map map){
    id = map [idColumn];
    img = map [imgColumn];

    jogador = map [jogadorColumn];
    nome = map [nomeColumn];
    raca = map [racaColumn];
    elemento = map [elementoColumn];
    nivel = map [nivelColumn];
    xp = map [xpColumn];
    classe = map [classeColumn];
    classeLv = map [classeLvColumn];
    titulo = map [tituloColumn];
    idade = map [idadeColumn];
    moeda = map [moedaColumn];

    forca = map [forcaColumn];
    agilidade = map [agilidadeColumn];
    destreza = map [destrezaColumn];
    esquiva = map [esquivaColumn];
    constituicao = map [constituicaoColumn];
    sabedoria = map [sabedoriaColumn];

    armaduraCorporal = map [armaduraCorporalColumn];
    resistencia = map [resistenciaColumn];
    sorte = map [sorteColumn];
    inteligencia = map [inteligenciaColumn];
    percepcao = map [percepcaoColumn];
    carisma = map [carismaColumn];

    ataque = map [ataqueColumn];
    defesa = map [defesaColumn];
    critico = map [criticoColumn];
    vida = map [vidaColumn];
    mana = map [manaColumn];
    magia = map [magiaColumn];

  }

  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = {
      imgColumn: img,
      jogadorColumn: jogador,
      nomeColumn: nome,
      racaColumn: raca,
      elementoColumn: elemento,
      nivelColumn: nivel,
      xpColumn: xp,
      classeColumn: classe,
      classeLvColumn: classeLv,
      tituloColumn: titulo,
      idadeColumn: idade,
      moedaColumn: moeda,
      forcaColumn: forca,
      agilidadeColumn: agilidade,
      destrezaColumn: destreza,
      esquivaColumn: esquiva,
      constituicaoColumn: constituicao,
      sabedoriaColumn: sabedoria,
      armaduraCorporalColumn: armaduraCorporal,
      resistenciaColumn: resistencia ,
      sorteColumn: sorte,
      inteligenciaColumn: inteligencia ,
      percepcaoColumn: percepcao,
      carismaColumn: carisma,
      ataqueColumn: ataque,
      defesaColumn: defesa,
      criticoColumn: critico,
      vidaColumn: vida,
      manaColumn: mana,
      magiaColumn: magia,

    };
    if( id != null){
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Jogador(id: $id, img: $img, jogador:$jogador, nome: $nome)";
  }
}