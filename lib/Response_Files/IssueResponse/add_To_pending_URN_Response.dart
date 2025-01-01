// To parse this JSON data, do
//
//     final addToPendingUrnResponse = addToPendingUrnResponseFromJson(jsonString);

import 'dart:convert';

AddToPendingUrnResponse addToPendingUrnResponseFromJson(String str) => AddToPendingUrnResponse.fromJson(json.decode(str));

String addToPendingUrnResponseToJson(AddToPendingUrnResponse data) => json.encode(data.toJson());

class AddToPendingUrnResponse {
  Settings settings;
  List<Datum> data;

  AddToPendingUrnResponse({
    required this.settings,
    required this.data,
  });

  factory AddToPendingUrnResponse.fromJson(Map<String, dynamic> json) => AddToPendingUrnResponse(
    settings: Settings.fromJson(json["settings"]),
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "settings": settings.toJson(),
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String urnNo;

  Datum({
    required this.urnNo,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    urnNo: json["urn_no"]??"",
  );

  Map<String, dynamic> toJson() => {
    "urn_no": urnNo,
  };
}

class Settings {
  String success;
  String? message;
  List<String> fields;

  Settings({
    required this.success,
     this.message,
    required this.fields,
  });

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
    success: json["success"],
    message: json["message"]??"",
    fields: List<String>.from(json["fields"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message??'',
    "fields": List<dynamic>.from(fields.map((x) => x)),
  };
}
