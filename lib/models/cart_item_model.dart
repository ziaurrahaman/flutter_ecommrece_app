import 'package:promohunter/models/product_model.dart';

class CartItemModel {
  ProductModel productModel;
  String productModelId;
  int quantity;

  CartItemModel(this.productModelId, this.quantity, {this.productModel});

  CartItemModel.fromMap(Map m) {
    productModelId = m['prodId'];
    quantity = m['quantity'];
  }

  setProductModel(ProductModel product) {
    this.productModel = product;
  }

  toMap() {
    return {
      'prodId': productModelId,
      'quantity': quantity,
    };
  }
}
