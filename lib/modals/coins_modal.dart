
class CoinsPriceResponse {
  String? message;
  int? status;
  CoinsData? data;

  CoinsPriceResponse({this.message, this.status, this.data});

  CoinsPriceResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? CoinsData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}


class CoinsData {
  String? sId;
  String? type;
  String? createdAt;
  Setting? setting;
  String? updatedAt;

  CoinsData({this.sId, this.type, this.createdAt, this.setting, this.updatedAt});

  CoinsData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    type = json['type'];
    createdAt = json['createdAt'];
    setting =
    json['setting'] != null ? Setting.fromJson(json['setting']) : null;
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['type'] = type;
    data['createdAt'] = createdAt;
    if (setting != null) {
      data['setting'] = setting!.toJson();
    }
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class Setting {
  int? price;

  Setting({this.price});

  Setting.fromJson(Map<String, dynamic> json) {
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    return data;
  }
}