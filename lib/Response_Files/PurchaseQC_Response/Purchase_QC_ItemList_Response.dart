// To parse this JSON data, do
//
//     final purchaseQcItemListResponse = purchaseQcItemListResponseFromJson(jsonString);

import 'dart:convert';

PurchaseQcItemListResponse purchaseQcItemListResponseFromJson(String str) => PurchaseQcItemListResponse.fromJson(json.decode(str));

String purchaseQcItemListResponseToJson(PurchaseQcItemListResponse data) => json.encode(data.toJson());

class PurchaseQcItemListResponse {
  Settings settings;
  List<Datum> data;

  PurchaseQcItemListResponse({
    required this.settings,
    required this.data,
  });

  factory PurchaseQcItemListResponse.fromJson(Map<String, dynamic> json) => PurchaseQcItemListResponse(
    settings: Settings.fromJson(json["settings"]),
    data: List<Datum>.from(json["Data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "settings": settings.toJson(),
    "Data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int index;
  String status;
  var qty;
  String reason;
  String SR_No;

  Datum({
    required this.index,
    required this.status,
    required this.qty,
    required this.reason,
    required this.SR_No,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    index: json["Index"],
    status: json["Status"],
    qty: json["Qty"],
    reason: json["Reason"],
    SR_No: json["SR_No"],
  );

  Map<String, dynamic> toJson() => {
    "Index": index,
    "Status": status,
    "Qty": qty,
    "Reason": reason,
    "Reason": SR_No,
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
