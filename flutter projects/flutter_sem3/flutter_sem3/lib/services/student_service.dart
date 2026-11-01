import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/student_model.dart';
import 'base_url.dart';

class StudentService {
  final _baseUrl = BaseURL.base;

  Future<List<StudentModel>> fetch() async {
    final url = "$_baseUrl/api/students";

    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final list = await compute(studentModelFromJson, response.body);
        return list;
      }
      throw Exception('Server Error: ${response.statusCode}');
    } catch (e) {
      throw Exception('Failed to load students: $e');
    }
  }

  Future<bool> create(StudentModel item) async {
    final url = "$_baseUrl/api/students";

    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              "Accept": "application/json",
            },
            body: jsonEncode(item.toJson()),
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 201) {
        debugPrint("response body: ${response.body}");
        return true;
      }
      throw Exception('Server Error: ${response.statusCode}');
    } catch (e) {
      throw Exception('Failed to posting students: $e');
    }
  }

  Future<bool> delete(int id) async {
    final url = "$_baseUrl/api/students/$id";

    try {
      final response = await http
          .delete(Uri.parse(url))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        debugPrint("response body: ${response.body}");
        return true;
      }
      throw Exception('Server Error: ${response.statusCode}');
    } catch (e) {
      throw Exception('Failed to deleting students: $e');
    }
  }
}
