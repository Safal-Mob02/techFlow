// To parse this JSON data, do
//
//     final attachmentListingDataResponse = attachmentListingDataResponseFromJson(jsonString);

import 'dart:convert';

AttachmentListingDataResponse attachmentListingDataResponseFromJson(String str) => AttachmentListingDataResponse.fromJson(json.decode(str));

String attachmentListingDataResponseToJson(AttachmentListingDataResponse data) => json.encode(data.toJson());

class AttachmentListingDataResponse {
  Settings settings;
  String message;
  List<Datum> data;

  AttachmentListingDataResponse({
    required this.settings,
    required this.message,
    required this.data,
  });

  factory AttachmentListingDataResponse.fromJson(Map<String, dynamic> json) => AttachmentListingDataResponse(
    settings: Settings.fromJson(json["settings"]),
    message: json["message"],
    data: List<Datum>.from(json["Data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "settings": settings.toJson(),
    "message": message,
    "Data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String attachment;

  Datum({
    required this.attachment,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    attachment: json["Attachment"],
  );

  Map<String, dynamic> toJson() => {
    "Attachment": attachment,
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
