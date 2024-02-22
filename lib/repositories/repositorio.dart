import 'package:http/http.dart' as http;
import 'dart:convert';

class Repositorio{

Future<Map> pegarDados() async {
  final Uri url = Uri.https("api.hgbrasil.com","/finance",{"key":"--------"});
  // print("URI:$url");
  final resultado = await http.get(url);
  // print("Codigo de status:${response.statusCode}");
  // print(resultado.body);
  return json.decode(resultado.body);
}

}