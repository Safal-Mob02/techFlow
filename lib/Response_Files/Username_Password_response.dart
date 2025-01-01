// To parse this JSON data, do
//
//     final loginUserPasswordResponse = loginUserPasswordResponseFromJson(jsonString);

import 'dart:convert';

LoginUserPasswordResponse loginUserPasswordResponseFromJson(String str) => LoginUserPasswordResponse.fromJson(json.decode(str));

String loginUserPasswordResponseToJson(LoginUserPasswordResponse data) => json.encode(data.toJson());

class LoginUserPasswordResponse {
  Settings settings;
  List<Datum> data;

  LoginUserPasswordResponse({
    required this.settings,
    required this.data,
  });

  factory LoginUserPasswordResponse.fromJson(Map<String, dynamic> json) => LoginUserPasswordResponse(
    settings: Settings.fromJson(json["settings"]),
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "settings": settings.toJson(),
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String urCode;
  String coCode;
  String username;

  Datum({
    required this.urCode,
    required this.coCode,
    required this.username,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    urCode: json["UR_CODE"],
    coCode: json["CO_CODE"],
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "UR_CODE": urCode,
    "CO_CODE": coCode,
    "username": username,
  };
}

class Settings {
  String success;
  String message;
  List<String> fields;

  Settings({
    required this.success,
    required this.message,
    required this.fields,
  });

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
    success: json["success"],
    message: json["message"],
    fields: List<String>.from(json["fields"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "fields": List<dynamic>.from(fields.map((x) => x)),
  };
}
