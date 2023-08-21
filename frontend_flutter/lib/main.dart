import 'dart:html';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';

Future<Colaborador> post(String nome, String senha, _MyHomePageState _myHomePageState) async {
  final response = await http.post(
    Uri.parse('http://localhost:8084'),
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

class Colaborador {
  final String nome;
  final String senha;

  const Colaborador({required this.nome, required this.senha});

  factory Colaborador.fromJson(Map<String, dynamic> json) {
    return Colaborador(
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

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String? _nome;
  String? _senha;
  List<Colaborador>? colaboradorList;

  final nomeController = TextEditingController();
  final senhaController = TextEditingController();

  @override
  void dispose() {
    nomeController.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _salvar() {
    _nome = nomeController.text;
    _senha = senhaController.text;

    post(_nome!, _senha!, this);
    _counter = 0;
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
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), 
    );
  }
  
  void limparCampos() {
    nomeController.text = '';
    senhaController.text = '';
    carregaLista();
  }

  void carregaLista(){
    get().then(
      (value) => lista(value)
    );
  }

  void lista(List<Colaborador> lista){
    colaboradorList = lista;
  }
}


