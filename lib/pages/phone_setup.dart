import 'dart:io';
import 'loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:wf_transfer/theme.dart';
import 'package:provider/provider.dart';
import 'package:wf_transfer/display_notifier.dart';

class PhoneSetupPage extends StatefulWidget {
  const PhoneSetupPage({Key? key}) : super(key: key);

  @override
  State<PhoneSetupPage> createState() => _PhoneSetupPage();
}

class _PhoneSetupPage extends State<PhoneSetupPage> {
  List<String> _phonesList = [];
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    bool scannedForPhones =
        Provider.of<DisplayChangeNotifier>(context).phonesList.isNotEmpty;
    if (!scannedForPhones) {
      scanForPhones(context);
    } else {
      _phonesList = Provider.of<DisplayChangeNotifier>(context).phonesList;
    }
    List<Widget> column = [];
    if (_loading) {
      column.add(const LoadingWidget());
    } else {
      column.add(Text("Detected devices:", style: AppTheme.subtitleText));
      for (String phoneName in _phonesList) {
        column.add(createPhoneButton(phoneName, context));
      }
      column.add(
        Padding(
          padding: AppTheme.buttonPadding,
          child: TextButton(
            onPressed: () => {scanForPhones(context)},
            style: AppTheme.largeButtonStyleAlert,
            child: const Text("Rescan"),
          ),
        ),
      );
      column.add(Text("Selected device:", style: AppTheme.subtitleText));
      column.add(Text(Provider.of<DisplayChangeNotifier>(context).phoneName,
          style: AppTheme.subtitleText));
    }
    return Column(
      children: column,
    );
  }

  Widget createPhoneButton(String phoneName, context) {
    return Padding(
      padding: AppTheme.buttonPadding,
      child: TextButton(
        onPressed: () {
          Provider.of<DisplayChangeNotifier>(context, listen: false).setPhone =
              phoneName;
        },
        style: AppTheme.largeButtonStyle,
        child: Text(phoneName),
      ),
    );
  }

  void scanForPhones(context) {
    setState(() {
      _loading = true;
    });
    scanExternal().then((result) {
      setState(() {
        _loading = false;
        _phonesList = result;
        Provider.of<DisplayChangeNotifier>(context, listen: false).phonesList =
            result;
        // Check previously selected phone is still available
        String priorSelection =
            Provider.of<DisplayChangeNotifier>(context, listen: false)
                .phoneName;
        if (!result.contains(priorSelection) && priorSelection != "None") {
          Provider.of<DisplayChangeNotifier>(context, listen: false).setPhone =
              "None";
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: AppTheme.highlightBackgroundColor,
                actionsAlignment: MainAxisAlignment.spaceAround,
                actions: [
                  TextButton(
                    onPressed: () => {Navigator.of(context).pop()},
                    child: Text("Ok", style: AppTheme.titleText),
                  )
                ],
                title: Text(
                  "Previously selected device has been disconnected and unselected.",
                  style: AppTheme.normalText,
                ),
              );
            },
          );
        }
      });
    });
  }

  Future<List<String>> scanExternal() async {
    List<String> phones = ["No phones found"];
    ProcessResult result = await Process.run('MTPAPI/MTPAPI.exe', ["LIST"]);
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
