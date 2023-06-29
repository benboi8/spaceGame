import 'package:flutter/material.dart';
import 'settings.dart';
import 'color_manager.dart';
import 'mission_log.dart';
import 'station.dart';

void main() {
  runApp(const MyApp());
}

void showSnackBar(
    {required BuildContext context,
    required String text,
    int? duration,
    SnackBarAction? action}) {
  SnackBar snackBar = SnackBar(
    content: Text(text),
    duration: Duration(seconds: duration ?? 3),
    action: action,
  );

  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.red, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

ColorScheme getTheme(BuildContext context) {
  return Theme.of(context).colorScheme;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Station station = Station();

  @override
  Widget build(BuildContext context) {
    Segment segment = station.segments[station.selectedSegment];
    final Divider div = Divider(color: ColorManager.mainTextColor);

    Future.delayed(const Duration(milliseconds: 1), () {
      setState(() {});
    });

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute<void>(builder: (context) {
                return Settings().widget;
              }));
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: Column(
        children: [
          MissionLog().date(context),
          station.widget,
          ListView(
            shrinkWrap: true,
            children: [
              Card(
                  color: ColorManager.mainTextBackground,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            segment.name,
                            style: TextStyle(
                              color: ColorManager.mainTextColor,
                            ),
                          ),
                        ),
                        div,
                        segment.description(div),
                        Column(children: segment.actions(context))
                      ],
                    ),
                  ))
            ],
          )
        ],
      ),
    );
  }
}
