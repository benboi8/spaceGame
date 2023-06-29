import 'dart:math';

import 'package:flutter/material.dart';

class AssetManager {
  factory AssetManager() {
    return instance;
  }

  AssetManager._();

  static final AssetManager _instance = AssetManager._();
  static get instance => _instance;

  static String _theme = "default";
  static String _assetsPath = "assets/$_theme";
  static String _selectedURI = "$_assetsPath/selected.png";

  void updateTheme(String theme) {
    _theme = theme;
    _assetsPath = "assets/$_theme";
    _selectedURI = "$_assetsPath/selected.png";
  }

  static String _coreURI(int index) {
    return "$_assetsPath/core/$index.png";
  }

  static String _solarURI(int index) {
    return "$_assetsPath/solar/$index.png";
  }

  static String _fabricatorURI(int index) {
    return "$_assetsPath/fabricator/$index.png";
  }

  static String _emptyURI(int index) {
    return "$_assetsPath/empty/$index.png";
  }

  static String _corridorURI(int index) {
    return "$_assetsPath/corridor/$index.png";
  }

  static String _researchURI(int index) {
    return "$_assetsPath/research/$index.png";
  }

  // TODO add animations for tiles or random tiles being selected like multiple empty tiles
  // Only show connector pieces in each tile if it is connected or show a different connector if it is connected

  Widget selected() {
    return _getUri(_selectedURI);
  }

  int getDirection(int connections) {
    // 1111 0
    if (connections == 1111) {
      return 0;
    }
    // 1110 1
    if (connections == 1110) {
      return 1;
    }
    // 1101 2
    if (connections == 1101) {
      return 2;
    }
    // 1011 3
    if (connections == 1011) {
      return 3;
    }
    // 0111 4
    if (connections == 0111) {
      return 4;
    }
    // 0101 5
    if (connections == 0101) {
      return 5;
    }
    // 1010 6
    if (connections == 1010) {
      return 6;
    }
    // 0100 7
    if (connections == 0100) {
      return 7;
    }
    // 1000 8
    if (connections == 1000) {
      return 8;
    }
    // 0001 9
    if (connections == 0001) {
      return 9;
    }
    // 0010 10
    if (connections == 0010) {
      return 10;
    }
    // 0110 11
    if (connections == 0110) {
      return 11;
    }
    // 1100 12
    if (connections == 1100) {
      return 12;
    }
    // 1001 13
    if (connections == 1001) {
      return 13;
    }
    // 0011 14
    if (connections == 0011) {
      return 14;
    }

    return 0;
  }

  Widget getEmpty() {
    return _getUri(_emptyURI(0));
  }

  Widget background(int index) {
    return _getUri(_emptyURI(Random(index).nextInt(3)));
  }

  Widget getCore({int? connections}) {
    return _getUri(_coreURI(getDirection(connections ?? 0)));
  }

  Widget getSolar({int? connections}) {
    return _getUri(_solarURI(getDirection(connections ?? 0)));
  }

  Widget getFabricator({int? connections}) {
    return _getUri(_fabricatorURI(getDirection(connections ?? 0)));
  }

  Widget getCorridor({int? connections}) {
    return _getUri(_corridorURI(getDirection(connections ?? 0)));
  }

  Widget getResearch({int? connections}) {
    return _getUri(_researchURI(getDirection(connections ?? 0)));
  }

  Widget _getUri(String uri) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
      image: AssetImage(uri),
    )));
  }
}
