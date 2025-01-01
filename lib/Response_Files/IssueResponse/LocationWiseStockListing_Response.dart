// To parse this JSON data, do
//
//     final locationWiseStockListingResponse = locationWiseStockListingResponseFromJson(jsonString);

import 'dart:convert';

LocationWiseStockListingResponse locationWiseStockListingResponseFromJson(String str) => LocationWiseStockListingResponse.fromJson(json.decode(str));

String locationWiseStockListingResponseToJson(LocationWiseStockListingResponse data) => json.encode(data.toJson());

class LocationWiseStockListingResponse {
  Settings settings;
  String message;
  List<String> fields;
  List<Datum> data;

  LocationWiseStockListingResponse({
    required this.settings,
    required this.message,
    required this.fields,
    required this.data,
  });

  factory LocationWiseStockListingResponse.fromJson(Map<String, dynamic> json) => LocationWiseStockListingResponse(
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
  String soNo;
  var qty;
  var location;

  Datum({
    required this.soNo,
    required this.qty,
    required this.location,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    soNo: json["SO No"]??"",
    qty: json["Qty"],
    location:json["Location"]!,
  );

  Map<String, dynamic> toJson() => {
    "SO No": soNo??"",
    "Qty": qty,
    "Location":location,
  };
}

enum Location {
  BOUGHT_OUT_STORE,
  FABRICATION_AREA,
  FINISHING_AREA,
  PAINT_SHOP,
  PLASMA_LASER,
  PRODUCTION,
  STRUCTURE_AREA,
  WELDING_AREA
}

final locationValues = EnumValues({
  "BOUGHT OUT STORE": Location.BOUGHT_OUT_STORE,
  "FABRICATION AREA": Location.FABRICATION_AREA,
  "FINISHING AREA": Location.FINISHING_AREA,
  "PAINT SHOP": Location.PAINT_SHOP,
  "PLASMA /LASER": Location.PLASMA_LASER,
  "PRODUCTION": Location.PRODUCTION,
  "STRUCTURE AREA": Location.STRUCTURE_AREA,
  "WELDING AREA": Location.WELDING_AREA
});

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

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
