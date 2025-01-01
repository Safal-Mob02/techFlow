// To parse this JSON data, do
//
//     final materialReceiptPendingListResponse = materialReceiptPendingListResponseFromJson(jsonString);

import 'dart:convert';

MaterialReceiptPendingListResponse materialReceiptPendingListResponseFromJson(String str) => MaterialReceiptPendingListResponse.fromJson(json.decode(str));

String materialReceiptPendingListResponseToJson(MaterialReceiptPendingListResponse data) => json.encode(data.toJson());

class MaterialReceiptPendingListResponse {
  Settings settings;
  List<Datum> data;

  MaterialReceiptPendingListResponse({
    required this.settings,
    required this.data,
  });

  factory MaterialReceiptPendingListResponse.fromJson(Map<String, dynamic> json) => MaterialReceiptPendingListResponse(
    settings: Settings.fromJson(json["settings"]),
    data: List<Datum>.from(json["Data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "settings": settings.toJson(),
    "Data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  var status;
  String urnNo;
  String orderDate;
  String soNo;
  String itemName;
  var process;
  var pendingQty;
  String remarks;
  String contractorName;
  String itemSrNo;
  var srNo;

  Datum({
    required this.status,
    required this.urnNo,
    required this.orderDate,
    required this.soNo,
    required this.itemName,
    required this.process,
    required this.pendingQty,
    required this.remarks,
    required this.contractorName,
    required this.itemSrNo,
    required this.srNo,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    status: json["Status"]!,
    urnNo: json["Urn_No"],
    orderDate: json["Order Date"],
    soNo: json["SO No"],
    itemName: json["Item Name"],
    process: json["Process"]!,
    pendingQty: json["Pending Qty"],
    remarks: json["Remarks"],
    contractorName: json["Contractor Name"],
    itemSrNo: json["Item Sr No"],
    srNo: json["Sr_No"],
  );

  Map<String, dynamic> toJson() => {
    "Status": status,
    "Urn_No": urnNo,
    "Order Date": orderDate,
    "SO No": soNo,
    "Item Name": itemName,
    "Process": process,
    "Pending Qty": pendingQty,
    "Remarks": remarks,
    "Contractor Name": contractorName,
    "Item Sr No": itemSrNo,
    "Sr_No": srNo,
  };
}

enum Process {
  STRUCTURE_CUTTING
}

final processValues = EnumValues({
  "Structure Cutting": Process.STRUCTURE_CUTTING
});

enum Status {
  PENDING
}

final statusValues = EnumValues({
  "Pending": Status.PENDING
});

class Settings {
  String success;
  String message;
  String nextPage;
  List<String> fields;

  Settings({
    required this.success,
    required this.message,
    required this.nextPage,
    required this.fields,
  });

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
    success: json["success"],
    message: json["message"],
    nextPage: json["next_page"],
    fields: List<String>.from(json["fields"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "next_page": nextPage,
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
