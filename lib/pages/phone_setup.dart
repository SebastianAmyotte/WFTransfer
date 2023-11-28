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
      column.add(Text(
        "Detected devices:",
        style: AppTheme.subtitleText,
        textAlign: TextAlign.center,
      ));
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
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
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

  void scanForPhones(context) async {
    setState(() {
      _loading = true;
    });
    Provider.of<DisplayChangeNotifier>(context, listen: false)
        .scanExternal()
        .then((result) {
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
              return AppTheme.dialog(
                context,
                "Device disconnected",
                "The previously selected device was not found. Please select a new device.",
              );
            },
          );
        }
      });
    });
  }
}
