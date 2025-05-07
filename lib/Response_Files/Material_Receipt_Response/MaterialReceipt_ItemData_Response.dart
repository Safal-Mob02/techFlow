// To parse this JSON data, do
//
//     final materialReceiptItemDataResponse = materialReceiptItemDataResponseFromJson(jsonString);

import 'dart:convert';

MaterialReceiptItemDataResponse materialReceiptItemDataResponseFromJson(String str) => MaterialReceiptItemDataResponse.fromJson(json.decode(str));

String materialReceiptItemDataResponseToJson(MaterialReceiptItemDataResponse data) => json.encode(data.toJson());

class MaterialReceiptItemDataResponse {
  Settings settings;
  List<Datum> data;

  MaterialReceiptItemDataResponse({
    required this.settings,
    required this.data,
  });

  factory MaterialReceiptItemDataResponse.fromJson(Map<String, dynamic> json) => MaterialReceiptItemDataResponse(
    settings: Settings.fromJson(json["settings"]),
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "settings": settings.toJson(),
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  var index;
  String soNo;
  String itemName;
  String itemCode;
  String process;
  var quantity;
  String unit;
  String unitCode;
  String location;
  String locationCode;
  String stock;
  String remarks;
  var assemblyWeight;
  String fabricationContractor;
  String fabricationRateKg;
  String weldingContractor;
  var weldingRate;
  String paintContractor;
  var paintRate;
  var ductPipingQty;
  String drgWeight;
  String processCode;
  String size;
  String structure;
  var rate;
  var amount;
  var processTimeHrs;
  String qcUrnNo;
  String originalUrnNo;
  String Fabrication_Contractor_Code;
  var SR_No;

  Datum({
    required this.index,
    required this.soNo,
    required this.itemName,
    required this.itemCode,
    required this.process,
    required this.quantity,
    required this.unit,
    required this.unitCode,
    required this.location,
    required this.locationCode,
    required this.stock,
    required this.remarks,
    required this.assemblyWeight,
    required this.fabricationContractor,
    required this.fabricationRateKg,
    required this.weldingContractor,
    required this.weldingRate,
    required this.paintContractor,
    required this.paintRate,
    required this.ductPipingQty,
    required this.drgWeight,
    required this.processCode,
    required this.size,
    required this.structure,
    required this.rate,
    required this.amount,
    required this.processTimeHrs,
    required this.qcUrnNo,
    required this.originalUrnNo,
    required this.Fabrication_Contractor_Code,
    required this.SR_No,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    index: json["Index"],
    soNo: json["SO_No"],
    itemName: json["Item_Name"],
    itemCode: json["Item_Code"],
    process: json["Process"],
    quantity: json["Quantity"],
    unit: json["Unit"],
    unitCode: json["Unit Code"],
    location: json["Location"],
    locationCode: json["Location Code"],
    stock: json["Stock"],
    remarks: json["Remarks"],
    assemblyWeight: json["Assembly Weight"],
    fabricationContractor: json["Fabrication Contractor"],
    fabricationRateKg: json["Fabrication Rate / Kg"],
    weldingContractor: json["Welding Contractor"],
    weldingRate: json["Welding Rate"],
    paintContractor: json["Paint Contractor"],
    paintRate: json["Paint Rate"],
    ductPipingQty: json["Duct / Piping Qty"],
    drgWeight: json["Drg Weight"],
    processCode: json["Process_Code"],
    size: json["Size"],
    structure: json["Structure"],
    rate: json["Rate"],
    amount: json["Amount"],
    processTimeHrs: json["Process Time (Hrs)"],
    qcUrnNo: json["QC_URN_No"],
    originalUrnNo: json["Original_URN_No"],
    Fabrication_Contractor_Code: json["Fabrication_Contractor_Code"],
    SR_No: json["SR_No"],
  );

  Map<String, dynamic> toJson() => {
    "Index": index,
    "SO_No": soNo,
    "Item_Name": itemName,
    "Item_Code": itemCode,
    "Process": process,
    "Quantity": quantity,
    "Unit": unit,
    "Unit Code": unitCode,
    "Location": location,
    "Location Code": locationCode,
    "Stock": stock,
    "Remarks": remarks,
    "Assembly Weight": assemblyWeight,
    "Fabrication Contractor": fabricationContractor,
    "Fabrication Rate / Kg": fabricationRateKg,
    "Welding Contractor": weldingContractor,
    "Welding Rate": weldingRate,
    "Paint Contractor": paintContractor,
    "Paint Rate": paintRate,
    "Duct / Piping Qty": ductPipingQty,
    "Drg Weight": drgWeight,
    "Process_Code": processCode,
    "Size": size,
    "Structure": structure,
    "Rate": rate,
    "Amount": amount,
    "Process Time (Hrs)": processTimeHrs,
    "QC_URN_No": qcUrnNo,
    "Original_URN_No": originalUrnNo,
    "Fabrication_Contractor_Code": Fabrication_Contractor_Code,
    "SR_No": SR_No,
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
