import 'dart:math';

import 'package:flutter/material.dart';

import 'asset_manager.dart';
import 'color_manager.dart';
import 'mission_log.dart';

class Station {
  factory Station() {
    return instance;
  }

  Station._() {
    generateSegments();
    updateSegments();
  }

  static final Station _instance = Station._();
  static get instance => _instance;

  StationWidget get widget => const StationWidget();

  int width = 5;
  int height = 5;
  bool hasSolar = false, hasFab = false;
  List<Segment> segments = [];

  List<int> getValidIndexes(index) {
    List<int> validIndexes = [];

    for (int i = 0; i < width * height; i++) {
      var segment = segments[i];
      if (segment.name != Segment.emptyName) {
        if (i % width + 1 != 0) {
          if (segments[i - 1].name == Segment.emptyName) {
            // x - 1
            validIndexes.add(i - 1);
          }
        }
        if (i % width != 0) {
          if (segments[i + 1].name == Segment.emptyName) {
            // x + 1
            validIndexes.add(i + 1);
          }
        }
        if (i > width) {
          if (segments[i - width].name == Segment.emptyName) {
            // y - 1
            validIndexes.add(i - width);
          }
        }
        if (i < width * height) {
          if (segments[i + width].name == Segment.emptyName) {
            // y + 1
            validIndexes.add(i + width);
          }
        }
      }
    }

    return validIndexes;
  }

  int get coreIndex => (width * height / 2).truncate();

  void generateSegments() {
    int length = width * height;

    hasSolar = false;
    hasFab = false;

    segments = [];

    for (int i = 0; i < length; i++) {
      if (i == coreIndex) {
        segments.add(Segment.core());
      } else {
        segments.add(Segment.empty());
      }
    }

    void setRandomSegment(int index) {
      if (!hasSolar) {
        segments[index] = Segment.solar();
        hasSolar = true;
      } else if (!hasFab) {
        segments[index] = Segment.fabricator();
        hasFab = true;
      }
    }

    for (int i = 0; i < length; i++) {
      if (i == coreIndex) continue;
      List<int> validIndexes = getValidIndexes(i);
      setRandomSegment(validIndexes[
          Random(DateTime.now().millisecondsSinceEpoch)
              .nextInt(validIndexes.length)]);
    }
  }

  void updateSegments() {
    for (int i = 0; i < segments.length; i++) {
      String validIndexes = "";
      var segment = segments[i];

      if (segment.name != Segment.emptyName) {
        if (i > width) {
          if (i % width + 1 != 0) {
            if (segments[i - 1].name != Segment.emptyName) {
              // x - 1
              validIndexes += "1";
            } else {
              validIndexes += "0";
            }
          }

          if (segments[i - width].name != Segment.emptyName) {
            // y - 1
            validIndexes += "1";
          } else {
            validIndexes += "0";
          }
        }

        if (i % width != 0) {
          if (segments[i + 1].name != Segment.emptyName) {
            // x + 1
            validIndexes += "1";
          } else {
            validIndexes += "0";
          }
        }

        if (i < width * height) {
          if (segments[i + width].name != Segment.emptyName) {
            // y + 1
            validIndexes += "1";
          } else {
            validIndexes += "0";
          }
        }
      }

      if (validIndexes == "") {
        segment.update(0);
      } else {
        segment.update(int.parse(validIndexes));
      }
    }
  }

  late int selectedSegment = coreIndex;

  static void newSegment(String segmentName) {}
}

class StationWidget extends StatefulWidget {
  const StationWidget({super.key});

  @override
  State<StationWidget> createState() => _StationWidgetState();
}

class _StationWidgetState extends State<StationWidget> {
  final Station station = Station();
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
          crossAxisCount: station.width),
      itemCount: station.segments.length,
      itemBuilder: (context, index) {
        return GestureDetector(
            onTap: () {
              setState(() {
                station.selectedSegment = index;
              });
            },
            child: Stack(
              children: [
                station.segments[index].widget,
                station.selectedSegment == index
                    ? AssetManager().selected()
                    : Container()
              ],
            ));
      },
    );
  }
}

class Segment {
  static const String emptyName = "Empty Space";
  static const String coreName = "Core";
  static const String solarName = "Solar Array";
  static const String fabricatorName = "Fabricator";

  static const List<String> buildableSegments = [
    solarName,
    fabricatorName,
  ];

  static Segment empty() => Segment._(const EmptySegment(), emptyName);
  static Segment core() => Segment._(const CoreWidget(), coreName);
  static Segment solar() => Segment._(const SolarWidget(), solarName);
  static Segment fabricator() =>
      Segment._(const FabricatorWidget(), fabricatorName);

  Widget widget;
  String name;
  int condition = 100;
  int power = 100;

  Segment._(this.widget, this.name);

  List<Widget> actions(BuildContext context) {
    switch (name) {
      case emptyName:
        break;
      case coreName:
        break;
      case solarName:
        break;
      case fabricatorName:
        return [
          TextButton(
              onPressed: () => showNewSegmentPage(context),
              child: Text("Make New Segment",
                  style: TextStyle(color: ColorManager.mainTextColor))),
        ];
    }

    return [];
  }

  Future<void> showNewSegmentPage(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("Select a segment"),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                for (String segment in buildableSegments)
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              MissionLog()
                                  .newTask(MissionLog().createSegment(segment));
                            },
                            child: Text(segment)),
                      ),
                    ],
                  )
              ]));
        });
  }

  void update(int connections) {
    switch (name) {
      case coreName:
        widget = AssetManager().getCore(connections: connections);
        break;
      case solarName:
        widget = AssetManager().getSolar(connections: connections);
        break;
      case fabricatorName:
        widget = AssetManager().getFabricator(connections: connections);
    }
  }
}

class EmptySegment extends StatefulWidget {
  const EmptySegment({super.key});

  @override
  State<EmptySegment> createState() => _EmptySegmentState();
}

class _EmptySegmentState extends State<EmptySegment> {
  @override
  Widget build(BuildContext context) {
    return AssetManager().getEmpty();
  }
}

class CoreWidget extends EmptySegment {
  const CoreWidget({super.key});

  @override
  State<CoreWidget> createState() => _CoreState();
}

class _CoreState extends State<CoreWidget> {
  @override
  Widget build(BuildContext context) {
    return AssetManager().getCore();
  }
}

class SolarWidget extends EmptySegment {
  const SolarWidget({super.key});

  @override
  State<SolarWidget> createState() => _SolarState();
}

class _SolarState extends State<SolarWidget> {
  @override
  Widget build(BuildContext context) {
    return AssetManager().getSolar();
  }
}

class FabricatorWidget extends EmptySegment {
  const FabricatorWidget({super.key});

  @override
  State<FabricatorWidget> createState() => _FabricatorState();
}

class _FabricatorState extends State<FabricatorWidget> {
  @override
  Widget build(BuildContext context) {
    return AssetManager().getFabricator();
  }
}
