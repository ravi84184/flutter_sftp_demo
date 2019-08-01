import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:ssh/ssh.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';

void main() => runApp(HomePage());


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    permission();
  }
  String _result = '';
  List _array;


  Future<void> onClickSFTP() async {
    var client = new SSHClient(
      host: "192.168.9.177",
      port: 22,
      username: "mobile",
      passwordOrKey: "p@ssw0rd",
    );
    print("-");
    try {
      String result = await client.connect();
      print("--");
      if (result == "session_connected") {
        result = await client.connectSFTP();
        if (result == "sftp_connected") {
          /*var array = await client.sftpLs();
          setState(() {
            _result = result;
            _array = array;
          });*/
//          print("--"+await client.sftpMkdir("testsftp"));
         /* print("---"+await client.sftpRename(
            oldPath: "testsftp",
            newPath: "testsftprename",
          ));*/
//          print("----"+await client.sftpRmdir("testsftprename"));

//          Directory tempDir = await getTemporaryDirectory();
//          String tempPath = tempDir.path;
          /*var filePath = await client.sftpDownload(
            path: "testupload",
            toPath: tempPath,
            callback: (progress) async {
              print("-----"+progress);
              // if (progress == 20) await client.sftpCancelDownload();
            },
          );*/

//          print("------"+await client.sftpRm("testupload"));

          print("-------"+await client.sftpUpload(
            path: filePath,
            toPath: "testsftp",
            callback: (progress) async {
              print("-----"+progress.toString());
              // if (progress == 30) await client.sftpCancelUpload();
            },
          ));

          print("--------"+await client.disconnectSFTP());

          print("---------"+await client.disconnect());
        }
      }
    } on PlatformException catch (e) {
      print('Error: ${e.code}\nError Message: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget renderButtons() {
      return ButtonTheme(
        padding: EdgeInsets.all(5.0),
        child: ButtonBar(
          children: <Widget>[
            FlatButton(
              child: Text(
                'Test command',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: (){permission();},
              color: Colors.blue,
            ),

            FlatButton(
              child: Text(
                'Test SFTP',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: onClickSFTP,
              color: Colors.blue,
            ),
          ],
        ),
      );
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ssh plugin example app'),
        ),
        body: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(15.0),
          children: <Widget>[
            Text(
                "Please edit the connection setting in the source code before clicking the test buttons"),
            renderButtons(),
            Text(_result),
            _array != null && _array.length > 0
                ? Column(
              children: _array.map((f) {
                return Text(
                    "${f["filename"]} ${f["isDirectory"]} ${f["modificationDate"]} ${f["lastAccess"]} ${f["fileSize"]} ${f["ownerUserID"]} ${f["ownerGroupID"]} ${f["permissions"]} ${f["flags"]}");
              }).toList(),
            )
                : Container(),
          ],
        ),
      ),
    );
  }

  String filePath;
  Future permission() async {
    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.storage,PermissionGroup.camera,PermissionGroup.photos]);
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    filePath = await FilePicker.getFilePath(type: FileType.IMAGE);
  }
}


