import 'package:flutter/material.dart';
import 'package:promohunter/models/brand_model.dart';
import 'package:promohunter/models/cart_item_model.dart';
import 'package:promohunter/models/category_model.dart';
import 'package:promohunter/models/product_model.dart';
import 'package:promohunter/models/restriction_model.dart';
import 'package:promohunter/models/user_model.dart';
import 'package:promohunter/utils/database_client.dart';

class ProductProvider extends ChangeNotifier {
  ProductModel product;
  UserModel currentUser;

  bool isInFav = false;
  bool isInCart = false;
  BrandModel brand;
  CategoryModel category;
  List<RestrictionModel> restrictions = [];

  ProductProvider(this.product, this.currentUser) {
    inFav();
    inCart();
    getBrand();
    getCategory();
    getRestrictions();
  }

  void increaseViews() {
    DatabaseClient.instance.increasingProductViews(product.id);
    DatabaseClient.instance.updateProductsViewedPoints(currentUser);
  }

  Future<void> addToFav() async {
    currentUser.favIds.add(product.id);

    await DatabaseClient.instance.updateUserData(currentUser);

    product.noOfFav++;

    isInFav = true;

    DatabaseClient.instance.updateProduct(product);

    DatabaseClient.instance.updateFavoritesAddedPoints(currentUser);

    notifyListeners();
  }

  Future<void> remFromFav() async {
    currentUser.favIds.remove(product.id);

    await DatabaseClient.instance.updateUserData(currentUser);

    product.noOfFav--;

    isInFav = false;

    DatabaseClient.instance.updateProduct(product);

    notifyListeners();
  }

  void inFav() {
    isInFav = currentUser.favIds.contains(product.id) ?? false;

    notifyListeners();
  }

  Future<void> addToCart() async {
    currentUser.cartIds.add(CartItemModel(product.id, 1));

    await DatabaseClient.instance.updateUserData(currentUser);

    product.noOfCart++;

    isInCart = true;

    DatabaseClient.instance.updateProduct(product);

    DatabaseClient.instance.updateProductsInListPoints(currentUser);

    notifyListeners();
  }

  Future<void> remFromCart() async {
    currentUser.cartIds
        .removeWhere((element) => element.productModelId == product.id);

    await DatabaseClient.instance.updateUserData(currentUser);

    product.noOfCart--;

    isInCart = false;

    DatabaseClient.instance.updateProduct(product);

    notifyListeners();
  }

  void inCart() {
    List<CartItemModel> temp = currentUser.cartIds
        .where((element) => element.productModelId == product.id)
        .toList();
    isInCart = (temp ?? []).isNotEmpty;

    notifyListeners();
  }

  Future<void> getRestrictions() async {
    for (String id in product.restrictionIds) {
      restrictions.add(await DatabaseClient.instance.getRestriction(id));
    }

    notifyListeners();
  }

  Future<void> getCategory() async {
    category = await DatabaseClient.instance.getCategory(product.catId);

    notifyListeners();
  }

  Future<void> getBrand() async {
    brand = await DatabaseClient.instance.getBrand(product.brandId);

    notifyListeners();
  }
}
