import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

class DeleteUserPage extends StatefulWidget {
  const DeleteUserPage({super.key});

  @override
  State<DeleteUserPage> createState() => _DeleteUserPageState();
}

class _DeleteUserPageState extends State<DeleteUserPage> {
  List<String> imageList = [];
  List<bool> isTap = [];
  @override
  void initState() {
    super.initState();
    _getImageList();
  }

  // Hàm để lấy danh sách tên tệp hình ảnh từ server
  Future<void> _getImageList() async {
    final response =
        await http.get(Uri.parse('http://115.79.196.171:6788/get_image_list'));
    if (response.statusCode == 200) {
      setState(() {
        imageList = List<String>.from(json.decode(response.body));
        isTap = List<bool>.filled(imageList.length, false, growable: false);
      });
    } else {
      log('Failed to fetch image list');
    }
  }

  // Hàm để xóa hình ảnh từ server
  Future<void> _deleteImage(String filename, int index) async {
    isTap[index] = true;
    setState(() {});
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: const Text('Confirm Deletion'),
          content: const Text('Do you really want to delete this image?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                isTap[index] = false;
                setState(() {});
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                isTap[index] = false;
                setState(() {});
                Navigator.of(context).pop();
                _performDeleteImage(filename);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // Hàm để thực hiện xóa hình ảnh sau khi xác nhận
  Future<void> _performDeleteImage(String filename) async {
    final response = await http.post(
        Uri.parse('http://${ServerAI.host}:${ServerAI.port}/delete_image'),
        body: {'image_filename': filename});
    if (response.statusCode == 200) {
      log(response.body);

      _getImageList(); // Refresh danh sách sau khi xóa
    } else {
      log('Failed to delete image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Person'),
      ),
      body: imageList.isEmpty
          ? const Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('No image found'),
              ],
            ))
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: imageList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    title: Text(imageList[index]),
                    tileColor: isTap[index] ? Colors.cyan : Colors.green,
                    onTap: () {
                      _deleteImage(imageList[index], index);
                    },
                    // selected: true,
                    // selectedTileColor: Colors.white,
                    // selectedColor: Colors.black
                  ),
                );
              },
            ),
    );
  }
}
