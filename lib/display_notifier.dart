import 'package:flutter/material.dart';
import 'package:wf_transfer/game.dart';
import 'package:wf_transfer/pages/main_menu.dart';
import 'package:wf_transfer/theme.dart';
import 'dart:io';
import 'games.dart';

class DisplayChangeNotifier extends ChangeNotifier {
  List<Widget> _displayStack = [];
  List<Widget> get displayStack => _displayStack;
  String phone = "None";
  List<String> phonesList = [];

  DisplayChangeNotifier(context) {
    _displayStack = [const MainMenuPage()];
  }

  void push(Widget widget) {
    _displayStack.add(widget);
    notifyListeners();
  }

  void pop() {
    _displayStack.removeLast();
    if (_displayStack.isEmpty) {
      exit(0);
    }
    notifyListeners();
  }

  Widget get top {
    return _displayStack.last;
  }

  set setPhone(String selection) {
    phone = selection;
    notifyListeners();
  }

  String get phoneName {
    return phone;
  }

  // Games section
  Games db = Games("db");
  Games userDb = Games("user_db");
  Map<String, String> saveLocations = {};

  Future<String> readGamesFromDisk() async {
    await db.readGamesFromDisk();
    await userDb.readGamesFromDisk();
    await readSaveLocations();

    return "";
  }

  Future readSaveLocations() async {
    String fileDir = "${AppTheme.datafolder}user_game_locations.csv";
    File file = File(fileDir);
    try {
      if (await file.exists()) {
        String contents = await file.readAsString();
        List<String> lines = contents.split("\n");
        saveLocations = {};
        for (int i = 1; i < lines.length; i++) {
          List<String> gameInfo = lines[i].split(",");
          saveLocations[gameInfo[0]] = gameInfo[1];
        }
      }
    } catch (e) {
      saveLocations = {};
    }
    // Update the path for each game
    for (Games database in [db, userDb]) {
      for (Game game in database.games) {
        String? gamePath = getUserSaveLocation(game.name);
        if (gamePath != null) {
          game.desktopLocation = gamePath;
        }
      }
    }
  }

  String? getUserSaveLocation(String gameName) {
    if (saveLocations.containsKey(gameName) &&
        saveLocations[gameName]!.isNotEmpty) {
      return saveLocations[gameName];
    }
    return null;
  }

  void setUserSaveLocation(String gameName, String saveLocation) {
    saveLocations[gameName] = saveLocation;
    updateUserSaveLocations();
    notifyListeners();
  }

  void updateUserSaveLocations() {
    String fileDir = "${AppTheme.datafolder}user_game_locations.csv";
    File file = File(fileDir);
    String contents = "Game,Save Location\n";
    for (String gameName in saveLocations.keys) {
      contents += "$gameName,${saveLocations[gameName]}\n";
    }
    file.writeAsString(contents);
  }

  Games get getDb {
    return db;
  }

  Games get getUserDb {
    return userDb;
  }

  Future<List<String>> scanExternal() async {
    List<String> phones = ["No phones found"];
    await Process.run('MTPAPI/MTPAPI.exe', ["LIST"]);
    String fileDir =
        "${Platform.environment['USERPROFILE']!}\\Documents\\WFSaves\\devices.txt";
    File file = File(fileDir);
    if (await file.exists()) {
      String contents = await file.readAsString();
      phones = contents.split("\n");
      phones.removeLast();
    }
    return phones;
  }
}
