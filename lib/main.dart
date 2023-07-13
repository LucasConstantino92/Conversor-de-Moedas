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
  late double pound;
  late double pesoArgentino;

  final TextEditingController _real = TextEditingController();
  final TextEditingController _dolar = TextEditingController();
  final TextEditingController _euro = TextEditingController();
  final TextEditingController _pound = TextEditingController();
  final TextEditingController _pesoArgentino = TextEditingController();

  void _realChanged() {}

  void _dollarChanged() {}

  void _euroChaged() {}

  void _poundChanged() {}

  void _pesoChanged() {}

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
                pound = snapshot.data!["results"]["currencies"]["GBP"]["buy"];
                pesoArgentino =
                    snapshot.data!["results"]["currencies"]["ARS"]["buy"];

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Column(
                      children: [
                        const Text('Valores convertidos em tempo real',
                            style: TextStyle(
                              fontSize: 22,
                            )),
                        const SizedBox(height: 36),
                        buildTextField('Real', 'R\$ ', _real, _realChanged),
                        const SizedBox(height: 24),
                        buildTextField(
                            'Dólar', 'US\$ ', _dolar, _dollarChanged),
                        const SizedBox(height: 24),
                        buildTextField('Euro', '€ ', _euro, _euroChaged),
                        const SizedBox(height: 24),
                        buildTextField(
                            'Libra Esterlina', '£ ', _pound, _poundChanged),
                        const SizedBox(height: 24),
                        buildTextField('Peso Argentino', 'AR\$ ',
                            _pesoArgentino, _pesoChanged)
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

Widget buildTextField(String label, String prefix,
    TextEditingController controller, Function function) {
  return TextField(
    controller: controller,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        prefixText: prefix,
        prefixStyle: const TextStyle(color: Colors.black),
        border: OutlineInputBorder()),
    style: const TextStyle(color: Colors.black, fontSize: 20),
    onChanged: function(),
  );
}
