import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wf_transfer/display_notifier.dart';
import 'package:wf_transfer/pages/edit_game.dart';
import 'package:wf_transfer/pages/transfer_setup.dart';
import 'loading_widget.dart';
import 'package:wf_transfer/theme.dart';
import 'package:wf_transfer/game.dart';

class GameSelect extends StatefulWidget {
  const GameSelect({Key? key}) : super(key: key);

  @override
  State<GameSelect> createState() => _GameSelect();
}

class _GameSelect extends State<GameSelect> {
  bool _loaded = false;
  Map<String, String> saveLocations = {};

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
    column.add(Text(
      "Official database:",
      style: AppTheme.titleText,
      textAlign: TextAlign.center,
    ));
    // for each game in notifier
    for (Game game in Provider.of<DisplayChangeNotifier>(context).getDb.games) {
      column.add(createGameRow(game, context));
    }
    // User database section
    column.add(Text(
      "User database:",
      style: AppTheme.titleText,
      textAlign: TextAlign.center,
    ));
    // for each game in notifier
    for (Game game
        in Provider.of<DisplayChangeNotifier>(context).getUserDb.games) {
      column.add(createGameRow(game, context));
    }
    return ListView(
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

  Widget createGameRow(Game game, context) {
    ListTile row = ListTile(
      trailing: SizedBox(
        width: 50,
        height: 50,
        child: TextButton(
          onPressed: () {
            Provider.of<DisplayChangeNotifier>(context, listen: false)
                .push(EditGame(game: game));
          },
          child: const Icon(Icons.edit),
        ),
      ),
      leading: AppTheme.diskImage(game.getImg),
      title: Text(
        game.getName,
        style: AppTheme.normalText,
      ),
      subtitle: Text(
        game.getInfo,
        style: AppTheme.subText,
      ),
      onTap: () {
        Provider.of<DisplayChangeNotifier>(context, listen: false)
            .push(TransferSetup(game: game));
      },
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: AppTheme.highlightedWidget(row, context),
    );
  }
}
