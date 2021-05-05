import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:promohunter/models/shop_model.dart';
import 'package:promohunter/utils/database_client.dart';

class BrochuresModel {
  String id;
  String shopId;
  String pdf;
  int openCounts;
  DateTime start;
  DateTime end;
  bool show;

  ShopModel shopModel;

  BrochuresModel.fromMap(this.id, Map m) {
    shopId = m['shopId'];
    pdf = m['pdf'];
    openCounts = m['openCounts'];
    start = (m['dateStart'] as Timestamp).toDate();
    end = (m['dateEnd'] as Timestamp).toDate();
    show = !end.difference(DateTime.now()).isNegative;
  }

  Future<void> getShop() async {
    shopModel = await DatabaseClient.instance.getShop(shopId);
  }
}
