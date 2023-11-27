import 'package:flutter/material.dart';
import 'package:wf_transfer/pages/phone_setup.dart';
import 'package:wf_transfer/pages/update_database.dart';
import 'package:wf_transfer/theme.dart';
import 'help.dart';
import 'package:provider/provider.dart';
import 'package:wf_transfer/display_notifier.dart';
import 'game_select.dart';

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    return ListView(
      children: [
        Padding(
          padding: AppTheme.buttonPadding,
          child: TextButton(
            onPressed: () {
              Provider.of<DisplayChangeNotifier>(context, listen: false)
                  .push(const GameSelect());
            },
            style: AppTheme.largeButtonStyle,
            child: const Text('Games'),
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
        Padding(
          padding: AppTheme.buttonPadding,
          child: TextButton(
            onPressed: () {
              Provider.of<DisplayChangeNotifier>(context, listen: false)
                  .push(const UpdateDatabase());
            },
            style: AppTheme.largeButtonStyle,
            child: const Text('Update database'),
          ),
        ),
      ],
    );
  }

  ButtonStyle selectPhoneColor(context) {
    return AppTheme.phoneSelected(context)
        ? AppTheme.largeButtonStyle
        : AppTheme.largeButtonStyleAlert;
  }
}
