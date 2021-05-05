import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:promohunter/models/achievements_points_model.dart';
import 'package:promohunter/models/ad_model.dart';
import 'package:promohunter/models/brand_model.dart';
import 'package:promohunter/models/brochures_model.dart';
import 'package:promohunter/models/category_model.dart';
import 'package:promohunter/models/membership_card_model.dart';
import 'package:promohunter/models/price_movement_model.dart';
import 'package:promohunter/models/product_model.dart';
import 'package:promohunter/models/product_request_model.dart';
import 'package:promohunter/models/restriction_model.dart';
import 'package:promohunter/models/settings_model.dart';
import 'package:promohunter/models/shop_model.dart';
import 'package:promohunter/models/user_model.dart';
import 'package:promohunter/utils/auth_client.dart';
import 'package:promohunter/utils/constants.dart';

class DatabaseClient {
  //Singleton
  DatabaseClient._privateConstructor();
  static final DatabaseClient instance = DatabaseClient._privateConstructor();

  final _db = Firestore.instance;

  Future<bool> isUserExist() async {
    String userId = await AuthClient.instance.uid();

    return userId == null
        ? false
        : await _db
            .collection('users')
            .document('$userId')
            .get()
            .then((d) => (d?.exists) ?? false);
  }

  Future<void> putUserData(UserModel userModel) async {
    String userId = await AuthClient.instance.uid();

    await _db
        .collection('users')
        .document('$userId')
        .setData(userModel.toMap(), merge: true);

    userModel.userNumber = await _putUserNumber();
  }

  Future<void> updateUserData(UserModel userModel) async {
    await _db
        .collection('users')
        .document('${userModel.id}')
        .setData(userModel.toMap(), merge: true);
  }

  Future<UserModel> getUserData() async {
    String userId = await AuthClient.instance.uid();

    UserModel userModel;

    userModel = await _db
        .collection('users')
        .document('$userId')
        .get()
        .then((d) => UserModel.fromMap(d.documentID, d.data));

    return userModel;
  }

  Future<SettingsModel> getSettings() async {
    return await _db
        .collection('settings')
        .document('settings')
        .get()
        .then((d) => SettingsModel.fromMap(d.data));
  }

  Future<void> updateProduct(ProductModel productModel) async {
    await _db
        .collection('products')
        .document('${productModel.id}')
        .updateData(productModel.toMap());
  }

  Future<void> requestProduct(ProductRequestModel product) async {
    await _db.collection('productsRequests').add(product.toMap());
  }

  Future<void> putPriceRequest(PriceMovementModel priceMovement) async {
    await _db.collection('priceRequests').add(priceMovement.toMap());
  }

  Future<void> putPriceMovement(PriceMovementModel priceMovement) async {
    await _db.collection('priceMovement').add(priceMovement.toMap());
  }

  Future<List<AdModel>> getAds() async {
    List<AdModel> ads = List<AdModel>();

    QuerySnapshot querySnapshot = await _db.collection('ads').getDocuments();

    querySnapshot.documents
        .forEach((d) => ads.add(AdModel.fromMap(d.documentID, d.data)));

    return ads;
  }

  Future<List<CategoryModel>> getCategories() async {
    List<CategoryModel> categories = List<CategoryModel>();

    QuerySnapshot querySnapshot =
        await _db.collection('categories').getDocuments();

    querySnapshot.documents.forEach(
        (d) => categories.add(CategoryModel.fromMap(d.documentID, d.data)));

    return categories;
  }

  Future<List<BrandModel>> getBrands() async {
    List<BrandModel> brands = List<BrandModel>();

    QuerySnapshot querySnapshot = await _db.collection('brands').getDocuments();

    querySnapshot.documents
        .forEach((d) => brands.add(BrandModel.fromMap(d.documentID, d.data)));

    return brands;
  }

  Future<List<ShopModel>> getShops() async {
    List<ShopModel> shops = List<ShopModel>();

    QuerySnapshot querySnapshot = await _db.collection('shops').getDocuments();

    querySnapshot.documents
        .forEach((d) => shops.add(ShopModel.fromMap(d.documentID, d.data)));

    return shops;
  }

  Future<RestrictionModel> getRestriction(String resId) async {
    RestrictionModel restriction;

    restriction = await _db
        .collection('restrictions')
        .document('$resId')
        .get()
        .then((d) => RestrictionModel.fromMap(d.documentID, d.data ?? {}));

    return restriction;
  }

