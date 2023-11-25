import 'package:flutter/material.dart';
import 'package:wf_transfer/pages/main_menu.dart';
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

  Future<String> readGamesFromDisk() async {
    await db.readGamesFromDisk();
    await userDb.readGamesFromDisk();
    return "";
  }

  Games get getDb {
    return db;
  }

  Games get getUserDb {
    return userDb;
  }
}
