import 'game.dart';
import 'dart:io';
import 'package:wf_transfer/theme.dart';

class Games {
  List<Game> games = [];
  String lastError = "";
  String filename;

  Games(this.filename);

  Game getGame(int index) {
    return games[index];
  }

  Future<List<Game>> readGamesFromDisk() async {
    String fileDir = "${AppTheme.datafolder}${filename}.csv";
    File file = File(fileDir);
    List<Game> gamesFound = [];
    try {
      if (await file.exists()) {
        String contents = await file.readAsString();
        List<String> lines = contents.split("\n");
        gamesFound = [];
        for (int i = 1; i < lines.length; i++) {
          List<String> gameInfo = lines[i].split(",");
          gamesFound.add(Game(gameInfo[0], gameInfo[1], gameInfo[2],
              gameInfo[3], gameInfo[4].replaceAll("\r", "")));
        }
      }
    } catch (e) {
      gamesFound = [];
      lastError = e.toString();
    }
    return games = gamesFound;
  }

  List<Game> getAllGames() {
    return games;
  }
}
