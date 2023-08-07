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

  _realChanged(String text) {
    double real = double.parse(text);
    _dolar.text = (real / dollar).toStringAsFixed(2);
    _euro.text = (real / euro).toStringAsFixed(2);
    _pound.text = (real / pound).toStringAsFixed(2);
    _pesoArgentino.text = (real / pesoArgentino).toStringAsFixed(2);
  }

  _dollarChanged(String text) {
    double dolarCoin = double.parse(text);
    _real.text = (dollar * dolarCoin).toStringAsFixed(2);
    _euro.text = (dolarCoin / euro).toStringAsFixed(2);
    _pound.text = (dolarCoin / pound).toStringAsFixed(2);
    _pesoArgentino.text = (dolarCoin / pesoArgentino).toStringAsFixed(2);
  }

  _euroChaged(String text) {
    double euroCoin = double.parse(text);
    _real.text = (euro * euroCoin).toStringAsFixed(2);
    _dolar.text = (euroCoin / dollar).toStringAsFixed(2);
    _pound.text = (euroCoin / pound).toStringAsFixed(2);
    _pesoArgentino.text = (euroCoin / pesoArgentino).toStringAsFixed(2);
  }

  _poundChanged(String text) {
    double poundCoin = double.parse(text);
    _real.text = (pound * poundCoin).toStringAsFixed(2);
    _dolar.text = (poundCoin / dollar).toStringAsFixed(2);
    _euro.text = (poundCoin / euro).toStringAsFixed(2);
    _pesoArgentino.text = (poundCoin / pesoArgentino).toStringAsFixed(2);
  }

  _pesoChanged(String text) {
    double pesoCoin = double.parse(text);
    _real.text = (pesoArgentino * pesoCoin).toStringAsFixed(2);
    _dolar.text = (pesoCoin / dollar).toStringAsFixed(2);
    _euro.text = (pesoCoin / euro).toStringAsFixed(2);
    _pound.text = (pesoCoin / pound).toStringAsFixed(2);
  }

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
      body: SingleChildScrollView(
        child: FutureBuilder<Map>(
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
      ),
    );
  }
}

Future<Map> getData() async {
  http.Response response = await http.get(url);
  return json.decode(response.body);
}

Widget buildTextField(String label, String prefix,
    TextEditingController controller, Function(String text) function) {
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
    onChanged: function,
  );
}
