import 'package:flutter/material.dart';
import 'package:wf_transfer/pages/phone_setup.dart';
import 'dart:io';
import 'display_notifier.dart';
import 'package:provider/provider.dart';

class AppTheme {
  // Backgrounds
  static var backgroundColor = const Color.fromARGB(255, 26, 28, 30);
  static var highlightBackgroundColor = const Color.fromARGB(255, 33, 36, 41);
  static var activeColor = const Color.fromARGB(255, 21, 60, 92);
  static var errorColor = const Color.fromARGB(255, 49, 27, 27);

  // Button
  static var buttonBackgroundColor = const Color.fromARGB(255, 61, 71, 81);
  static var buttonBackgroundAlertColor = const Color.fromARGB(255, 39, 90, 75);
  static var buttonTextColor = const Color.fromARGB(255, 216, 227, 248);
  static var smallButtonSize = const Size(150, 50);
  static var largeButtonSize = const Size(250, 50);
  static var buttonPadding = const EdgeInsets.all(8.0);
  static var largeButtonStyle = TextButton.styleFrom(
    foregroundColor: buttonTextColor,
    backgroundColor: buttonBackgroundColor,
    textStyle: const TextStyle(
      fontSize: 18,
    ),
    fixedSize: largeButtonSize,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  );
  static var largeButtonStyleAlert = largeButtonStyle.copyWith(
    backgroundColor:
        MaterialStateProperty.all(AppTheme.buttonBackgroundAlertColor),
  );
  static var largeButtonStyleDisabled = largeButtonStyle.copyWith(
    backgroundColor: MaterialStateProperty.all(errorColor),
  );
  static var smallButtonStyle = TextButton.styleFrom(
    foregroundColor: buttonTextColor,
    backgroundColor: buttonBackgroundColor,
    textStyle: const TextStyle(
      fontSize: 18,
    ),
    fixedSize: smallButtonSize,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  );
  static var smallButtonStyleDisabled = smallButtonStyle.copyWith(
    backgroundColor: MaterialStateProperty.all(errorColor),
  );

  // Text
  static var textColorHighlight = const Color.fromARGB(255, 216, 227, 248);
  static var textColorWhite = const Color.fromARGB(255, 255, 255, 255);
  static var titleText = TextStyle(
    fontSize: 32,
    color: textColorHighlight,
    fontWeight: FontWeight.bold,
  );
  static var subtitleText = TextStyle(
    fontSize: 26,
    color: textColorHighlight,
    fontWeight: FontWeight.bold,
  );
  static var normalText = TextStyle(
    fontSize: 18,
    color: textColorWhite,
    fontWeight: FontWeight.normal,
  );
  static var subText = TextStyle(
    fontSize: 14,
    color: textColorWhite,
    fontWeight: FontWeight.normal,
  );

  // Overall app
  static var appSize = const Size(400, 700);
  static var apptheme = ThemeData(
    canvasColor: backgroundColor,
  );

  static var datafolder =
      "${Platform.environment['USERPROFILE']!}\\Documents\\WFSaves\\";
  static var imgfolder = "${datafolder}img\\";
  static var savesFolder = "${datafolder}saves\\";
  static List<String> folders = [datafolder, imgfolder, savesFolder];

  static var dbName = "db.csv";
  static var userDbName = "user_db.csv";
  static var userSavePaths = "user_game_locations.csv";
  static List<String> files = [dbName, userDbName, userSavePaths];

  static Widget highlightedWidget(Widget content, context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: highlightBackgroundColor),
      child: content,
    );
  }

  static Image diskImage(String filename) {
    try {
      File file = File("${AppTheme.datafolder}img\\$filename");
      if (!file.existsSync()) {
        throw Exception("File does not exist");
      }
      FileImage fileImage = FileImage(file);
      return Image(
          image: fileImage, fit: BoxFit.fitHeight, height: 50, width: 50);
    } catch (e) {
      return const Image(
          image: AssetImage("assets/placeholder.png"),
          fit: BoxFit.fitHeight,
          height: 50,
          width: 50);
    }
  }

  static Widget pageLayout(Widget content, context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: SizedBox(
              width: 300,
              child: TextButton(
                onPressed: () {
                  while (!onMainPage(context)) {
                    Provider.of<DisplayChangeNotifier>(context, listen: false)
                        .pop();
                  }
                },
                style: largeButtonStyle.copyWith(
                  backgroundColor:
                      MaterialStateProperty.all(highlightBackgroundColor),
                ),
                child: Text(
                  'WF Transfer',
                  style: titleText,
                ),
              ),
            ),
          ),
          // To put the content in the middle of the screen
          Expanded(
            child: AnimatedSwitcher(
              // zoom in/out animation
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },
              duration: const Duration(milliseconds: 100),
              child: content,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: SizedBox(
              width: 300,
              child: TextButton(
                style: largeButtonStyle.copyWith(
                  backgroundColor:
                      MaterialStateProperty.all(highlightBackgroundColor),
                ),
                onPressed: () {
                  if (!onPhoneSetupPage(context)) {
                    Provider.of<DisplayChangeNotifier>(context, listen: false)
                        .push(const PhoneSetupPage());
                  }
                },
                child: SizedBox(
                  width: 300,
                  child: Text(
                    "Selected device:\n${Provider.of<DisplayChangeNotifier>(context).phoneName}",
                    style: AppTheme.normalText,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: highlightedWidget(
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: TextButton(
                        onPressed: () {
                          quit(context);
                        },
                        style: smallButtonStyle,
                        child: const Text('Quit'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: TextButton(
                        onPressed: () {
                          if (!onMainPage(context)) {
                            Provider.of<DisplayChangeNotifier>(context,
                                    listen: false)
                                .pop();
                          }
                        },
                        style: onMainPage(context)
                            ? smallButtonStyleDisabled
                            : smallButtonStyle,
                        child: const Text('Back'),
                      ),
                    ),
                  ],
                ),
                context),
          )
        ],
      ),
    );
  }

  void backButton(context) {
    Provider.of<DisplayChangeNotifier>(context, listen: false).pop();
  }

  static bool onMainPage(context) {
    return Provider.of<DisplayChangeNotifier>(context, listen: false)
            .displayStack
            .length ==
        1;
  }

  static bool onPhoneSetupPage(context) {
    return Provider.of<DisplayChangeNotifier>(context, listen: false)
            .displayStack
            .last
            .toString() ==
        "PhoneSetupPage";
  }

  static bool phoneSelected(context) {
    return Provider.of<DisplayChangeNotifier>(context, listen: false)
            .phoneName !=
        "None";
  }

  static void quit(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.highlightBackgroundColor,
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: [
            TextButton(
              onPressed: () => {
                exit(0),
              },
              child: Text("Quit", style: AppTheme.normalText),
            ),
            TextButton(
              child: Text("Go back", style: AppTheme.normalText),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
          title: Text(
            "Are you sure you want to quit?",
            style: AppTheme.normalText,
          ),
        );
      },
    );
  }

  static AlertDialog dialog(context, String title, String message) {
    return AlertDialog(
      backgroundColor: AppTheme.backgroundColor,
      title: Text(
        title,
        style: AppTheme.titleText,
      ),
      content: Text(
        message,
        style: AppTheme.normalText,
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("OK", style: AppTheme.normalText))
      ],
    );
  }

  static String phoneDataDirectory() {
    return "\\Internal storage\\Android\\data\\";
  }
}
