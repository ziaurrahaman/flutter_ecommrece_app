import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:promohunter/models/brand_model.dart';
import 'package:promohunter/utils/database_client.dart';

class ProductModel {
  String id;
  String catId;
  String brandId;
  String name;
  String picture;
  String description;
  List<String> restrictionIds = [];
  List<AlternatePriceModel> alternatePrices = [];
  num noOfViews;
  num noOfLikes;
  num noOfFav;
  num noOfCart;
  num basicPrice;
  String barcode;

  num get minPrice {
    if (alternatePrices.isEmpty) return basicPrice;
    alternatePrices.sort((a, b) => a.price.compareTo(b.price));
    return alternatePrices.first.price;
  }

  num shopPromoPrice(String shopName) {
    var price;
    // alternatePrices.where((element) => element.shopName == shopName);
    for (int i = 0; i < alternatePrices.length; i++) {
      if (alternatePrices[i].shopName == shopName) {
        price = alternatePrices[i].price;
      }
    }
    print('shopPromoPrice: $price');
    return price;
  }

  String get discountPercentage {
    if (alternatePrices.isEmpty) return '0';
    final discount = basicPrice - minPrice;
    return ((discount / basicPrice) * 100).toStringAsFixed(0);
  }

  Future<void> getBrand() async {
    brandModel = await DatabaseClient.instance.getBrand(brandId);
  }

  BrandModel brandModel;

  ProductModel.fromMap(this.id, Map m) {
    name = m['name'];
    catId = m['catId'];
    brandId = m['brandId'];
    picture = m['picture'];
    description = m['description'];
    if (m['restrictionIds'] != null) {
      (m['restrictionIds'] as List).forEach((i) => restrictionIds.add(i));
    }
    if (m['alternatePrices'] != null) {
      (m['alternatePrices'] as List)
          .forEach((i) => alternatePrices.add(AlternatePriceModel.fromMap(i)));
    }
    noOfViews = m['noOfViews'] ?? 0;
    noOfFav = m['noOfFav'] ?? 0;
    noOfLikes = m['noOfLikes'] ?? 0;
    noOfCart = m['noOfCart'] ?? 0;
    basicPrice = m['basicPrice'];
    barcode = m['barcode'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();

    map['name'] = name;
    map['catId'] = catId;
    map['brandId'] = brandId;
    map['picture'] = picture;
    map['description'] = description;
    map['restrictionIds'] = restrictionIds;
    map['alternatePrices'] = alternatePrices.map((e) => e.toMap()).toList();
    map['noOfViews'] = noOfViews;
    map['noOfLikes'] = noOfLikes;
    map['noOfFav'] = noOfFav;
    map['noOfCart'] = noOfCart;
    map['basicPrice'] = basicPrice;
    map['barcode'] = barcode;

    return map;
  }
}

class AlternatePriceModel {
  String shopId;
  String shopName;
  DateTime lastUpdated;
  num confirmedBy;
  num price;

  AlternatePriceModel();

  AlternatePriceModel.fromMap(Map m)
      : shopName = m['shopName'],
        shopId = m['shopId'],
        lastUpdated =
            ((m['lastUpdated'] as Timestamp).toDate()) ?? DateTime.now(),
        confirmedBy = m['confirmedBy'],
        price = m['price'];

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();

    map['shopName'] = shopName;
    map['shopId'] = shopId;
    map['lastUpdated'] = lastUpdated;
    map['confirmedBy'] = confirmedBy ?? 0;
    map['price'] = price;

    return map;
  }
}
