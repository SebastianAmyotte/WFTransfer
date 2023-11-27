import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wf_transfer/display_notifier.dart';
import 'package:wf_transfer/game.dart';
import 'package:wf_transfer/pages/save_data.dart';
import 'package:wf_transfer/theme.dart';
import 'dart:io';
import 'loading_widget.dart';
import 'transfer.dart';

class TransferSetup extends StatefulWidget {
  final Game game;

  const TransferSetup({Key? key, required this.game}) : super(key: key);

  @override
  State<TransferSetup> createState() => _TransferSetup();
}

class _TransferSetup extends State<TransferSetup> {
  late Game game = widget.game;
  late String path = '${AppTheme.datafolder}saves\\${game.name}';
  bool _loading = true;
  bool _waitingForCopy = false;
  List<SaveData> saves = [];

  String popupDialogueChoice = "";

  @override
  Widget build(BuildContext context) {
    if (_waitingForCopy) {
      return const LoadingWidget();
    }
    if (_loading) {
      saves = [];
      load(context).then((value) => {
            setState(() {
              _loading = false;
            })
          });
      return const LoadingWidget();
    }

    List<Widget> column = [];
    column.add(AppTheme.diskImage(game.img));
    for (SaveData save in saves) {
      column.add(ListTile(
        title: Text(
          save.getName,
          style: AppTheme.titleText,
        ),
        subtitle: Text(save.getDate, style: AppTheme.subText),
        onTap: () {
          Provider.of<DisplayChangeNotifier>(context, listen: false)
              .push(TransferPage(
            transfer: Transfer(
                game,
                save,
                "${AppTheme.phoneDataDirectory()}${game.getMobileLocation}\\",
                game.desktopLocation),
          ));
        },
      ));
    }
    column.add(Padding(
      padding: AppTheme.buttonPadding,
      child: TextButton(
        onPressed: () {
          // Get the information
          String saveName = generateSaveName("desktop");
          DateTime saveDate = DateTime.now();
          SaveData saveData = SaveData(saveName, saveDate, path);
          // Transfer the save to the data folder
          setState(() {
            _waitingForCopy = true;
          });
          copyFolders(
            game.folders,
            game.desktopLocation,
            "$path\\${saveData.diskName()}",
          ).then(
            (value) {
              setState(() {
                _waitingForCopy = false;
                _loading = true;
              });
            },
          );
        },
        style: AppTheme.largeButtonStyleAlert,
        child: const Text("Backup computer save"),
      ),
    ));
    column.add(Padding(
      padding: AppTheme.buttonPadding,
      child: TextButton(
        onPressed: () {
          String saveName = generateSaveName("mobile");
          DateTime saveDate = DateTime.now();
          SaveData saveData = SaveData(saveName, saveDate, path);
          String phoneName =
              Provider.of<DisplayChangeNotifier>(context, listen: false)
                  .phoneName;
          if (phoneName == "None") {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AppTheme.dialog(
                    context, "No device", "Please connect a device");
              },
            );
            return;
          }
          setState(() {
            _waitingForCopy = true;
          });
          copyFromDevice(
            game.folders,
            phoneName,
            game.mobileLocation,
            "saves\\${game.name}\\${saveData.diskName()}",
          ).then(
            (value) {
              setState(() {
                _waitingForCopy = false;
                _loading = true;
              });
            },
          );
        },
        style: AppTheme.largeButtonStyleAlert,
        child: const Text("Backup device save"),
      ),
    ));
    return ListView(
      children: column,
    );
  }

  String generateSaveName(String platform) {
    // Get the information
    String saveName = "New $platform save";
    for (SaveData save in saves) {
      if (save.getName == saveName) {
        saveName = "New $platform save ${saves.length}";
      }
    }
    return saveName;
  }

  Future<int> load(context) async {
    // Get a list of all folders in the game folder
    List<FileSystemEntity> saveFolder = [];
    try {
      List<FileSystemEntity> saveFolder = Directory(path).listSync();
      for (FileSystemEntity save in saveFolder) {
        String folderName = save.path.split('\\').last;
        // Get the name of the save
        String saveName = folderName.split('_').first;
        // Get the date of the save
        DateTime saveDate = DateTime.parse(folderName.split('_').last);
        // Create a SaveData object
        SaveData saveData = SaveData(saveName, saveDate, save.path);
        saves.add(saveData);
      }
    } catch (e) {
      saveFolder = [];
      saves = [];
    }
    return saveFolder.length;
  }

  Future copyFolders(
      List<String> folders, String source, String destination) async {
    for (String folder in folders) {
      if (folder == "ROOT") {
        folder = "";
      } else {
        folder = "\\$folder";
      }
      // Copy the folder
      await Process.run(
        'MTPAPI/MTPAPI.exe',
        [
          'XFER',
          '$source$folder',
          '$destination$folder',
        ],
      );
    }
  }

  Future copyFromDevice(List<String> folders, String deviceName, String source,
      String destination) async {
    for (String folder in folders) {
      if (folder == "ROOT") {
        folder = "";
      } else {
        folder = "\\$folder";
      }
      // Copy the folder
      await Process.run(
        'MTPAPI/MTPAPI.exe',
        [
          'READ',
          deviceName,
          '$source$folder',
          '$destination$folder',
        ],
      );
    }
  }
}
