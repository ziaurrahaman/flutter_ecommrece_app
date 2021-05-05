class PriceMovementModel {
  String productId;
  String shopId;
  String userId;
  num price;
  DateTime date;
  String status;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();

    map['productId'] = productId;
    map['shopId'] = shopId;
    map['userId'] = userId;
    map['price'] = price;
    map['date'] = date;
    map['status'] = status;

    return map;
  }
}
