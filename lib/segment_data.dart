import 'station.dart';

class EmptyData {
  static const String description ="Just empty space.";
}

class CoreData {
  static String description ="The core of your station.\nPower: ${Station().power}";
}

class SolarData {
  static const String description ="Solar panels produce power at ${SolarData.powerLimit} units per day.";

  static const int powerLimit = 5 ;
}

class FabricatorData {
  static const String description = "Fabricators allow you to make a new segment each day." ;

  static const int powerDraw = 5;
  static const int maxNumAllowed = 2;
}

class CorridorData {
  static const String description = "Corridors let your crew move from place to place easily." ;
}

class ResearchData {
  static const String description =  "Research stations allow you to discover new segments to build.";

  static const int researchLimit = 1;
  static const int powerDraw = 5;
  static const int maxNumAllowed = 1;
}
