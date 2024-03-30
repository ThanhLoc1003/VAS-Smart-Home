import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../define_class/Rolldoor/RolldoorC.dart';

class RolldoorData {
  final String url =
      "http://${Gateway.host}:${Gateway.portHttp}/rolldoor/getall";
  Future<List<dynamic>> getRolldoorData() async {
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

updateRolldoor(RolldoorC data) async {
  int idS = data.id.toInt();

  final res = await http.put(
      Uri.parse(
          "http://${Gateway.host}:${Gateway.portHttp}/rolldoor/update/$idS"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(
          RolldoorC(data.status, data.id, data.name, data.typeDevice)
              .toJson()));
  log(json.encode(
      RolldoorC(data.status, data.id, data.name, data.typeDevice).toJson()));
  if (res.statusCode == 200) {
    return (json.encode(
            RolldoorC(data.status, data.id, data.name, data.typeDevice)
                .toJson()))
        .toString();
  } else {
    throw Exception('Failed to update Rolldoor');
  }
}
