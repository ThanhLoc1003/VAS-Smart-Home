import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

class AttendanceRecord {
  String name;
  String status;
  String timestamp;

  AttendanceRecord(
      {required this.name, required this.status, required this.timestamp});
}

class DataPage extends StatefulWidget {
  const DataPage({super.key});

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  List<AttendanceRecord> attendanceRecords = [];

  @override
  void initState() {
    super.initState();
    loadAttendanceData();
  }

  String normalizeName(String name) {
    // Chuyển về chữ thường
    String lowercasedName = name.toLowerCase();

    // Loại bỏ dấu cách
    String noSpaceName = lowercasedName.replaceAll(' ', '');

    // Loại bỏ tiếng Việt
    String withoutVietnamese = removeVietnamese(noSpaceName);

    return withoutVietnamese;
  }

  String removeVietnamese(String str) {
    // Chuyển các ký tự có dấu về không dấu
    String withoutDiacritics = str
        .replaceAll(RegExp('[áàảãạâấầẩẫậăắằẳẵặ]'), 'a')
        .replaceAll(RegExp('[éèẻẽẹêếềểễệ]'), 'e')
        .replaceAll(RegExp('[íìỉĩị]'), 'i')
        .replaceAll(RegExp('[óòỏõọôốồổỗộơớờởỡợ]'), 'o')
        .replaceAll(RegExp('[úùủũụưứừửữự]'), 'u')
        .replaceAll(RegExp('[ýỳỷỹỵ]'), 'y')
        .replaceAll(RegExp('[đ]'), 'd');

    return withoutDiacritics;
  }

  Future<void> loadAttendanceData() async {
    try {
      attendanceRecords = [];
      final response = await http.get(Uri.parse(
          //   'http://192.168.1.104:7788/get_csv',
          // ));
          'http://${ServerAI.host}:${ServerAI.port}/get_csv'));
      //// Replace with your server address
      String csvData = utf8.decode(response.bodyBytes);

      List<List<dynamic>> csvTable =
          const CsvToListConverter().convert(csvData);

      SharedPreferences prefs = await SharedPreferences.getInstance();

      var name = prefs.getString('name')!;
      var role = prefs.getString('role')!;
      // print(name);

      for (var row in csvTable) {
        if (row[0] == "Name") continue;
        if (role == 'All') {
          AttendanceRecord record = AttendanceRecord(
            name: row[0],
            status: row[1],
            timestamp: row[2],
          );

          attendanceRecords.add(record);
        } else {
          if (normalizeName(name) != normalizeName(row[0])) continue;
          AttendanceRecord record = AttendanceRecord(
            name: row[0],
            status: row[1],
            timestamp: row[2],
          );

          attendanceRecords.add(record);
        }
      }

      setState(() {}); // Trigger a rebuild to update the UI
    } catch (e) {
      // print('Error loading attendance data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                loadAttendanceData();
              });
            },
          ),
        ],
      ),
      body: attendanceRecords.isEmpty
          ? const Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('No person found'),
              ],
            ))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: attendanceRecords.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(color: Colors.white)),
                      title: Text(
                        attendanceRecords[index].name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      subtitle: Text(
                          'Status: ${attendanceRecords[index].status}\nTimestamp: ${attendanceRecords[index].timestamp}',
                          style: const TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(height: 10.0),
                  ],
                );
              },
            ),
    );
  }
}
