import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



Future<Map> pegarDados() async {
  final Uri url = Uri.https("api.hgbrasil.com","/finance",{"key":"--------"});
  // print("URI:$url");
  final resultado = await http.get(url);
  // print("Codigo de status:${response.statusCode}");
  // print(resultado.body);
  return json.decode(resultado.body);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late double dolar;
  late double euro;

  TextEditingController controlerReal = TextEditingController();
  TextEditingController controlerDolar = TextEditingController();
  TextEditingController controlerEuro = TextEditingController();

  void limparCampos(){
    controlerReal.text="";
    controlerDolar.text="";
    controlerEuro.text="";
  }

  void _realAlterado(String texto){
    if(texto.isEmpty){
      limparCampos();
    }
    double valorReal = double.parse(texto);
    controlerDolar.text = (valorReal * dolar).toStringAsFixed(2);
    controlerEuro.text = (valorReal * euro).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "\$ Coversor \$",
          style: TextStyle(
              color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.monetization_on,
              size: 150.0,
              color: Colors.orange,
            ),
            FutureBuilder(
                future: pegarDados(),
                builder: (context, snapshot){
                  switch(snapshot.connectionState){
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(
                        child:Text("Aguardando dados...",
                          style: TextStyle(fontSize: 20.0,
                              color: Colors.orange),)
                      );
                    default:
                      if(snapshot.hasError){
                        return Center(
                            child:Text("Erro na conexão...")
                        );
                      }
                      else{
                        dolar = snapshot.data?["results"]["currencies"]["USD"]["buy"];
                        euro = snapshot.data?["results"]["currencies"]["EUR"]["buy"];
                        return
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                TextField(
                                  controller: controlerReal,
                                  decoration: InputDecoration(
                                    label: Text("Real"),
                                  ),
                                style: TextStyle(
                                  color: Colors.orange, fontSize: 20.0),
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                onChanged: _realAlterado,
                                ),
                                TextField(
                                  controller: controlerDolar,
                                  decoration: InputDecoration(
                                    label: Text("Dolar"),
                                  ),
                                  style: TextStyle(
                                      color: Colors.orange, fontSize: 20.0),
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                ),
                                TextField(
                                  controller: controlerEuro,
                                  decoration: InputDecoration(
                                    label: Text("Euro"),
                                  ),
                                  style: TextStyle(
                                      color: Colors.orange, fontSize: 20.0),
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                )
                              ],
                            )
                          );
                        }

                      }
                  }

            )
          ],
        ),
      ),
    );
  }
}
