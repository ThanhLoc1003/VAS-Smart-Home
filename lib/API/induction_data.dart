import 'dart:convert';

import 'package:http/http.dart' as http;
import '../constants.dart';

import '../define_class/Induction/induction.dart';

class InductionData {
  final String url =
      "http://${Gateway.host}:${Gateway.portHttp}/induction/getall";
  Future<List<dynamic>> getInductionData() async {
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

updateInduction(Induction data) async {
  int idS = data.id.toInt();

  final res = await http.put(
      Uri.parse(
          "http://${Gateway.host}:${Gateway.portHttp}/induction/update/$idS"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(
          Induction(data.id, data.name, data.typeDevice, data.status)
              .toJson()));

  if (res.statusCode == 200) {
    return json
        .encode(Induction(data.id, data.name, data.typeDevice, data.status)
            .toJson())
        .toString();
  } else {
    throw Exception('Failed to update switch');
  }
}
