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
  DateTime startDate = DateTime(2023, 6, 27);

  Widget date(BuildContext context) {
    return Card(
      color: ColorManager.mainTextBackground,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Center(
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
                  "${startDate.year} - ${startDate.month.toString().padLeft(2, "0")} - ${startDate.day.toString().padLeft(2, "0")}",
                  style: TextStyle(
                    color: ColorManager.mainTextColor,
                  ))),
        ),
      ));
  }

  void nextDay() {
    daysSurvived += 1;
    startDate = DateTime(
        startDate.year, startDate.month, startDate.day + daysSurvived, 9);
    for (Task task in tasks) {
      task.run();
    }
  }

  List<Task> tasks = [];

  void newTask(Task task) {
    tasks.add(task);
  }

  Task createSegment(String segment) {
    return Task("Create New $segment", Station.newSegment, segment, 1);
  }
}

class Task {
  Function function;
  String input;
  int days;
  String name;

  Task(this.name, this.function, this.input, this.days);

  bool get canRun => days == 0;

  void run() {
    if (canRun) {
      function(input);
    } else {
      days -= 1;
    }
  }
}
