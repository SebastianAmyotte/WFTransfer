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

  @override
  Widget build(BuildContext context) {
    currentWidget =
        Provider.of<DisplayChangeNotifier>(context, listen: true).top;
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
}
