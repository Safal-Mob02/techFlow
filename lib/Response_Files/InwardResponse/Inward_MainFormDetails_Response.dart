// To parse this JSON data, do
//
//     final inwardMainFormDetailsResponse = inwardMainFormDetailsResponseFromJson(jsonString);

import 'dart:convert';

InwardMainFormDetailsResponse inwardMainFormDetailsResponseFromJson(String str) => InwardMainFormDetailsResponse.fromJson(json.decode(str));

String inwardMainFormDetailsResponseToJson(InwardMainFormDetailsResponse data) => json.encode(data.toJson());

class InwardMainFormDetailsResponse {
  Settings settings;
  List<Datum> data;

  InwardMainFormDetailsResponse({
    required this.settings,
    required this.data,
  });

  factory InwardMainFormDetailsResponse.fromJson(Map<String, dynamic> json) => InwardMainFormDetailsResponse(
    settings: Settings.fromJson(json["settings"]),
    data: List<Datum>.from(json["Data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "settings": settings.toJson(),
    "Data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String categoryCode;
  DateTime inwardDate;
  String supplierCode;
  String gstNo;
  DateTime challanDate;
  String billNo;
  DateTime billDate;
  String challanNo;
  String ewayBillNo;
  DateTime ewayBillDate;
  var paymentDays;
  String inwardNo;
  String currencyCode;
  var exchangeRate;
  String preparedBy;
  String approvedBy;
  String category;
  String supplier;
  String currency;

  Datum({
    required this.categoryCode,
    required this.inwardDate,
    required this.supplierCode,
    required this.gstNo,
    required this.challanDate,
    required this.billNo,
    required this.billDate,
    required this.challanNo,
    required this.ewayBillNo,
    required this.ewayBillDate,
    required this.paymentDays,
    required this.inwardNo,
    required this.currencyCode,
    required this.exchangeRate,
    required this.preparedBy,
    required this.approvedBy,
    required this.category,
    required this.supplier,
    required this.currency,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    categoryCode: json["Category Code"],
    inwardDate: DateTime.parse(json["Inward Date"]),
    supplierCode: json["Supplier Code "],
    gstNo: json["GST No"],
    challanDate: DateTime.parse(json["Challan Date"]),
    billNo: json["Bill No"],
    billDate: DateTime.parse(json["Bill Date"]),
    challanNo: json["Challan No"],
    ewayBillNo: json["Eway Bill No"],
    ewayBillDate: DateTime.parse(json["Eway Bill Date"]),
    paymentDays: json["Payment Days"],
    inwardNo: json["Inward No"],
    currencyCode: json["Currency Code"],
    exchangeRate: json["Exchange Rate"],
    preparedBy: json["Prepared By"],
    approvedBy: json["Approved By"],
    category: json["Category"],
    supplier: json["Supplier"],
    currency: json["Currency"],
  );

  Map<String, dynamic> toJson() => {
    "Category Code": categoryCode,
    "Inward Date": inwardDate.toIso8601String(),
    "Supplier Code ": supplierCode,
    "GST No": gstNo,
    "Challan Date": challanDate.toIso8601String(),
    "Bill No": billNo,
    "Bill Date": billDate.toIso8601String(),
    "Challan No": challanNo,
    "Eway Bill No": ewayBillNo,
    "Eway Bill Date": ewayBillDate.toIso8601String(),
    "Payment Days": paymentDays,
    "Inward No": inwardNo,
    "Currency Code": currencyCode,
    "Exchange Rate": exchangeRate,
    "Prepared By": preparedBy,
    "Approved By": approvedBy,
    "Category": category,
    "Supplier": supplier,
    "Currency": currency,
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
