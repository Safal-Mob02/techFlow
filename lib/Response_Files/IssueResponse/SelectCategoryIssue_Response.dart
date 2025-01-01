// To parse this JSON data, do
//
//     final selectCategoryIssueResponse = selectCategoryIssueResponseFromJson(jsonString);

import 'dart:convert';

SelectCategoryIssueResponse selectCategoryIssueResponseFromJson(String str) => SelectCategoryIssueResponse.fromJson(json.decode(str));

String selectCategoryIssueResponseToJson(SelectCategoryIssueResponse data) => json.encode(data.toJson());

class SelectCategoryIssueResponse {
  Settings settings;
  String message;
  List<String> fields;
  List<Datum> data;

  SelectCategoryIssueResponse({
    required this.settings,
    required this.message,
    required this.fields,
    required this.data,
  });

  factory SelectCategoryIssueResponse.fromJson(Map<String, dynamic> json) => SelectCategoryIssueResponse(
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

  Datum({
    required this.selectValue,
    required this.selectValueCode,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    selectValue: json["Select_Value"],
    selectValueCode: json["Select_Value_Code"],
  );

  Map<String, dynamic> toJson() => {
    "Select_Value": selectValue,
    "Select_Value_Code": selectValueCode,
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
