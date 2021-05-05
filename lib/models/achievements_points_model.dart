import 'package:promohunter/utils/constants.dart';

class PointsPerAchievementsModel {
  num successfulReferrals;
  num noOfDaysAppInstalled;
  num pricesUpdates;
  num promoHunted;
  num favoritesAdded;
  num productsInList;
  num productsViewed;
  num productsRequested;

  PointsPerAchievementsModel.fromMap(Map m)
      : successfulReferrals = m[Achievements.SuccessfulReferrals] ?? 15,
        noOfDaysAppInstalled = m[Achievements.NoOfDaysAppInstalled] ?? 2,
        pricesUpdates = m[Achievements.PricesUpdates] ?? 15,
        promoHunted = m[Achievements.PromoHunted] ?? 2,
        favoritesAdded = m[Achievements.FavoritesAdded] ?? 3,
        productsInList = m[Achievements.ProductsInList] ?? 3,
        productsViewed = m[Achievements.ProductsViewed] ?? 3,
        productsRequested = m[Achievements.ProductsRequested] ?? 5;
}
