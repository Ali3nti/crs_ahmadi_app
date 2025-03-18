import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FileUploadScreen extends StatefulWidget {
  @override
  _FileUploadScreenState createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  File? selectedFile;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> uploadFile() async {
    if (selectedFile == null) return;

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://your-api.com/upload'),
    );
    request.files.add(await http.MultipartFile.fromPath(
      'file',
      selectedFile!.path,
    ));

    var response = await request.send();
    if (response.statusCode == 200) {
      print('File uploaded successfully');
    } else {
      print('File upload failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: pickFile,
              child: Text('Pick File'),
            ),
            if (selectedFile != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Selected: ${selectedFile!.path}'),
              ),
            ElevatedButton(
              onPressed: uploadFile,
              child: Text('Upload File'),
            ),
          ],
        ),
      ),
    );
  }
}
