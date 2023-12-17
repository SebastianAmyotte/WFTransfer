import 'dart:io';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:wf_transfer/display_notifier.dart';
import 'package:wf_transfer/game.dart';
import 'package:wf_transfer/pages/loading_widget.dart';
import 'package:wf_transfer/pages/save_data.dart';
import 'package:wf_transfer/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class TransferPage extends StatefulWidget {
  const TransferPage({Key? key, required this.transfer}) : super(key: key);

  final Transfer transfer;

  @override
  State<TransferPage> createState() => _TransferPage();
}

class _TransferPage extends State<TransferPage> {
  late Transfer transfer = widget.transfer;
  bool _loading = false;
  TextEditingController renameSaveController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: LoadingWidget(),
      );
    }
    List<Widget> column = [];
    column.add(
      Text(
        "${transfer.save.saveName} for ${transfer.game.getName}",
        style: AppTheme.normalText,
        textAlign: TextAlign.center,
      ),
    );
    column.add(
      Text(
        "Save date: ${transfer.save.getDate}",
        style: AppTheme.normalText,
        textAlign: TextAlign.center,
      ),
    );
    column.add(
      Padding(
        padding: AppTheme.buttonPadding,
        child: TextButton(
          style: AppTheme.largeButtonStyle,
          onPressed: () {
            confirmTransferDialog().then(
              (choice) {
                if (choice != null && choice) {
                  setState(() {
                    _loading = true;
                  });
                  transferToDesktop().then(
                    (value) {
                      setState(() {
                        _loading = false;
                      });
                    },
                  );
                }
              },
            );
          },
          child: const Text("Transfer to Steam"),
        ),
      ),
    );
    column.add(
      Padding(
        padding: AppTheme.buttonPadding,
        child: TextButton(
          style: AppTheme.phoneSelected(context)
              ? AppTheme.largeButtonStyle
              : AppTheme.largeButtonStyleDisabled,
          onPressed: () {
            if (AppTheme.phoneSelected(context)) {
              confirmTransferDialog().then(
                (choice) {
                  if (choice != null && choice) {
                    setState(() {
                      _loading = true;
                    });
                    transferToPhone().then(
                      (value) {
                        setState(() {
                          _loading = false;
                        });
                      },
                    );
                  }
                },
              );
            } else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AppTheme.dialog(context, "No device",
                        "Please select a device to transfer to in the settings.");
                  });
            }
          },
          child: const Text("Transfer to Mobile"),
        ),
      ),
    );
    column.add(
      Padding(
        padding: AppTheme.buttonPadding,
        child: TextButton(
          style: AppTheme.largeButtonStyle,
          onPressed: () async {
            launchUrl(Uri.parse('file:${transfer.save.getPath}'));
          },
          child: const Text("Reveal in file explorer"),
        ),
      ),
    );
    column.add(
      Padding(
        padding: AppTheme.buttonPadding,
        child: TextButton(
          style: AppTheme.largeButtonStyle,
          onPressed: () {
            renameDialog().then(
              (value) => {
                if (value != null) {changeSaveName(value)}
              },
            );
          },
          child: const Text("Rename save"),
        ),
      ),
    );
    column.add(
      Padding(
        padding: AppTheme.buttonPadding,
        child: TextButton(
            style: AppTheme.largeButtonStyleDisabled,
            onPressed: () {
              confirmDeleteDialog().then(
                (choice) => {
                  if (choice != null && choice) {deleteSave(context)}
                },
              );
            },
            child: const Text("Delete save")),
      ),
    );
    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      children: column,
    );
  }

  Future<String?> renameDialog() => showDialog<String>(
        context: context,
        builder: (context) => RawKeyboardListener(
          focusNode: FocusNode(),
          onKey: (event) {
            if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
              Navigator.of(context).pop(renameSaveController.text);
            } else if (event.isKeyPressed(LogicalKeyboardKey.escape)) {
              Navigator.of(context).pop();
            }
          },
          child: AlertDialog(
            backgroundColor: AppTheme.backgroundColor,
            title: Text(
              "Choose new name:",
              style: AppTheme.normalText,
            ),
            content: TextField(
              autofocus: true,
              controller: renameSaveController,
              decoration: InputDecoration(
                hintText: "New name",
                hintStyle: AppTheme.normalText,
              ),
              style: AppTheme.normalText,
              cursorColor: AppTheme.textColorHighlight,
            ),
            actions: [
              TextButton(
                child: Text(
                  "Cancel",
                  style: AppTheme.normalText,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  "Rename",
                  style: AppTheme.normalText,
                ),
                onPressed: () {
                  Navigator.of(context).pop(renameSaveController.text);
                },
              ),
            ],
          ),
        ),
      );

  void changeSaveName(String newName) async {
    Directory saveDir = Directory(transfer.save.savePath);
    String newDirName = '${newName}_${transfer.save.diskDate()}';
    setState(() {
      _loading = true;
    });
    String newDir = "${saveDir.parent.path}\\$newDirName";
    if (!await Directory(newDir).exists()) {
      await saveDir.rename(newDir);
      setState(() {
        transfer.save.setName = newName;
        _loading = false;
      });
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AppTheme.dialog(context, "Error",
              "A save with that name already exists. Please choose a different name.");
        },
      );
      setState(() {
        _loading = false;
      });
    }
  }

  Future<bool?> confirmDeleteDialog() => showDialog<bool>(
        context: context,
        builder: (context) => RawKeyboardListener(
          focusNode: FocusNode(),
          onKey: (event) {
            if (event.isKeyPressed(LogicalKeyboardKey.escape)) {
              Navigator.of(context).pop(false);
            }
          },
          child: AlertDialog(
            backgroundColor: AppTheme.backgroundColor,
            title: Text(
              "Are you sure you want to delete ${transfer.save.getName}? This can NOT be undone!",
              style: AppTheme.normalText,
            ),
            actions: [
              TextButton(
                child: Text(
                  "Cancel",
                  style: AppTheme.normalText,
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: Text(
                  "DELETE",
                  style: AppTheme.normalText
                      .copyWith(color: AppTheme.buttonBackgroundAlertColor),
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          ),
        ),
      );

  void deleteSave(context) async {
    Directory saveDir = Directory(transfer.save.savePath);
    setState(() {
      _loading = true;
    });
    await saveDir.delete(recursive: true);
    Provider.of<DisplayChangeNotifier>(context, listen: false).pop();
  }

  Future<bool?> confirmTransferDialog() => showDialog<bool>(
        context: context,
        builder: (context) => RawKeyboardListener(
          focusNode: FocusNode(),
          onKey: (event) {
            if (event.isKeyPressed(LogicalKeyboardKey.escape)) {
              Navigator.of(context).pop(false);
            }
          },
          child: AlertDialog(
            backgroundColor: AppTheme.backgroundColor,
            title: Text(
              "Are you sure you want to transfer ${transfer.save.getName}? This will overwrite all save data at the destination",
              style: AppTheme.normalText,
            ),
            actions: [
              TextButton(
                child: Text(
                  "Cancel",
                  style: AppTheme.normalText,
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: Text(
                  "DELETE",
                  style: AppTheme.normalText
                      .copyWith(color: AppTheme.buttonBackgroundAlertColor),
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          ),
        ),
      );

  //TODO
  Future transferToPhone() async {
    // Provider.of<DisplayChangeNotifier>(context, listen: false).phoneName; //Phone name
    // transfer.save.savePath; // Save path
    // transfer.destinationMobile; // destination path
    var exitCode = -1;
    if (exitCode == -1) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AppTheme.dialog(context, "Error",
              "An error occurred while transferring the save. Please try again.");
        },
      );
    }
  }

  //TODO
  Future transferToDesktop() async {
    var exitCode = -1;
    if (exitCode == -1) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AppTheme.dialog(context, "Error",
              "An error occurred while transferring the save. Please try again.");
        },
      );
    }
  }
}

class Transfer {
  final Game game;
  final SaveData save;
  final String destinationMobile;
  final String destinationComputer;
  bool transferringToPhone;
  bool transferringFromComputer;

  Transfer(
      this.game, this.save, this.destinationMobile, this.destinationComputer,
      {this.transferringToPhone = false,
      this.transferringFromComputer = false});
}
