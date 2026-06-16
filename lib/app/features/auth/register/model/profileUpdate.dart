
import 'package:uber_boats_customer/app/features/auth/register/model/users_details_model.dart';

class ProfileUpdate {
  ProfileUpdate({
      this.statusCode, 
      this.status, 
      this.msgCode, 
      this.msg, 
      this.data,});

  ProfileUpdate.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    status = json['status'];
    msgCode = json['msgCode'];
    msg = json['msg'];
    data = json['data'] != null ? UserDetails.fromJson(json['data']) : null;
  }
  num? statusCode;
  String? status;
  String? msgCode;
  String? msg;
  UserDetails? data;


}

