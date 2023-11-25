import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wf_transfer/display_notifier.dart';
import 'loading_widget.dart';
import 'package:wf_transfer/theme.dart';
import 'package:wf_transfer/game.dart';
import 'dart:io';

class MobileToDesktop extends StatefulWidget {
  const MobileToDesktop({Key? key}) : super(key: key);

  @override
  _MobileToDesktop createState() => _MobileToDesktop();
}

class _MobileToDesktop extends State<MobileToDesktop> {
  bool _loaded = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> column = [];
    if (!_loaded) {
      column.add(const LoadingWidget());
      load(context);
      return Column(
        children: column,
      );
    }
    // Official database section
    column.add(Text("Official database:", style: AppTheme.titleText));
    // for each game in notifier
    for (Game game in Provider.of<DisplayChangeNotifier>(context).getDb.games) {
      column.add(createGameRow(game));
    }
    return Column(
      children: column,
    );
  }

  void load(context) async {
    Provider.of<DisplayChangeNotifier>(context, listen: false)
        .readGamesFromDisk()
        .then(
          (value) => setState(
            () {
              _loaded = true;
            },
          ),
        );
  }

  Row createGameRow(Game game) {
    Row row = Row(
      children: [
        diskImage(game.getImg),
        Text(game.getName),
      ],
    );
    return row;
  }

  Image diskImage(String filename) {
    FileImage fileImage =
        FileImage(File("${AppTheme.datafolder}img\\$filename"));
    return Image(image: fileImage, fit: BoxFit.fitHeight, height: 50);
  }
}
