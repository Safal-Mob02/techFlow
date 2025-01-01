// To parse this JSON data, do
//
//     final productionQcPendingListResponse = productionQcPendingListResponseFromJson(jsonString);

import 'dart:convert';

ProductionQcPendingListResponse productionQcPendingListResponseFromJson(String str) => ProductionQcPendingListResponse.fromJson(json.decode(str));

String productionQcPendingListResponseToJson(ProductionQcPendingListResponse data) => json.encode(data.toJson());

class ProductionQcPendingListResponse {
  Settings settings;
  List<Datum> data;

  ProductionQcPendingListResponse({
    required this.settings,
    required this.data,
  });

  factory ProductionQcPendingListResponse.fromJson(Map<String, dynamic> json) => ProductionQcPendingListResponse(
    settings: Settings.fromJson(json["settings"]),
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "settings": settings.toJson(),
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  var status;
  String urnNo;
  String orderDate;
  String itemSrNo;
  String soNo;
  String itemName;
  var qty;
  String process;
  String? remark;
  var srNo;

  Datum({
    required this.status,
    required this.urnNo,
    required this.orderDate,
    required this.itemSrNo,
    required this.soNo,
    required this.itemName,
    required this.qty,
    required this.process,
    this.remark,
    required this.srNo,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    status: json["Status"]!,
    urnNo: json["URN_No"],
    orderDate: json["Order Date"],
    itemSrNo: json["Item Sr No"],
    soNo: json["SO No"],
    itemName: json["Item Name"],
    qty: json["Qty"],
    process: json["Process"],
    remark: json["Remark"],
    srNo: json["Sr_No"],
  );

  Map<String, dynamic> toJson() => {
    "Status": status,
    "URN_No": urnNo,
    "Order Date": orderDate,
    "Item Sr No": itemSrNo,
    "SO No": soNo,
    "Item Name": itemName,
    "Qty": qty,
    "Process": process,
    "Remark": remark,
    "Sr_No": srNo,
  };
}

enum Status {
  PARTIAL,
  PENDING
}

final statusValues = EnumValues({
  "Partial": Status.PARTIAL,
  "Pending": Status.PENDING
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
