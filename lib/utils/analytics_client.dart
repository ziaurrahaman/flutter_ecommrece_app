import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/foundation.dart';

class Analytics {
  Analytics._();

  static final instance = Analytics._();
  static final _analytics = FirebaseAnalytics();
  static final _observer = FirebaseAnalyticsObserver(analytics: _analytics);

  FirebaseAnalyticsObserver get observer => _observer;

  Future<void> logLogin({String loginMethod}) async {
    await _analytics.logLogin(loginMethod: loginMethod);
  }

  Future<void> logSignUp({String signUpMethod}) async {
    await _analytics.logSignUp(signUpMethod: signUpMethod);
  }

  Future<void> logAppOpen() async {
    await _analytics.logAppOpen();
  }

  Future<void> logEvent({@required String name}) async {
    await _analytics.logEvent(name: name);
  }

  Future<void> logScreen({@required String name}) async {
    await _analytics.setCurrentScreen(screenName: name);
  }

//  Future<void> logAddToWishList({@required ProductModel product}) async {
//    await _analytics.logAddToWishlist(
//      itemId: '${product.id}',
//      quantity: 1,
//      itemCategory: '${product.category?.id}',
//      itemName: product.title,
//      currency: 'L.E',
//      itemLocationId: 'Egypt',
//      price: product.price,
//    );
//  }
//
//  Future<void> logAddToCart(
//      {@required ProductModel product, int quantity}) async {
//    await _analytics.logAddToCart(
//      itemId: '${product.id}',
//      quantity: quantity,
//      itemCategory: '${product.category?.id}',
//      itemName: product.title,
//      currency: 'SAR',
//      itemLocationId: 'Saudi Arabia',
//      price: product.price,
//    );
//  }
//
//  Future<void> logRemoveFromCart({@required CartItem item}) async {
//    await _analytics.logRemoveFromCart(
//      itemId: '${item.product.id}',
//      quantity: 1,
//      itemCategory: '${item.product.category?.id}',
//      itemName: item.product.title,
//      currency: 'SAR',
//      itemLocationId: 'Saudi Arabia',
//      price: item.product.price,
//    );
//  }

  Future<void> logSearch({@required String text}) async {
    await _analytics.logSearch(searchTerm: text);
  }

  Future<void> setUserProperty({
    @required String name,
    @required String value,
  }) async {
    await _analytics.setUserProperty(name: name, value: value);
  }

  Future<void> setUserId({@required String userId}) async {
    await _analytics.setUserId('$userId');
  }
//
//  Future<void> logShareItem({@required ProductModel product}) async {
//    await _analytics.logShare(
//      contentType: 'Item',
//      itemId: '${product.id}',
//      method: 'Unknown',
//    );
//  }
//
//  Future<void> logViewItem({@required ProductModel product}) async {
//    await _analytics.logViewItem(
//      itemCategory: '${product.category?.id}',
//      itemId: '${product.id}',
//      itemName: product.title,
//      price: product.price,
//      currency: 'SAR',
//    );
//  }

  Future<void> logPurchase({
    @required double totalCost,
    @required int transactionId,
    @required String coupon,
    @required String city,
    @required String town,
  }) async {
    await _analytics.logEcommercePurchase(
      currency: 'R.S',
      value: totalCost,
      transactionId: '$transactionId',
      tax: 0,
      shipping: 0,
      coupon: coupon,
      location: '${city}_$town',
    );
  }

  Future<void> logSetCheckoutOption({
    @required String option,
    @required int step,
  }) async {
    await _analytics.logSetCheckoutOption(
      checkoutOption: option,
      checkoutStep: step,
    );
  }

  Future<void> resetAnalytics() async {
    await _analytics.resetAnalyticsData();
  }
}
