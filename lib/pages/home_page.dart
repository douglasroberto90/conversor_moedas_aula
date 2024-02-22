import 'package:flutter/material.dart';
import 'package:conversor_moedas_aula/repositories/repositorio.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Repositorio repositorio = Repositorio();

  late double cotacaoDolar;
  late double cotacaoEuro;

  TextEditingController controlerReal = TextEditingController();
  TextEditingController controlerDolar = TextEditingController();
  TextEditingController controlerEuro = TextEditingController();

  void limparCampos() {
    controlerReal.text = "";
    controlerDolar.text = "";
    controlerEuro.text = "";
  }

  void _realAlterado(String texto) {
    if (texto.isEmpty) {
      limparCampos();
    }
    double valorReal = double.parse(texto);
    controlerDolar.text = (valorReal * cotacaoDolar).toStringAsFixed(2);
    controlerEuro.text = (valorReal * cotacaoEuro).toStringAsFixed(2);
  }

  void _dolarAlterado(String texto) {
    if (texto.isEmpty) {
      limparCampos();
    }
    double valorDolar = double.parse(texto);
    controlerReal.text = (valorDolar / cotacaoDolar).toStringAsFixed(2);
    controlerEuro.text =
        ((valorDolar / cotacaoDolar) * cotacaoEuro).toStringAsFixed(2);
  }

  void _euroAlterado(String texto) {
    if (texto.isEmpty) {
      limparCampos();
    }
    double valorEuro = double.parse(texto);
    controlerReal.text = (valorEuro / cotacaoEuro).toStringAsFixed(2);
    controlerDolar.text =
        ((valorEuro / cotacaoEuro) * cotacaoDolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "\$ Coversor \$",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.monetization_on,
                size: 150.0,
                color: Colors.orange,
              ),
              FutureBuilder(
                  future: repositorio.pegarDados(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return const Center(
                            child: Text(
                          "Aguardando dados...",
                          style: TextStyle(fontSize: 20.0, color: Colors.orange),
                        ));
                      default:
                        if (snapshot.hasError) {
                          return Center(child: Text("Erro na conexão..."));
                        } else {
                          cotacaoDolar = snapshot.data?["results"]["currencies"]
                              ["USD"]["buy"];
                          cotacaoEuro = snapshot.data?["results"]["currencies"]
                              ["EUR"]["buy"];
                          return SingleChildScrollView(
                              child: Column(
                            children: [
                              TextField(
                                controller: controlerReal,
                                decoration: const InputDecoration(
                                  label: Text("Real"),
                                  prefix: Text("R\$ ",
                                      style: TextStyle(color: Colors.orange)),
                                ),
                                style: const TextStyle(
                                    color: Colors.orange, fontSize: 20.0),
                                keyboardType: const TextInputType.numberWithOptions(
                                    decimal: true),
                                onChanged: _realAlterado,
                              ),
                              TextField(
                                controller: controlerDolar,
                                decoration: const InputDecoration(
                                    label: Text("Dolar"),
                                    prefix: Text("US\$ ",
                                        style: TextStyle(color: Colors.orange))),
                                style: const TextStyle(
                                    color: Colors.orange, fontSize: 20.0),
                                keyboardType: const TextInputType.numberWithOptions(
                                    decimal: true),
                                onChanged: _dolarAlterado,
                              ),
                              TextField(
                                controller: controlerEuro,
                                decoration: const InputDecoration(
                                    label: Text("Euro"),
                                    prefix: Text(
                                      "€ ",
                                      style: TextStyle(color: Colors.orange),
                                    )),
                                style: const TextStyle(
                                    color: Colors.orange, fontSize: 20.0),
                                keyboardType: const TextInputType.numberWithOptions(
                                    decimal: true),
                                onChanged: _euroAlterado,
                              )
                            ],
                          ));
                        }
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