  Future<CategoryModel> getCategory(String catId) async {
    CategoryModel cat;

    cat = await _db
        .collection('categories')
        .document('$catId')
        .get()
        .then((d) => CategoryModel.fromMap(d.documentID, d.data ?? {}));

    return cat;
  }

  Future<BrandModel> getBrand(String brandId) async {
    BrandModel brand;

    brand = await _db
        .collection('brands')
        .document('$brandId')
        .get()
        .then((d) => BrandModel.fromMap(d.documentID, d.data ?? {}));

    return brand;
  }

  Future<ShopModel> getShop(String shopId) async {
    ShopModel shop;

    shop = await _db
        .collection('shops')
        .document('$shopId')
        .get()
        .then((d) => ShopModel.fromMap(d.documentID, d.data ?? {}));

    return shop;
  }

  Future<ProductModel> getProduct(String prodId) async {
    ProductModel productModel;

    productModel = await _db
        .collection('products')
        .document('$prodId')
        .get()
        .then((d) =>
            d.exists ? ProductModel.fromMap(d.documentID, d.data ?? {}) : null);

    return productModel;
  }

  Future<List<ProductModel>> getProducts() async {
    List<ProductModel> deals = List<ProductModel>();

    QuerySnapshot querySnapshot =
        await _db.collection('products').getDocuments();

    querySnapshot.documents
        .forEach((d) => deals.add(ProductModel.fromMap(d.documentID, d.data)));

    return deals;
  }

  Future<List<BrochuresModel>> getBrochures() async {
    List<BrochuresModel> brochures = List<BrochuresModel>();

    QuerySnapshot querySnapshot =
        await _db.collection('brochures').getDocuments();

    querySnapshot.documents.forEach(
        (d) => brochures.add(BrochuresModel.fromMap(d.documentID, d.data)));

    return brochures;
  }

  Future<List<MembershipCardType>> getMembershipCardType() async {
    List<MembershipCardType> types = List<MembershipCardType>();

    QuerySnapshot querySnapshot =
        await _db.collection('membershipTypes').getDocuments();

    querySnapshot.documents
        .forEach((d) => types.add(MembershipCardType.fromMap(d.data)));

    return types;
  }

  Future<void> addMembershipCardToUser(
      MembershipCardModel membershipCardModel) async {
    String userId = await AuthClient.instance.uid();

    await _db
        .collection('users')
        .document(userId)
        .collection('membershipCards')
        .add(membershipCardModel.toMap());
  }

  Future<List<MembershipCardModel>> getUserMembershipCards() async {
    String userId = await AuthClient.instance.uid();

    List<MembershipCardModel> cards = List<MembershipCardModel>();

    QuerySnapshot querySnapshot = await _db
        .collection('users')
        .document(userId)
        .collection('membershipCards')
        .getDocuments();

    querySnapshot.documents.forEach(
        (d) => cards.add(MembershipCardModel.fromMap(d.documentID, d.data)));

    return cards;
  }

  Future<void> deleteMembershipCard(String cardId) async {
    String userId = await AuthClient.instance.uid();

    await _db
        .collection('users')
        .document(userId)
        .collection('membershipCards')
        .document(cardId)
        .delete();

    print(cardId);
  }

  Future<void> increasingProductFav(String prodId) async {
    await _db.runTransaction((transaction) {
      final _userRef = _db.collection('products').document(prodId);

      return transaction.get(_userRef).then((sfDoc) {
        if (!sfDoc.exists) {
          throw "Document does not exist!";
        }
        var newPopulation = (sfDoc.data['noOfFav'] ?? 0) + 1;

        transaction.update(_userRef, {"noOfFav": newPopulation});
      });
    }).then((f) {
      print("Transaction successfully committed!");
    }).catchError((error) {
      print("Transaction failed: $error");
    });
  }

  Future<void> decreasingProductFav(String prodId) async {
    await _db.runTransaction((transaction) {
      final _userRef = _db.collection('products').document(prodId);

      return transaction.get(_userRef).then((sfDoc) {
        if (!sfDoc.exists) {
          throw "Document does not exist!";
        }
        var newPopulation = (sfDoc.data['noOfFav'] ?? 1) - 1;

        transaction.update(_userRef, {"noOfFav": newPopulation});
      });
    }).then((f) {
      print("Transaction successfully committed!");
    }).catchError((error) {
      print("Transaction failed: $error");
    });
  }

