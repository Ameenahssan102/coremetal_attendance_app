class Profile {
  String? type;
  String? name;
  String? username;
  String? geoLocation;
  String? location;
  String? groupId;
  dynamic personId;
  dynamic faceIds;
  bool? isLocked;
  dynamic employeeId;
  List<Employee>? employees;

  Profile({
    this.type,
    this.name,
    this.username,
    this.geoLocation,
    this.location,
    this.groupId,
    this.personId,
    this.faceIds,
    this.isLocked,
    this.employeeId,
    this.employees,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        type: json["type"],
        name: json["name"],
        username: json["username"],
        geoLocation: json["geo_location"],
        location: json["location"],
        groupId: json["group_id"],
        personId: json["person_id"],
        faceIds: json["face_ids"],
        isLocked: json["is_locked"],
        employeeId: json["employee_id"],
        employees: json["employees"] == null
            ? []
            : List<Employee>.from(
                json["employees"]!.map((x) => Employee.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "name": name,
        "username": username,
        "geo_location": geoLocation,
        "location": location,
        "group_id": groupId,
        "person_id": personId,
        "face_ids": faceIds,
        "is_locked": isLocked,
        "employee_id": employeeId,
        "employees": employees == null
            ? []
            : List<dynamic>.from(employees!.map((x) => x.toJson())),
      };
}

class Employee {
  int? id;
  String? name;
  String? employeeId;
  String? personId;
  List<String>? faceIds;
  bool? isLocked;
  dynamic isSalesman;
  DateTime? updatedAt;
  Pivot? pivot;

  Employee({
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

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
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
