// To parse this JSON data, do
//
//     final employees = employeesFromJson(jsonString);

import 'dart:convert';

List<Employees> employeesFromJson(String str) =>
    List<Employees>.from(json.decode(str).map((x) => Employees.fromJson(x)));

String employeesToJson(List<Employees> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Employees {
  int? id;
  String? name;
  String? employeeId;
  String? personId;
  List<String>? faceIds;
  bool? isLocked;
  dynamic isSalesman;
  DateTime? updatedAt;
  Pivot? pivot;

  Employees({
    this.id,
    this.name,
    this.employeeId,
    this.personId,
    this.faceIds,
    this.isLocked,
    this.isSalesman,
    this.updatedAt,
    this.pivot,
  });

  factory Employees.fromJson(Map<String, dynamic> json) => Employees(
        id: json["id"],
        name: json["name"],
        employeeId: json["employee_id"],
        personId: json["person_id"],
        faceIds: json["face_ids"] == null
            ? []
            : List<String>.from(json["face_ids"]!.map((x) => x)),
        isLocked: json["is_locked"],
        isSalesman: json["is_salesman"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        pivot: json["pivot"] == null ? null : Pivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "employee_id": employeeId,
        "person_id": personId,
        "face_ids":
            faceIds == null ? [] : List<dynamic>.from(faceIds!.map((x) => x)),
        "is_locked": isLocked,
        "is_salesman": isSalesman,
        "updated_at": updatedAt?.toIso8601String(),
        "pivot": pivot?.toJson(),
      };
}

class Pivot {
  dynamic userId;
  dynamic employeeId;

  Pivot({
    this.userId,
    this.employeeId,
  });

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        userId: json["user_id"],
        employeeId: json["employee_id"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "employee_id": employeeId,
      };
}

class User {
  final String employeeId;
  final String employeeName;
  final String cloudStorageBucketName;
  final List<String> photoUris;

  User({
    required this.employeeId,
    required this.employeeName,
    required this.cloudStorageBucketName,
    required this.photoUris,
  });
}
