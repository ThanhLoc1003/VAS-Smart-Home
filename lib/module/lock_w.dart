import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../color_schemes.dart';
import '../common_widget/custom_card.dart';
import '../constants.dart';
import '../define_class/Lock/lock.dart';
import '../widgets/platform_search_bar.dart';
import 'package:http/http.dart' as http;

import 'package:url_launcher/url_launcher.dart';

// ignore: camel_case_types, must_be_immutable
class buildLock extends StatelessWidget {
  buildLock(
      {super.key, required this.size, required this.dev, required this.index});
  Size size;
  Lock dev;
  int index;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.17,
      width: size.width * 0.7,
      decoration: BoxDecoration(
        color: kBgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(3, 3),
          ),
          BoxShadow(
            color: Colors.white,
            blurRadius: 0,
            offset: Offset(-3, -3),
          ),
        ],
      ),
      margin: const EdgeInsets.fromLTRB(15, 15, 15, 15),
      child: Padding(
        padding: const EdgeInsets.all(.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.015),
            Row(
              children: [
                SizedBox(width: size.width * 0.01),
                Text(
                  dev.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.01),
            Row(
              children: <Widget>[
                const SizedBox(
                  width: 10,
                ),
                CustomCard(
                  icon: Icons.power_settings_new,
                  title: 'Button',
                  state: dev.status.button,
                  value: 0,
                  type: dev.typeDevice,
                  index: index,
                ),
                const SizedBox(width: 10),
                CustomCard(
                  icon: Icons.lock_sharp,
                  title: 'State',
                  state: dev.status.state,
                  value: 0,
                  type: dev.typeDevice,
                  index: index,
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    Get.to(const LogLock());
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: size.height * 0.08,
                      width: size.width * 0.22,
                      color: Colors.lightBlueAccent,
                      // padding: EdgeInsets.all(10),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.manage_search_sharp),
                          Text(
                            'Logs',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LockRecord {
  String state;
  String timestamp;
  LockRecord(this.state, this.timestamp);
}

enum FilterType { all, open, close }

List<LockRecord> filterLogs(List<LockRecord> logs, FilterType filterType) {
  switch (filterType) {
    case FilterType.all:
      return logs;
    case FilterType.open:
      return logs.where((log) => log.state == 'Open').toList();
    case FilterType.close:
      return logs.where((log) => log.state == 'Close').toList();
  }
}

class LogLock extends StatefulWidget {
  const LogLock({super.key});

  @override
  State<LogLock> createState() => _LogLockState();
}

class _LogLockState extends State<LogLock> {
  String formatDateTime(DateTime dateTime) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitYear(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String year = twoDigitYear(dateTime.year % 100);
    String month = twoDigits(dateTime.month);
    String day = twoDigits(dateTime.day);
    String hour = twoDigits(dateTime.hour + 7);
    String minute = twoDigits(dateTime.minute);
    String second = twoDigits(dateTime.second);

    return '$year-$month-$day $hour:$minute:$second';
  }

  final TextEditingController _textEditingController = TextEditingController();

  List<LockRecord> logs = [];
  List<List<LockRecord>> _levelsCounts = [];
  bool isLoaded = false;
  Future<void> loadLockData() async {
    try {
      logs = [];
      final response = await http.get(Uri.parse(
          //   'http://192.168.1.104:7788/get_csv',
          // ));
          'http://${Gateway.host}:${Gateway.portHttp}/history_lock'));
      //// Replace with your server address
      ///

      if (response.statusCode == 200) {
        // print(response.body);
        logs = response.body
            .split('\n')
            .where((line) => line.isNotEmpty)
            .map((line) {
          List<String> parts = line.split(',');
          return LockRecord(parts[0], parts[1]);
        }).toList();

        // Lọc dữ liệu với kiểu được chọn
        List<LockRecord> filteredLogs = filterLogs(logs, FilterType.all);

        List<LockRecord> openLogs = filterLogs(logs, FilterType.open);
        List<LockRecord> closeLogs = filterLogs(logs, FilterType.close);

        // In ra kết quả
        // filteredLogs.forEach((log) {
        //   print('${log.state}\t${log.timestamp.toString()}');
        // });
        setState(() {
          _levelsCounts = [filteredLogs, openLogs, closeLogs];
          isLoaded = true;
          // print(_levelsCounts[0].length);
        });
      } else {
        throw Exception('Failed to load CSV file');
      }

      // String csvData = utf8.decode(response.bodyBytes);
      // // print(csvData);
      // List<List<dynamic>> csvTable =
      //     const CsvToListConverter().convert(csvData);

      // print(csvTable);

      //   print("1");
      //   LockRecord record = LockRecord(row[0], row[1]);

      //   logs.add(record);

      // setState(() {});
      // Trigger a rebuild to update the UI
    } catch (e) {
      // print('Error loading attendance data: $e');
    }
  }

  var isSelected = [true, false, false];

  @override
  void initState() {
    loadLockData();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget buildActionChip(BuildContext context,
        {String? level,
        required int count,
        bool isSelect = false,
        required int index}) {
      return ActionChip(
        label: Text(
          '${(level ?? 'All')} ($count)',
          style: const TextStyle(fontSize: 20),
        ),
        onPressed: () {
          if (index == 0) {
            isSelected[0] = true;
            isSelected[1] = false;
            isSelected[2] = false;
          } else if (index == 1) {
            isSelected[0] = false;
            isSelected[1] = true;
            isSelected[2] = false;
          } else if (index == 2) {
            isSelected[0] = false;
            isSelected[1] = false;
            isSelected[2] = true;
          }
          setState(() {});

          // _filter = _filter.copyWithPage(1);
          // _filter = _filter.copyWithLevel(level);
          // _filterLogs();
        },
        backgroundColor: isSelect ? Colors.blueAccent : Colors.grey,
        labelStyle: const TextStyle(color: Colors.white),
      );
    }

    return Scaffold(
        backgroundColor: lightColorScheme.background,
        appBar: AppBar(
          title: const Text("Log lock"),
          actions: [
            // IconButton(
            //   icon: const Icon(Icons.save),
            //   onPressed: () {},
            // ),
            IconButton(
              icon: const Icon(Icons.save_alt_rounded),
              onPressed: () async {
                if (!await launchUrl(Uri.parse(
                    'http://${Gateway.host}:${Gateway.portHttp}/history_lock'))) {
                  throw Exception('Could not launch dfgdfg');
                }
              },
            ),
          ],
        ),
        body: isLoaded
            ? SafeArea(
                child: SizedBox.expand(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: PlatformSearchBar(
                                controller: _textEditingController,
                              ),
                            ),
                            SizedBox(
                                height: 36,
                                child: ListView(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    buildActionChip(context,
                                        count: _levelsCounts[0].length,
                                        isSelect: isSelected[0],
                                        index: 0),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    buildActionChip(context,
                                        count: _levelsCounts[1].length,
                                        level: "Open",
                                        isSelect: isSelected[1],
                                        index: 1),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    buildActionChip(context,
                                        count: _levelsCounts[2].length,
                                        level: "Close",
                                        isSelect: isSelected[2],
                                        index: 2)
                                  ],
                                )),
                            const SizedBox(height: 8),
                            Expanded(
                              child: isSelected[0]
                                  ? ListView.builder(
                                      itemBuilder: (context, index) {
                                        return Card(
                                          elevation: 9.0,
                                          margin: const EdgeInsets.all(16.0),
                                          child: ExpansionTile(
                                            initiallyExpanded:
                                                index % 2 == 0 ? true : false,
                                            backgroundColor: Colors.grey[200],
                                            collapsedBackgroundColor:
                                                Colors.lightBlueAccent,
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  formatDateTime(DateTime.parse(
                                                      _levelsCounts[0][index]
                                                          .timestamp)),
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 30,
                                                ),
                                                Text(
                                                  _levelsCounts[0][index]
                                                      .state
                                                      .toUpperCase(),
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: _levelsCounts[0].length)
                                  : isSelected[1]
                                      ? ListView.builder(
                                          itemBuilder: (context, index) {
                                            return Card(
                                              elevation: 9.0,
                                              margin:
                                                  const EdgeInsets.all(16.0),
                                              child: ExpansionTile(
                                                initiallyExpanded:
                                                    index % 2 == 0
                                                        ? true
                                                        : false,
                                                backgroundColor:
                                                    Colors.grey[200],
                                                collapsedBackgroundColor:
                                                    Colors.lightBlueAccent,
                                                title: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      formatDateTime(
                                                          DateTime.parse(
                                                              _levelsCounts[1]
                                                                      [index]
                                                                  .timestamp)),
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 30,
                                                    ),
                                                    Text(
                                                      _levelsCounts[1][index]
                                                          .state
                                                          .toUpperCase(),
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                          itemCount: _levelsCounts[1].length)
                                      : ListView.builder(
                                          itemBuilder: (context, index) {
                                            return Card(
                                              elevation: 9.0,
                                              margin:
                                                  const EdgeInsets.all(16.0),
                                              child: ExpansionTile(
                                                initiallyExpanded:
                                                    index % 2 == 0
                                                        ? true
                                                        : false,
                                                backgroundColor:
                                                    Colors.grey[200],
                                                collapsedBackgroundColor:
                                                    Colors.lightBlueAccent,
                                                title: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      formatDateTime(
                                                          DateTime.parse(
                                                              _levelsCounts[2]
                                                                      [index]
                                                                  .timestamp)),
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 30,
                                                    ),
                                                    Text(
                                                      _levelsCounts[2][index]
                                                          .state
                                                          .toUpperCase(),
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                          itemCount: _levelsCounts[2].length),

                              // ListView(
                              //   padding: const EdgeInsets.all(8.0),
                              //   children: [
                              //     Card(
                              //       elevation: 2.0,
                              //       child: ExpansionTile(
                              //         backgroundColor: Colors.greenAccent,
                              //         title: Row(
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.spaceBetween,
                              //           children: [
                              //             Text(
                              //               formatDateTime(DateTime.timestamp()),
                              //               style: const TextStyle(
                              //                 // color: Colors.black,
                              //                 fontWeight: FontWeight.w500,
                              //               ),
                              //             ),
                              //             Container(
                              //               padding: const EdgeInsets.symmetric(
                              //                 horizontal: 10,
                              //                 vertical: 6,
                              //               ),
                              //               decoration: BoxDecoration(
                              //                 color: Colors.white,
                              //                 borderRadius: BorderRadius.circular(6),
                              //               ),
                              //               child: Text(
                              //                 "open".toUpperCase(),
                              //                 style: TextStyle(
                              //                   color: Colors.black,
                              //                   fontWeight: FontWeight.w600,
                              //                 ),
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //     ),
                              //     Card(
                              //       elevation: 2.0,
                              //       child: ExpansionTile(
                              //         backgroundColor: Colors.greenAccent,
                              //         title: Row(
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.spaceBetween,
                              //           children: [
                              //             Text(
                              //               formatDateTime(DateTime.timestamp()),
                              //               style: const TextStyle(
                              //                 // color: Colors.black,
                              //                 fontWeight: FontWeight.w500,
                              //               ),
                              //             ),
                              //             Container(
                              //               padding: const EdgeInsets.symmetric(
                              //                 horizontal: 10,
                              //                 vertical: 6,
                              //               ),
                              //               decoration: BoxDecoration(
                              //                 color: Colors.white,
                              //                 borderRadius: BorderRadius.circular(6),
                              //               ),
                              //               child: Text(
                              //                 "open".toUpperCase(),
                              //                 style: TextStyle(
                              //                   color: Colors.black,
                              //                   fontWeight: FontWeight.w600,
                              //                 ),
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //     )
                              //   ],
                              // ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }
}
