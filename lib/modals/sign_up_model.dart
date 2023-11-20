class SignUpResponse {
  String? message;
  int? status;
  SignUpData? data;

  SignUpResponse({this.message, this.status, this.data});

  SignUpResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? new SignUpData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class SignUpData {
  String? name;
  String? phoneNumber;
  String? password;
  String? countryCode;
  String? userCode;
  int? verificationCode;
  int? totalCoins;
  bool? status;
  String? userType;
  String? sId;
  String? createdAt;
  String? updatedAt;

  SignUpData(
      {this.name,
        this.phoneNumber,
        this.password,
        this.countryCode,
        this.userCode,
        this.verificationCode,
        this.totalCoins,
        this.status,
        this.userType,
        this.sId,
        this.createdAt,
        this.updatedAt});

  SignUpData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    password = json['password'];
    countryCode = json['countryCode'];
    userCode = json['userCode'];
    verificationCode = json['verificationCode'];
    totalCoins = json['totalCoins'];
    status = json['status'];
    userType = json['userType'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phoneNumber'] = this.phoneNumber;
    data['password'] = this.password;
    data['countryCode'] = this.countryCode;
    data['userCode'] = this.userCode;
    data['verificationCode'] = this.verificationCode;
    data['totalCoins'] = this.totalCoins;
    data['status'] = this.status;
    data['userType'] = this.userType;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}