class UserApiResponse {
  String? message;
  int? status;
  UserData? data;

  UserApiResponse({this.message, this.status, this.data});

  UserApiResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? new UserData.fromJson(json['data']) : null;
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

class UserData {
  String? userType;
  String? sId;
  String? name;
  String? phoneNumber;
  String? password;
  String? countryCode;
  String? userCode;
  int? verificationCode;
  int? totalCoins;
  bool? status;
  String? createdAt;
  String? updatedAt;

  UserData(
      {this.userType,
        this.sId,
        this.name,
        this.phoneNumber,
        this.password,
        this.countryCode,
        this.userCode,
        this.verificationCode,
        this.totalCoins,
        this.status,
        this.createdAt,
        this.updatedAt});

  UserData.fromJson(Map<String, dynamic> json) {
    userType = json['userType'];
    sId = json['_id'];
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    password = json['password'];
    countryCode = json['countryCode'];
    userCode = json['userCode'];
    verificationCode = json['verificationCode'];
    totalCoins = json['totalCoins'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userType'] = this.userType;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['phoneNumber'] = this.phoneNumber;
    data['password'] = this.password;
    data['countryCode'] = this.countryCode;
    data['userCode'] = this.userCode;
    data['verificationCode'] = this.verificationCode;
    data['totalCoins'] = this.totalCoins;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}