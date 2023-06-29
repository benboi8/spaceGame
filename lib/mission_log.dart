import 'package:flutter/material.dart';
import 'main.dart';
import 'station.dart';

import 'color_manager.dart';

class MissionLog {
  factory MissionLog() {
    return instance;
  }

  MissionLog._();

  static final MissionLog _instance = MissionLog._();
  static get instance => _instance;

  int daysSurvived = 1;
  DateTime startDate = DateTime.now();

  Widget date(BuildContext context) {
    return Card(
      color: ColorManager.mainTextBackground,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            Expanded(
              child: Text(
                "${startDate.year} - ${startDate.month.toString().padLeft(2, "0")} - ${startDate.day.toString().padLeft(2, "0")}",
                style: TextStyle(
                  color: ColorManager.mainTextColor
                )
              )
            ),
            Expanded(
              child: TextButton(
                  onPressed: () {
                    if (tasks.isNotEmpty) {
                      showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                title: const Text("Tasks"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min, children: [
                                  for (Task task in tasks)
                                    Text(task.name)
                                ],
                                )
                            );
                          });
                    }
                    else {
                      showSnackBar(context: context, text: "No Tasks");
                    }
                  },
                  child: Text(
                      "Tasks",
                      style: TextStyle(
                        color: ColorManager.mainTextColor,
                      ))),
            ),
            Expanded(
              child: TextButton(
                onPressed: () {
                  nextDay();
                },
                child: Text(
                  "Complete Day",
                  style: TextStyle(
                    color: ColorManager.mainTextColor
                  ),
                )
              )
            )
          ],
        ),
      ));
  }

  void nextDay() {
    List<Task> tasksToRemove = [];
    daysSurvived += 1;
    startDate = DateTime(startDate.year, startDate.month, startDate.day + 1, 9);
    for (Task task in tasks) {
      bool complete = task.run();
      if (complete) {
        tasksToRemove.add(task);
      }
    }

    for (Task task in tasksToRemove) {
      tasks.remove(task);
    }

    for (Segment segment in Station().segments) {
      segment.nextDay();
    }
  }

  List<Task> tasks = [];

  void newTask(Task task) {
    tasks.add(task);
  }

  Task createSegment(String segment) {
    return Task("Create New $segment", Station().addNewSegmentName, segment, 1);
  }

  void end() {
    // end game
  }
}

class Task {
  Function function;
  String input;
  int days;
  String name;

  Task(this.name, this.function, this.input, this.days);

  bool get canRun => days == 0;

  bool run() {
    days -= 1;
    if (canRun) {
      function(input);
      return true;
    }
    return false;
  }
}
