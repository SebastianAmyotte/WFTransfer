import 'package:flutter/material.dart';
import 'package:wf_transfer/game.dart';
import 'package:wf_transfer/pages/save_data.dart';
import 'package:wf_transfer/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class TransferPage extends StatefulWidget {
  const TransferPage({Key? key, required this.transfer}) : super(key: key);

  final Transfer transfer;

  @override
  _TransferPage createState() => _TransferPage();
}

class _TransferPage extends State<TransferPage> {
  late Transfer transfer;

  TextEditingController renameSaveController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Widget> column = [];
    column.add(
      Text(
        "${transfer.save.getName} for ${transfer.game.getName}",
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
    // column.add(
    //   Text(
    //       "Steam: ${transfer.destinationComputer}. Mobile: ${transfer.destinationMobile}. Source: ${transfer.saveSource}"),
    // );
    column.add(
      Padding(
        padding: AppTheme.buttonPadding,
        child: TextButton(
          style: AppTheme.largeButtonStyle,
          onPressed: () {
            //TODO: Transfer to steam
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
              //TODO: Transfer to phone
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
            launchUrl(Uri.parse('file:${transfer.saveSource}'));
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
            openDialog().then(
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
            child: const Text("Delete save"),
            style: AppTheme.largeButtonStyle,
            onPressed: () {}),
      ),
    );
    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      children: column,
    );
  }

  void updateSaveName(context) {
    Navigator.of(context).pop(renameSaveController.text);
  }

  Future<String?> openDialog() => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppTheme.backgroundColor,
          title: Text(
            "Choose new name:",
            style: AppTheme.normalText,
          ),
          content: TextField(
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
                updateSaveName(context);
              },
            ),
          ],
        ),
      );

  void changeSaveName(String newName) {
    //TODO: Rename save using value (could be NULL)
  }
}

class Transfer {
  final Game game;
  final SaveData save;
  final String saveSource;
  final String destinationMobile;
  final String destinationComputer;
  bool transferringToPhone;
  bool transferringFromComputer;

  Transfer(this.game, this.save, this.saveSource, this.destinationMobile,
      this.destinationComputer,
      {this.transferringToPhone = false,
      this.transferringFromComputer = false});
}
