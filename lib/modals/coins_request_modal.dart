class CoinsPriceRequest {
  String? type;
  Setting? setting;

  CoinsPriceRequest({this.type, this.setting});

  CoinsPriceRequest.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    setting =
    json['setting'] != null ? new Setting.fromJson(json['setting']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.setting != null) {
      data['setting'] = this.setting!.toJson();
    }
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this.price;
    return data;
  }
}