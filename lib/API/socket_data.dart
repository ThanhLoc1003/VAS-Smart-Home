import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../define_class/Socket/socketC.dart';

class SocketData {
  final String url =
      "http://${Gateway.host}:${Gateway.portHttp}/socket/getall";
  Future<List<dynamic>> getSocketData() async {
    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        throw Exception("Can not get weather");
      }
    } catch (e) {
      rethrow;
    }
  }
}

updateSocket(SocketC data) async {
  int idS = data.id.toInt();

  final res = await http.put(
      Uri.parse(
          "http://${Gateway.host}:${Gateway.portHttp}/socket/update/$idS"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(
          SocketC(data.id, data.name, data.status, data.typeDevice).toJson()));
  log(json.encode(
      SocketC(data.id, data.name, data.status, data.typeDevice).toJson()));
  if (res.statusCode == 200) {
    return (json.encode(
            SocketC(data.id, data.name, data.status, data.typeDevice).toJson()))
        .toString();
  } else {
    throw Exception('Failed to update socket');
  }
}
