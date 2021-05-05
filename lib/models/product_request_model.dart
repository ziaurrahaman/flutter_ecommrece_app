class ProductRequestModel {
  String id;
  String brandName;
  String productName;

  ProductRequestModel(this.brandName, this.productName);

  ProductRequestModel.fromMap(this.id, Map m)
      : brandName = m['brandName'],
        productName = m['productName'];

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();

    map['brandName'] = brandName;
    map['productName'] = productName;

    return map;
  }
}
