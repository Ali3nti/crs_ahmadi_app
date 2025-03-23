import 'package:flutter/foundation.dart';

class DataResponse {
  String status = '';
  String message = '';
  dynamic data;

  DataResponse();

  DataResponse.fromJson(Map<String, dynamic> json) {
    try {
      status = json['status'];
      message = json['message'];
      data = (json['data'] != null) ? json['data'] : null;
    } catch (e) {
      if (kDebugMode) {
        print("Exception - DataResponse.dart - DataResponse.fromJson():$e");
      }
    }
  }
}
