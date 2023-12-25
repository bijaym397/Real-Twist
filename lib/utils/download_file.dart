import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:real_twist/main.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';

class DownloadFile extends StatefulWidget {
  String urlPDF;
  String namePDF;
  DownloadFile({
    Key? key,
    required this.urlPDF,
    required this.namePDF,
  }) : super(key: key);

  @override
  State<DownloadFile> createState() => _DownloadFileState();
}

class _DownloadFileState extends State<DownloadFile> {
  double? _progress = 0.0;
  @override
  Widget build(BuildContext context) {
    return  Platform.isAndroid ? androidFileDownload() : iosFileDownload();
  }

  iosFileDownload() async {
    final file = await downloadFile(url: widget.urlPDF, name: widget.namePDF);
    if (file == null) return;
    OpenFile.open(file.path);
    customLoader!.hide();
  }

  androidFileDownload() async {
    FileDownloader.downloadFile(
        url: widget.urlPDF,
        name: widget.namePDF,
        onProgress: (name, progress) {
          setState(() {
            _progress = progress;
          });
        },
        onDownloadCompleted: (value) {
          print('path  $value ');
          setState(() {
            _progress = null;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("File downloaded Successfully"),
            ));
          });
        }).then((value) => customLoader!.hide());
  }

  Future openFile() async {
    final file = await downloadFile(url: widget.urlPDF, name: widget.namePDF);
    if (file == null) return;
    OpenFile.open(file.path);
  }

  Future<File?> downloadFile({@required url, @required name}) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File("${appStorage.path}/$name");
    try {
      final response = await Dio().get(url,
          options: Options(
            receiveTimeout: Duration(seconds: 3),
            followRedirects: false,
            responseType: ResponseType.bytes,
          ));
      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      return file;
    } catch (e) {
      return null;
    }
  }

}