import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';

Future<Colaborador> post(String nome, String senha, _MyHomePageState _myHomePageState) async {
  final response = await http.post(
    Uri.parse('http://3.143.118.52:8084'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'nome': nome,
      'senha': senha,
    }),
  );

  if (response.statusCode == 200) {
    _myHomePageState.limparCampos();

    return Colaborador.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create colaborador.');
  }
}

Future<List<Colaborador>> get() async {

  final response = await http
      .get(Uri.parse('http://localhost:8082'));

  if (response.statusCode == 200) {
    return List<Colaborador>.from( json.decode(response.body) .map( (x) => Colaborador.fromJson(x)));

  } else {
    throw Exception('Failed to load colaborador');
  }
}

Future<Colaborador> postAssociaChefe(int idChefe, int idSubordinado, _MyHomePageState _myHomePageState) async {
  final response = await http.post(
    Uri.parse('http://localhost:8081'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, int>{
      'idChefe': idChefe,
      'idSubordinado': idSubordinado,
    }),
  );

  if (response.statusCode == 200) {
    _myHomePageState.limparCampos();

    return Colaborador.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create colaborador.');
  }
}

class Colaborador {
  final int id;
  final String nome;
  final String senha;

  const Colaborador({required this.id, required this.nome, required this.senha});

  factory Colaborador.fromJson(Map<String, dynamic> json) {
    return Colaborador(
      id : json['id'],
      nome: json['nome'],
      senha: json['senha'],
    );
  }
}
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Frontend flutter',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Cadastro de colaboradores'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
List<Colaborador>? colaboradorList;


class _MyHomePageState extends State<MyHomePage> {

  String? _nome;
  String? _senha;
  Colaborador? chefe;
  Colaborador? subordinado;


  final nomeController = TextEditingController();
  final senhaController = TextEditingController();

  @override
  void dispose() {
    nomeController.dispose();
    super.dispose();
  }

  void _salvar() {
    _nome = nomeController.text;
    _senha = senhaController.text;

    post(_nome!, _senha!, this);
  }
  
  void _associaChefe() {
    postAssociaChefe(chefe!.id, subordinado!.id, this);
  }

  @override
  Widget build(BuildContext context) {
    carregaLista();

    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        
        title: Text(widget.title),
      ),
      body: Align(
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(
               decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Nome',
              ),
              controller: nomeController,
            ),
            TextField(
               obscureText: true,
               decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Senha',  
              ),
              controller: senhaController,
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: _salvar,
              child: Text('Salvar'),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: colaboradorList?.length,
                  itemBuilder: (context, index) {
                    final item = colaboradorList?[index];
                    if(item!=null){
                      return ListTile(
                        title: Text(item!.nome)
                      );
                    }
                  },
              )
            ),
            MenuAnchor(
              builder:
                  (BuildContext context, MenuController controller, Widget? child) {
                return IconButton(
                  onPressed: () {
                    if (controller.isOpen) {
                      controller.close();
                    } else {
                      controller.open();
                    }
                  },
                  icon: const Icon(Icons.more_horiz),
                  tooltip: 'Show menu',
                );
              },
              menuChildren: List<MenuItemButton>.generate(
                colaboradorList!.length,
                (int index) => MenuItemButton(
                  onPressed: () =>
                      selecioneiChefe(index),
                  child: Text(colaboradorList![index].nome),
                ),
              ),
            ),
            MenuAnchor(
              builder:
                  (BuildContext context, MenuController controller, Widget? child) {
                return IconButton(
                  onPressed: () {
                    if (controller.isOpen) {
                      controller.close();
                    } else {
                      controller.open();
                    }
                  },
                  icon: const Icon(Icons.more_horiz),
                  tooltip: 'Show menu',
                );
              },
              menuChildren: List<MenuItemButton>.generate(
                colaboradorList!.length,
                (int index) => MenuItemButton(
                  onPressed: () =>
                      selecioneiSubordinado(index),
                  child: Text(colaboradorList![index].nome),
                ),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: _associaChefe,
              child: Text('Associar Chefe'),
            )
          ],
        ),
      ), 
    );
  }

  void selecioneiChefe(int index){
    setState(() => chefe = colaboradorList?[index]);
  } 

  void selecioneiSubordinado(int index){
    setState(() => subordinado = colaboradorList?[index]);
  } 

  void limparCampos() {
    nomeController.text = '';
    senhaController.text = '';
    chefe = null;
    subordinado = null;
    carregaLista();
  }

  void carregaLista(){
    get().then(
      (value) => lista(value)
    );
  }

  void lista(List<Colaborador> lista){
   setState(() => colaboradorList = lista);
  }
  
}