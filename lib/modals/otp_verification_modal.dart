class OtpVerificationResponse {
  String? message;
  int? status;
  OtpData? data;

  OtpVerificationResponse({this.message, this.status, this.data});

  OtpVerificationResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? OtpData.fromJson(json['data']) : null;
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

class OtpData {
  String? sId;
  String? userId;
  int? iV;
  String? authToken;
  String? createdAt;
  String? updatedAt;

  OtpData(
      {this.sId,
        this.userId,
        this.iV,
        this.authToken,
        this.createdAt,
        this.updatedAt});

  OtpData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    iV = json['__v'];
    authToken = json['authToken'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    data['__v'] = this.iV;
    data['authToken'] = this.authToken;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}