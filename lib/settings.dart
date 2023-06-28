import 'package:flutter/material.dart';
import 'package:untitled2/station.dart';

import 'asset_manager.dart';

class Settings {
  factory Settings() {
    return instance;
  }

  Settings._();

  static final Settings _instance = Settings._();
  static Settings get instance => _instance;

  SettingsWidget get widget => const SettingsWidget();

  static const String defaultTheme = "default";
  static const String pinkTheme = "pink";

  static List<String> allThemes = [defaultTheme, pinkTheme];

  String theme = defaultTheme;

  void setTheme(String? t) {
    if (t == null) return;
    switch (t) {
      case defaultTheme:
        theme = defaultTheme;
      case pinkTheme:
        theme = pinkTheme;
    }

    updateTheme();
  }

  void updateTheme() {
    AssetManager().updateTheme(theme);
    Station().updateSegments();
  }
}

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({super.key});

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Card(
        child: ListView(
          shrinkWrap: true,
          children: [
            DropdownButton(
              value: Settings().theme,
              items: Settings.allThemes
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                    Settings().setTheme(value);
                  });
              },
            )
          ],
        ),
      ),
    );
  }
}