  Future<void> increasingProductCart(String prodId) async {
    await _db.runTransaction((transaction) {
      final _userRef = _db.collection('products').document(prodId);

      return transaction.get(_userRef).then((sfDoc) {
        if (!sfDoc.exists) {
          throw "Document does not exist!";
        }
        var newPopulation = (sfDoc.data['noOfCart'] ?? 0) + 1;

        transaction.update(_userRef, {"noOfCart": newPopulation});
      });
    }).then((f) {
      print("Transaction successfully committed!");
    }).catchError((error) {
      print("Transaction failed: $error");
    });
  }

  Future<void> decreasingProductCart(String prodId) async {
    await _db.runTransaction((transaction) {
      final _userRef = _db.collection('products').document(prodId);

      return transaction.get(_userRef).then((sfDoc) {
        if (!sfDoc.exists) {
          throw "Document does not exist!";
        }
        var newPopulation = (sfDoc.data['noOfCart'] ?? 1) - 1;

        transaction.update(_userRef, {"noOfCart": newPopulation});
      });
    }).then((f) {
      print("Transaction successfully committed!");
    }).catchError((error) {
      print("Transaction failed: $error");
    });
  }

  Future<void> increasingProductViews(String prodId) async {
    await _db.runTransaction((transaction) {
      final _userRef = _db.collection('products').document(prodId);

      return transaction.get(_userRef).then((sfDoc) {
        if (!sfDoc.exists) {
          throw "Document does not exist!";
        }
        var newPopulation = (sfDoc.data['noOfViews'] ?? 0) + 1;

        transaction.update(_userRef, {"noOfViews": newPopulation});
      });
    }).then((f) {
      print("Transaction successfully committed!");
    }).catchError((error) {
      print("Transaction failed: $error");
    });
  }

  Future<String> getTerms() async {
    return await _db
        .collection('admin')
        .document('terms')
        .get()
        .then((d) => d.data['terms']);
  }

  Future<String> getPolicy() async {
    return await _db
        .collection('admin')
        .document('privacy')
        .get()
        .then((d) => d.data['privacy']);
  }

  Future<String> getAbout() async {
    return await _db
        .collection('admin')
        .document('about')
        .get()
        .then((d) => d.data['about']);
  }

  Future<PointsPerAchievementsModel> getAchievementsPoints() async {
    return await _db
        .collection('admin')
        .document('points')
        .get()
        .then((d) => PointsPerAchievementsModel.fromMap(d.data ?? Map()));
  }

  Future<bool> checkReferral(num ref) async {
    DocumentReference reference;
    bool referralExist =
        await _db.collection('user_numbers').document('$ref').get().then((d) {
      if (d.data != null) reference = d?.data['user_ref'];
      return ((d?.exists) ?? false);
    });

    if (referralExist) {
      UserModel user = await getUser(reference.documentID);

      PointsPerAchievementsModel pointsPerAchievementsModel =
          await getAchievementsPoints();

      user.achievements[Achievements.SuccessfulReferrals] =
          (user.achievements[Achievements.SuccessfulReferrals] ?? 0) +
              pointsPerAchievementsModel.successfulReferrals;

      user.points += pointsPerAchievementsModel.successfulReferrals;

      await updateUserData(user);
    }

    return referralExist;
  }

  Future<UserModel> getUser(String id) async {
    return await _db
        .collection('users')
        .document(id)
        .get()
        .then((d) => UserModel.fromMap(d.documentID, d.data));
  }

  Future<void> updateDailyPoints(UserModel user) async {
    PointsPerAchievementsModel pointsPerAchievementsModel =
        await getAchievementsPoints();

    user.achievements[Achievements.NoOfDaysAppInstalled] =
        (user.achievements[Achievements.NoOfDaysAppInstalled] ?? 0) +
            pointsPerAchievementsModel.noOfDaysAppInstalled;

    user.points += pointsPerAchievementsModel.noOfDaysAppInstalled;

    await updateUserData(user);
  }

  Future<void> updatePricePoint(UserModel user,
      PointsPerAchievementsModel pointsPerAchievementsModel) async {
    user.achievements[Achievements.PricesUpdates] =
        (user.achievements[Achievements.PricesUpdates] ?? 0) +
            pointsPerAchievementsModel.pricesUpdates;

    user.points += pointsPerAchievementsModel.pricesUpdates;

    await updateUserData(user);
  }

