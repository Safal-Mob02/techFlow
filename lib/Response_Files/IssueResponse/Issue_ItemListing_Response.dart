// To parse this JSON data, do
//
//     final issueItemListingResponse = issueItemListingResponseFromJson(jsonString);

import 'dart:convert';

IssueItemListingResponse issueItemListingResponseFromJson(String str) => IssueItemListingResponse.fromJson(json.decode(str));

String issueItemListingResponseToJson(IssueItemListingResponse data) => json.encode(data.toJson());

class IssueItemListingResponse {
  Settings settings;
  List<Datum> data;

  IssueItemListingResponse({
    required this.settings,
    required this.data,
  });

  factory IssueItemListingResponse.fromJson(Map<String, dynamic> json) => IssueItemListingResponse(
    settings: Settings.fromJson(json["settings"]),
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "settings": settings.toJson(),
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int srNo;
  String itemName;
  String itCode;
  var soNo;
  String productionItem;
  var process;
  var unit;
  var unitCode;
  String qty;
  String rate;
  var issueValue;
  var location;
  var locationCode;
  String stock;
  String hsnNo;
  var remarks;
  var fromUrnNo;
  String hsnCodeManual;
  String eWayBillItem;
  var issuingLocation;

  Datum({
    required this.srNo,
    required this.itemName,
    required this.itCode,
    required this.soNo,
    required this.productionItem,
    required this.process,
    required this.unit,
    required this.unitCode,
    required this.qty,
    required this.rate,
    required this.issueValue,
    required this.location,
    required this.locationCode,
    required this.stock,
    required this.hsnNo,
    required this.remarks,
    required this.fromUrnNo,
    required this.hsnCodeManual,
    required this.eWayBillItem,
    required this.issuingLocation,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    srNo: json["Sr No"],
    itemName: json["Item Name"],
    itCode: json["IT_CODE"],
    soNo: json["SO No"]!,
    productionItem: json["Production Item"],
    process: json["Process"]!,
    unit: json["Unit"],
    unitCode: json["Unit Code"]!,
    qty: json["Qty"],
    rate: json["Rate"],
    issueValue: json["Issue Value"],
    location: json["Location"]!,
    locationCode: json["Location_Code"]!,
    stock: json["Stock"],
    hsnNo: json["HSN No"],
    remarks: json["Remarks"],
    fromUrnNo: json["From_URN_No"]!,
    hsnCodeManual: json["HSN Code Manual"],
    eWayBillItem: json["E-Way_Bill_Item"],
    issuingLocation:json["Issuing Location"]!,
  );

  Map<String, dynamic> toJson() => {
    "Sr No": srNo,
    "Item Name": itemName,
    "IT_CODE": itCode,
    "SO No": soNo,
    "Production Item": productionItem,
    "Process": process,
    "Unit": unit,
    "Unit Code":unitCode,
    "Qty": qty,
    "Rate": rate,
    "Issue Value": issueValue,
    "Location": location,
    "Location_Code": locationCode,
    "Stock": stock,
    "HSN No": hsnNo,
    "Remarks": remarks,
    "From_URN_No": fromUrnNo,
    "HSN Code Manual": hsnCodeManual,
    "E-Way_Bill_Item": eWayBillItem,
    "Issuing Location": issuingLocation,
  };
}

enum FromUrnNo {
  EMPTY,
  PDO05_A005058
}

final fromUrnNoValues = EnumValues({
  "": FromUrnNo.EMPTY,
  "PDO05A005058": FromUrnNo.PDO05_A005058
});

enum Location {
  BOUGHT_OUT_STORE,
  PLASMA_LASER
}

final locationValues = EnumValues({
  "BOUGHT OUT STORE": Location.BOUGHT_OUT_STORE,
  "PLASMA /LASER": Location.PLASMA_LASER
});

enum LocationCode {
  L0100_A000005,
  L0100_A000008
}

final locationCodeValues = EnumValues({
  "L0100A000005": LocationCode.L0100_A000005,
  "L0100A000008": LocationCode.L0100_A000008
});

enum Process {
  EMPTY,
  STRUCTURE_CUTTING
}

final processValues = EnumValues({
  "": Process.EMPTY,
  "Structure Cutting": Process.STRUCTURE_CUTTING
});

enum Remarks {
  DEMO,
  EMPTY
}

final remarksValues = EnumValues({
  "Demo": Remarks.DEMO,
  "": Remarks.EMPTY
});

enum SoNo {
  S10654,
  S11067,
  S11108
}

final soNoValues = EnumValues({
  "S10654": SoNo.S10654,
  "S11067": SoNo.S11067,
  "S11108": SoNo.S11108
});

enum Unit {
  EMPTY,
  KGS,
  MTR,
  NOS
}

final unitValues = EnumValues({
  "": Unit.EMPTY,
  "Kgs": Unit.KGS,
  "Mtr": Unit.MTR,
  "Nos": Unit.NOS
});

enum UnitCode {
  EMPTY,
  M0100_A000001,
  M0100_A000002,
  M0100_A000003
}

final unitCodeValues = EnumValues({
  "": UnitCode.EMPTY,
  "M0100A000001": UnitCode.M0100_A000001,
  "M0100A000002": UnitCode.M0100_A000002,
  "M0100A000003": UnitCode.M0100_A000003
});

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

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
