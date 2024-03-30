import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../define_class/Aircon/aircon.dart';

class AirconData {
  final String url =
      "http://${Gateway.host}:${Gateway.portHttp}/aircon/getall";
  Future<List<dynamic>> getAirconData() async {
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

updateAircon(Aircon data) async {
  int? idS = data.id;

  final res = await http.put(
      Uri.parse(
          "http://${Gateway.host}:${Gateway.portHttp}/aircon/update/$idS"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(
          Aircon(data.id, data.name, data.typeDevice, data.status).toJson()));
  log(json.encode(
      Aircon(data.id, data.name, data.typeDevice, data.status).toJson()));
  if (res.statusCode == 200) {
    return (json.encode(
            Aircon(data.id, data.name, data.typeDevice, data.status).toJson()))
        .toString();
  } else {
    throw Exception('Failed to update switch');
  }
}