  Future<void> updatePromoHuntPoints(UserModel user,
      PointsPerAchievementsModel pointsPerAchievementsModel) async {
    user.achievements[Achievements.PromoHunted] =
        (user.achievements[Achievements.PromoHunted] ?? 0) +
            pointsPerAchievementsModel.promoHunted;

    user.points += pointsPerAchievementsModel.promoHunted;

    await updateUserData(user);
  }

  Future<void> updateFavoritesAddedPoints(UserModel user) async {
    PointsPerAchievementsModel pointsPerAchievementsModel =
        await getAchievementsPoints();

    user.achievements[Achievements.FavoritesAdded] =
        (user.achievements[Achievements.FavoritesAdded] ?? 0) +
            pointsPerAchievementsModel.favoritesAdded;

    user.points += pointsPerAchievementsModel.favoritesAdded;

    await updateUserData(user);
  }

  Future<void> updateProductsInListPoints(UserModel user) async {
    PointsPerAchievementsModel pointsPerAchievementsModel =
        await getAchievementsPoints();

    user.achievements[Achievements.ProductsInList] =
        (user.achievements[Achievements.ProductsInList] ?? 0) +
            pointsPerAchievementsModel.productsInList;

    user.points += pointsPerAchievementsModel.productsInList;

    await updateUserData(user);
  }

  Future<void> updateProductsViewedPoints(UserModel user) async {
    PointsPerAchievementsModel pointsPerAchievementsModel =
        await getAchievementsPoints();

    user.achievements[Achievements.ProductsViewed] =
        (user.achievements[Achievements.ProductsViewed] ?? 0) +
            pointsPerAchievementsModel.productsViewed;

    user.points += pointsPerAchievementsModel.productsViewed;

    await updateUserData(user);
  }

  Future<void> updateProductsRequestedPoints(UserModel user,
      PointsPerAchievementsModel pointsPerAchievementsModel) async {
    user.achievements[Achievements.ProductsRequested] =
        (user.achievements[Achievements.ProductsRequested] ?? 0) +
            pointsPerAchievementsModel.productsRequested;

    user.points += pointsPerAchievementsModel.productsRequested;

    await updateUserData(user);
  }

  // 1- Get the current user number(default if number not found) and increment it
  // 2- We get the current number from "USERS_NUMBERS" collection from
  // "current_user_number" document, the key is "current_user_number"
  // 3- if we didn't find the number we put the default number
  // 4- we increment the number and write it in the user's document in "users"
  // Collection
  // 5- in "USERS_NUMBERS" collection we create new document with the incremented
  // number as it's key(Path) and one field => user_ref : user'sDocumentReference

  Future<num> _putUserNumber() async {
    // the default number we gonna use if it's the first user
    // (first login to the app).
    final _defaultNum = 26997;

    // get the user token cause we gonna need it.
    final _userToken = await _getUserToken();

    // reference to the user document.
    final _userRef = _db.collection('users').document("$_userToken");

    // reference to the users numbers collection cause we gonna need to
    // read and write data to some of it's documents.
    final _numberRef = _db.collection('user_numbers');

    // the current user number we gonna get it from the user_numbers doc
    // will set it to the default number if user_numbers doc doesn't exist.
    int _currentUserNumber;

    // the number we gonna write in the user data
    // (just the current user number plus 1).
    int _nextUserNumber;

    // Now all the / happens
    await _db.runTransaction((transaction) {
      return transaction.get(_numberRef.document("user_numbers")).then((sfDoc) {
        if (!sfDoc.exists) {
          _currentUserNumber = _defaultNum;
          _nextUserNumber = _currentUserNumber + 1;
          transaction.set(_numberRef.document("user_numbers"),
              {"current_user_number": _nextUserNumber});
        } else {
          _currentUserNumber =
              (sfDoc.data['current_user_number'] ?? _defaultNum);
          _nextUserNumber = _currentUserNumber + 1;
          transaction.update(_numberRef.document("user_numbers"),
              {"current_user_number": _nextUserNumber});
        }
      });
    }).then((f) {
      print("Transaction successfully committed!");
    }).catchError((error) {
      print("Transaction failed: $error");
    });

    await _userRef.setData(
      {
        'userNumber': _nextUserNumber,
      },
      merge: true,
    );

    await _numberRef
        .document("$_nextUserNumber")
        .setData({"user_ref": _userRef});

    return _nextUserNumber;
  }

  ////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////// Helpers Functions /////////////////////////////
  Future<String> _getUserToken() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String userToken = user?.uid;
    if (userToken == null) throw "User Not Logged In";
    return userToken;
  }
}
