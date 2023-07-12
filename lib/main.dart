import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const request = 'https://api.hgbrasil.com/finance?key=3bd621fb';
final url = Uri.parse(request);

void main() async {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late double dollar;
  late double euro;

  final TextEditingController _real = TextEditingController();
  final TextEditingController _dolar = TextEditingController();
  final TextEditingController _euro = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Conversor de Moedas',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color(0xFFbdc2c9),
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: Text(
                  'Carregando Dados',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'Erro ao carregar dados..',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                dollar = snapshot.data!["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data!["results"]["currencies"]["EUR"]["buy"];

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Column(
                      children: [
                        const Text('Valores convertidos em tempo real',
                            style: TextStyle(
                              fontSize: 22,
                            )),
                        const SizedBox(height: 36,),
                        TextField(
                          controller: _real,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Real',
                            labelStyle: TextStyle(color: Colors.black),
                            prefixText: 'R\$ ',
                            prefixStyle: TextStyle(color: Colors.black),
                          ),
                          style: const TextStyle(color: Colors.black, fontSize: 20),
                        ),
                        const SizedBox(height: 24,),
                        TextField(
                          controller: _dolar,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Dolar',
                            labelStyle: TextStyle(color: Colors.black),
                            prefixText: 'U\$ ',
                            prefixStyle: TextStyle(color: Colors.black),
                          ),
                          style: const TextStyle(color: Colors.black, fontSize: 20),
                        ),
                        const SizedBox(height: 24,),
                        TextField(
                          controller: _euro,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Euro',
                            labelStyle: TextStyle(color: Colors.black),
                            prefixText: '€ ',
                            prefixStyle: TextStyle(color: Colors.black),
                          ),
                          style: const TextStyle(color: Colors.black, fontSize: 20),
                        )
                      ],
                    ),
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

Future<Map> getData() async {
  http.Response response = await http.get(url);
  return json.decode(response.body);
}
