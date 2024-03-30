import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../define_class/Lock/lock.dart';

class LockData {
  final String url = "http://${Gateway.host}:${Gateway.portHttp}/lock/getall";
  Future<List<dynamic>> getLockData() async {
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

updateLock(Lock data) async {
  int idS = data.id.toInt();

  final res = await http.put(
      Uri.parse(
          "http://${Gateway.host}:${Gateway.portHttp}/lock/update/$idS"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(
          Lock(data.status, data.id, data.name, data.typeDevice).toJson()));
  log(json
      .encode(Lock(data.status, data.id, data.name, data.typeDevice).toJson()));
  if (res.statusCode == 200) {
    return (json.encode(
            Lock(data.status, data.id, data.name, data.typeDevice).toJson()))
        .toString();
  } else {
    throw Exception('Failed to update Lock');
  }
}
