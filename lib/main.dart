import 'dart:io';
import 'adb.dart';
import 'package:flutter/material.dart';
import 'package:wf_transfer/display_notifier.dart';
import 'theme.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => DisplayChangeNotifier(context),
    builder: (context, child) {
      return const WFSpoon();
    },
  ));
  doWhenWindowReady(() {
    // double click behavior
    var initialSize = AppTheme.appSize;
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}

class WFSpoon extends StatelessWidget {
  const WFSpoon({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WF Transfer',
      theme: AppTheme.apptheme,
      home: const DisplayWrapper(title: 'WF Transfer'),
      color: AppTheme.backgroundColor,
    );
  }
}

class DisplayWrapper extends StatefulWidget {
  const DisplayWrapper({super.key, required this.title});
  final String title;
  @override
  State<DisplayWrapper> createState() => _DisplayWrapper();
}

class _DisplayWrapper extends State<DisplayWrapper> {
  late Widget currentWidget;
  bool _loading = true;
  bool _error = false;

  @override
  Widget build(BuildContext context) {
    if (_error) {
      currentWidget = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Error interpreting database. Reinstall recommended",
              style: AppTheme.titleText,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextButton(
              style: AppTheme.largeButtonStyleAlert,
              onPressed: () {
                setState(() {
                  _error = false;
                  _loading = true;
                });
              },
              child: Text("Try again", style: AppTheme.normalText),
            )
          ],
        ),
      );
    } else if (_loading) {
      load().then((success) => {
            setState(
              () {
                _loading = false;
                _error = !success;
              },
            )
          });
      currentWidget = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Loading database", style: AppTheme.titleText),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      );
    } else {
      currentWidget =
          Provider.of<DisplayChangeNotifier>(context, listen: true).top;
    }
    return MoveWindow(
      onDoubleTap: () => {},
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: Center(
          child: AppTheme.pageLayout(currentWidget, context),
        ),
      ),
    );
  }

  Future<bool> load() async {
    // Check for all files and folders where they need to be
    try {
      await Future.wait([
        // Check the WF folder exists
        checkFiles(),
        // simulate 3 second wait
        // Future.delayed(const Duration(seconds: 3)),
        // Try to read the database once
        Provider.of<DisplayChangeNotifier>(context, listen: false)
            .readGamesFromDisk(),
        // Try to scan for phones once
        Provider.of<DisplayChangeNotifier>(context).scanExternal(),
      ]);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future checkFiles() async {
    setUSBMode();
    // Check the WF folder and subfolders exists
    for (String folder in AppTheme.folders) {
      if (!Directory(folder).existsSync()) {
        if (folder.contains('\\img\\')) {
          // Transfer all the images from the install folder
          // TODO
        } else {
          Directory(folder).createSync(recursive: true);
        }
      }
    }
    for (String file in AppTheme.files) {
      if (!File(AppTheme.datafolder + file).existsSync()) {
        // Transfer that file from the install folder
        try {
          File("default\\$file").copySync(AppTheme.datafolder + file);
        } catch (e) {
          throw Exception("Error copying file $file");
        }
      }
    }
  }

  void setUSBMode() {
    //ADB().setUSBMode(true);
  }
}
