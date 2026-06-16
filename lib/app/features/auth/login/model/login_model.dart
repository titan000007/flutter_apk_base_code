class LoginModel {
  LoginModel({
      num? statusCode, 
      String? status, 
      String? msgCode, 
      String? msg, 
      Data? data,}){
    _statusCode = statusCode;
    _status = status;
    _msgCode = msgCode;
    _msg = msg;
    _data = data;
}

  LoginModel.fromJson(dynamic json) {
    _statusCode = json['statusCode'];
    _status = json['status'];
    _msgCode = json['msgCode'];
    _msg = json['msg'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  num? _statusCode;
  String? _status;
  String? _msgCode;
  String? _msg;
  Data? _data;

  num? get statusCode => _statusCode;
  String? get status => _status;
  String? get msgCode => _msgCode;
  String? get msg => _msg;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['statusCode'] = _statusCode;
    map['status'] = _status;
    map['msgCode'] = _msgCode;
    map['msg'] = _msg;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

class Data {
  Data({
      String? token, 
      UserData? userData,}){
    _token = token;
    _userData = userData;
}

  Data.fromJson(dynamic json) {
    _token = json['token'];
    _userData = json['userData'] != null ? UserData.fromJson(json['userData']) : null;
  }
  String? _token;
  UserData? _userData;

  String? get token => _token;
  UserData? get userData => _userData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = _token;
    if (_userData != null) {
      map['userData'] = _userData?.toJson();
    }
    return map;
  }

}

class UserData {
  UserData({
      String? id, 
      String? fullName, 
      String? mobile, 
      String? email, 
      String? profileimage, 
      String? status, 
      String? fcmToken,}){
    _id = id;
    _fullName = fullName;
    _mobile = mobile;
    _email = email;
    _profileimage = profileimage;
    _status = status;
    _fcmToken = fcmToken;
}

  UserData.fromJson(dynamic json) {
    _id = json['_id'];
    _fullName = json['fullName'];
    _mobile = json['mobile'];
    _email = json['email'];
    _profileimage = json['profileimage'];
    _status = json['status'];
    _fcmToken = json['fcmToken'];
  }
  String? _id;
  String? _fullName;
  String? _mobile;
  String? _email;
  String? _profileimage;
  String? _status;
  String? _fcmToken;

  String? get id => _id;
  String? get fullName => _fullName;
  String? get mobile => _mobile;
  String? get email => _email;
  String? get profileimage => _profileimage;
  String? get status => _status;
  String? get fcmToken => _fcmToken;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['fullName'] = _fullName;
    map['mobile'] = _mobile;
    map['email'] = _email;
    map['profileimage'] = _profileimage;
    map['status'] = _status;
    map['fcmToken'] = _fcmToken;
    return map;
  }

}