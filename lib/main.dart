import 'package:flutter/material.dart';
import 'color_manager.dart';
import 'mission_log.dart';
import 'station.dart';

void main() {
  runApp(const MyApp());
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

    Future.delayed(const Duration(milliseconds: 1), () {setState(() {});});

    return Scaffold(
      appBar: AppBar(),
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
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "Condition: ${segment.condition}",
                            style: TextStyle(
                              color: ColorManager.mainTextColor,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "Power: ${segment.power}",
                            style: TextStyle(
                              color: ColorManager.mainTextColor,
                            ),
                          ),
                        ),
                        div,
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
