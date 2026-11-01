// To parse this JSON data, do
//
//     final studentModel = studentModelFromJson(jsonString);

import 'dart:convert';

List<StudentModel> studentModelFromJson(String str) => List<StudentModel>.from(
  json.decode(str).map((x) => StudentModel.fromJson(x)),
);

String studentModelToJson(List<StudentModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StudentModel {
  int id;
  String fullName;

  StudentModel({required this.id, required this.fullName});

  factory StudentModel.fromJson(Map<String, dynamic> json) =>
      StudentModel(id: json["id"], fullName: json["full_name"]);

  Map<String, dynamic> toJson() => {"id": id, "full_name": fullName};
}
