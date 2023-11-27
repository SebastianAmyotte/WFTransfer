import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wf_transfer/display_notifier.dart';
import 'package:wf_transfer/theme.dart';
import 'package:wf_transfer/game.dart';

class EditGame extends StatefulWidget {
  final Game game;
  const EditGame({Key? key, required this.game}) : super(key: key);

  @override
  State<EditGame> createState() => _EditGame();
}

class _EditGame extends State<EditGame> {
  late Game game = widget.game;
  TextEditingController editSaveLocationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Widget> column = [];
    column.add(Text(
      "Game: ${game.name}",
      style: AppTheme.titleText,
      textAlign: TextAlign.center,
    ));
    // Default location
    column.add(Text(
      "Default save location:",
      style: AppTheme.subtitleText,
      textAlign: TextAlign.left,
    ));
    column.add(Text(
      game.desktopLocation,
      style: AppTheme.normalText,
      textAlign: TextAlign.left,
    ));
    column.add(Text(
      "- If the game's save data is not found at this location, you can change it below.",
      style: AppTheme.normalText,
      textAlign: TextAlign.left,
    ));
    // User location
    column.add(
      Text(
        "Custom save location:",
        style: AppTheme.subtitleText,
        textAlign: TextAlign.left,
      ),
    );
    column.add(Row(
      children: [
        SizedBox(
          height: 50,
          child: AppTheme.highlightedWidget(
              TextButton(
                onPressed: () {
                  editInstallLocation().then(
                    (value) => {
                      if (value != null) {updateInstall(value)}
                    },
                  );
                },
                child: const Icon(Icons.edit),
              ),
              context),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              Provider.of<DisplayChangeNotifier>(context)
                      .getUserSaveLocation(game.name) ??
                  "Not set",
              style: AppTheme.normalText,
            ),
          ),
        ),
      ],
    ));
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: Column(
        children: column,
      ),
    );
  }

  Future<String?> editInstallLocation() => showDialog<String>(
        context: context,
        builder: (context) => RawKeyboardListener(
          focusNode: FocusNode(),
          onKey: (event) {
            if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
              Navigator.of(context).pop(editSaveLocationController.text);
            } else if (event.isKeyPressed(LogicalKeyboardKey.escape)) {
              Navigator.of(context).pop();
            }
          },
          child: AlertDialog(
            backgroundColor: AppTheme.backgroundColor,
            title: Text(
              "Choose new location:",
              style: AppTheme.normalText,
            ),
            content: TextField(
              autofocus: true,
              controller: editSaveLocationController,
              decoration: InputDecoration(
                hintText: "Root directory here",
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
                  "Confirm",
                  style: AppTheme.normalText,
                ),
                onPressed: () {
                  Navigator.of(context).pop(editSaveLocationController.text);
                },
              ),
            ],
          ),
        ),
      );

  void updateInstall(String newName) async {
    Provider.of<DisplayChangeNotifier>(context, listen: false)
        .setUserSaveLocation(game.name, newName);
  }
}
