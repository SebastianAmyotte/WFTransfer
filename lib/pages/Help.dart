import 'package:flutter/material.dart';
import 'package:wf_transfer/theme.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Need help?",
          style: AppTheme.titleText,
        ),
        Text(
          "Help page coming soon",
          style: AppTheme.titleText,
        ),
      ],
    );
  }
}
