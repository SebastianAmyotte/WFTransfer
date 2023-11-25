import 'package:flutter/material.dart';
import 'package:wf_transfer/pages/phone_setup.dart';
import 'package:wf_transfer/theme.dart';
import 'help.dart';
import 'package:provider/provider.dart';
import 'package:wf_transfer/display_notifier.dart';
import 'mobile_to_desktop.dart';

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    return Column(
      children: [
        Padding(
          padding: AppTheme.buttonPadding,
          child: TextButton(
            onPressed: () {},
            style: AppTheme.largeButtonStyle,
            child: const Text('Transfer to Mobile'),
          ),
        ),
        Padding(
          padding: AppTheme.buttonPadding,
          child: TextButton(
            onPressed: () {
              Provider.of<DisplayChangeNotifier>(context, listen: false)
                  .push(const MobileToDesktop());
            },
            style: AppTheme.largeButtonStyle,
            child: const Text('Transfer to Desktop'),
          ),
        ),
        Padding(
          padding: AppTheme.buttonPadding,
          child: TextButton(
            onPressed: () {},
            style: AppTheme.largeButtonStyle,
            child: const Text('Edit games database'),
          ),
        ),
        Padding(
          padding: AppTheme.buttonPadding,
          child: TextButton(
            onPressed: () {
              Provider.of<DisplayChangeNotifier>(context, listen: false)
                  .push(const PhoneSetupPage());
            },
            style: selectPhoneColor(context),
            child: const Text('Select device'),
          ),
        ),
        Padding(
          padding: AppTheme.buttonPadding,
          child: TextButton(
            onPressed: () {
              Provider.of<DisplayChangeNotifier>(context, listen: false)
                  .push(const HelpPage());
            },
            style: AppTheme.largeButtonStyle,
            child: const Text('Help'),
          ),
        ),
      ],
    );
  }

  ButtonStyle selectPhoneColor(context) {
    return phoneSelected(context)
        ? AppTheme.largeButtonStyle
        : AppTheme.largeButtonStyleAlert;
  }

  bool phoneSelected(context) {
    return Provider.of<DisplayChangeNotifier>(context, listen: false)
            .phoneName !=
        "None";
  }
}
