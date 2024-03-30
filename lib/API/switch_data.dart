import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../define_class/Switch/switchC.dart';

class SwitchData {
  final String url =
      "http://${Gateway.host}:${Gateway.portHttp}/switch/getall";
  Future<List<dynamic>> getSwitchData() async {
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

updateSwitch(SwitchC data) async {
  int idS = data.id.toInt();

  final res = await http.put(
      Uri.parse(
          "http://${Gateway.host}:${Gateway.portHttp}/switch/update/$idS"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(
          SwitchC(data.id, data.name, data.status, data.typeDevice).toJson()));
  log(json.encode(
      SwitchC(data.id, data.name, data.status, data.typeDevice).toJson()));
  if (res.statusCode == 200) {
    return (json.encode(
            SwitchC(data.id, data.name, data.status, data.typeDevice).toJson()))
        .toString();
  } else {
    throw Exception('Failed to update switch');
  }
}
