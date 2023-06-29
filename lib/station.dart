import 'dart:math';

import 'package:flutter/material.dart';

import 'asset_manager.dart';
import 'color_manager.dart';
import 'mission_log.dart';
import 'segment_data.dart';

class Station {
  factory Station() {
    return instance;
  }

  Station._() {
    generateSegments();
    updateSegments();
  }

  static final Station _instance = Station._();
  static Station get instance => _instance;

  StationWidget get widget => const StationWidget();

  int width = 5;
  int height = 5;
  bool hasSolar = false, hasFab = false;
  List<Segment> segments = [];

  int power = 100;
  int condition = 100;

  void changePower(int p) {
    power = max(min(p, 100), 0);

    if (power == 0) {
      MissionLog().end();
    }
  }

  bool isOnLeftWall(int index) => index % width != 0;
  bool isOnRightWall(int index) => index % width != width - 1;
  bool isOnTopWall(int index) => index >= width;
  bool isOnBottomWall(int index) => index < width * (height -1);

  List<int> getValidIndexes(index) {
    List<int> validIndexes = [];

    for (int i = 0; i < width * height; i++) {
      var segment = segments[i];
      if (segment.name != Segment.emptyName) {
        if (isOnLeftWall(i)) {
          if (segments[i - 1].name == Segment.emptyName) {
            // x - 1
            validIndexes.add(i - 1);
          }
        }
        if (isOnRightWall(i)) {
          if (segments[i + 1].name == Segment.emptyName) {
            // x + 1
            validIndexes.add(i + 1);
          }
        }
        if (isOnTopWall(i)) {
          if (segments[i - width].name == Segment.emptyName) {
            // y - 1
            validIndexes.add(i - width);
          }
        }
        if (isOnBottomWall(i)) {
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
        if (isOnLeftWall(i)) {
          if (segments[i - 1].name != Segment.emptyName) {
            // x - 1
            validIndexes += "1";
          } else {
            validIndexes += "0";
          }
        } else {
          validIndexes += "0";
        }

        if (isOnTopWall(i)) {
          if (segments[i - width].name != Segment.emptyName) {
            // y - 1
            validIndexes += "1";
          } else {
            validIndexes += "0";
          }
        } else {
          validIndexes += "0";
        }

        if (isOnRightWall(i)) {
          if (segments[i + 1].name != Segment.emptyName) {
            // x + 1
            validIndexes += "1";
          } else {
            validIndexes += "0";
          }
        } else {
          validIndexes += "0";
        }

        if (isOnBottomWall(i)) {
          if (segments[i + width].name != Segment.emptyName) {
            // y + 1
            validIndexes += "1";
          } else {
            validIndexes += "0";
          }
        } else {
          validIndexes += "0";
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

  bool creatingNewSegment = false;
  Set<int> newSegmentIndexes = {};
  List<String> newSegmentName = [];

  void addNewSegmentName(String segmentName) {
    newSegmentName.add(segmentName);
  }

  void checkForNewSegments() {
    if (newSegmentName.isNotEmpty) {
      newSegment(newSegmentName[0]);
    }
  }

  void newSegment(String segmentName) {
    // get all valid indexes
    Set<int> validIndexes = {};
    for (int index = 0; index < segments.length; index ++) {
      validIndexes.addAll(getValidIndexes(index));
    }
    // show this to the user
    creatingNewSegment = true;
    newSegmentIndexes = validIndexes;
    // get the index they click on

    // place the segment there
  }

  void addSegment(int index) {
    if (newSegmentIndexes.contains(index)) {
      creatingNewSegment = false;
      segments[index] = Segment.create(newSegmentName[0]);
      updateSegments();
      newSegmentName.removeAt(0);
    }

    if (newSegmentName.isNotEmpty) {
      newSegment(newSegmentName[0]);
    }
  }
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
        Future.delayed(const Duration(milliseconds: 5), () {setState(() {});});
        station.checkForNewSegments();

        bool showSegmentOutline = false;
        if (station.creatingNewSegment) {
          showSegmentOutline = station.newSegmentIndexes.contains(index);
        }

        return GestureDetector(
            onTap: () {
              setState(() {
                if (!station.creatingNewSegment) {
                  station.selectedSegment = index;
                } else {
                  station.addSegment(index);
                }
              });
            },
            child: Stack(
              children: [
                AssetManager().background(index),
                station.segments[index].widget,
                showSegmentOutline ? AssetManager().selected() : Container(),
                !station.creatingNewSegment ? station.selectedSegment == index ? AssetManager().selected() : Container() : Container()
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
  static const String corridorName = "Corridor";
  static const String researchName = "Research";

  static const List<String> buildableSegments = [
    solarName,
    fabricatorName,
    corridorName,
    researchName
  ];

  static Segment create(String name) {
    switch (name) {
      case solarName:
        return solar();
      case fabricatorName:
        return fabricator();
      case corridorName:
        return corridor();
      case researchName:
        return research();
      default:
        return empty();
    }
  }

  static Segment empty() => Segment._(AssetManager().getEmpty(), emptyName);
  static Segment core() => Segment._(AssetManager().getCore(), coreName);
  static Segment solar() => Segment._(AssetManager().getSolar(), solarName);
  static Segment corridor() => Segment._(AssetManager().getCorridor(), corridorName);
  static Segment fabricator() => Segment._(AssetManager().getFabricator(), fabricatorName);
  static Segment research() => Segment._(AssetManager().getResearch(), researchName);

  Widget widget;
  String name;

  Widget description(Divider div) {
    List<Widget> list = [];

    switch (name) {
      case emptyName:
        list.add(Align(alignment: Alignment.bottomLeft, child: Text(EmptyData.description, style: TextStyle(color: ColorManager.mainTextColor)),));
      case coreName:
        list.add(Align(alignment: Alignment.bottomLeft, child: Text(CoreData.description, style: TextStyle(color: ColorManager.mainTextColor)),));
      case solarName:
        list.add(Align(alignment: Alignment.bottomLeft, child: Text(SolarData.description, style: TextStyle(color: ColorManager.mainTextColor)),));
      case fabricatorName:
        list.add(Align(alignment: Alignment.bottomLeft, child: Text(FabricatorData.description, style: TextStyle(color: ColorManager.mainTextColor)),));
        list.add(div);
      case corridorName:
        list.add(Align(alignment: Alignment.bottomLeft, child: Text(CorridorData.description, style: TextStyle(color: ColorManager.mainTextColor)),));
    }

    return Column(
      children: list
    );
  }

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
      case emptyName:
        widget = AssetManager().getEmpty();
      case coreName:
        widget = AssetManager().getCore(connections: connections);
        break;
      case solarName:
        widget = AssetManager().getSolar(connections: connections);
        break;
      case fabricatorName:
        widget = AssetManager().getFabricator(connections: connections);
      case corridorName:
        widget = AssetManager().getCorridor(connections: connections);
      case researchName:
        widget = AssetManager().getResearch(connections: connections);
    }
  }

  void changePower(p) {
    Station().changePower(p);
  }

  void nextDay() {
    changePower(-1);

    if (name == solarName) {
      Station().changePower(SolarData.powerLimit);
    }

    if (name == fabricatorName) {
      Station().changePower(FabricatorData.powerDraw);
    }

    if (name == researchName) {
      Station().changePower(ResearchData.powerDraw);
    }
  }
}
