// To parse this JSON data, do
//
//     final locationSelectionResponse = locationSelectionResponseFromJson(jsonString);

import 'dart:convert';

LocationSelectionResponse locationSelectionResponseFromJson(String str) => LocationSelectionResponse.fromJson(json.decode(str));

String locationSelectionResponseToJson(LocationSelectionResponse data) => json.encode(data.toJson());

class LocationSelectionResponse {
  Settings settings;
  String message;
  List<String> fields;
  List<Datum> data;

  LocationSelectionResponse({
    required this.settings,
    required this.message,
    required this.fields,
    required this.data,
  });

  factory LocationSelectionResponse.fromJson(Map<String, dynamic> json) => LocationSelectionResponse(
    settings: Settings.fromJson(json["settings"]),
    message: json["message"],
    fields: List<String>.from(json["fields"].map((x) => x)),
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "settings": settings.toJson(),
    "message": message,
    "fields": List<dynamic>.from(fields.map((x) => x)),
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String selectValue;
  String selectValueCode;
  var stock;

  Datum({
    required this.selectValue,
    required this.selectValueCode,
    required this.stock,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    selectValue: json["Select_Value"],
    selectValueCode: json["Select_Value_Code"],
    stock: json["Stock"],
  );

  Map<String, dynamic> toJson() => {
    "Select_Value": selectValue,
    "Select_Value_Code": selectValueCode,
    "Stock": stock,
  };
}

class Settings {
  String success;

  Settings({
    required this.success,
  });

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
  };
}
