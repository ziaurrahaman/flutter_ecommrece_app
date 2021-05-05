import 'package:promohunter/models/cart_item_model.dart';

class UserModel {
  String id;
  String fName;
  String lName;
  String phone;
  String email;
  String gender;
  num userNumber;
  num referralNumber;
  List<String> favIds = [];
  List<CartItemModel> cartIds = [];
  Map<String, dynamic> achievements = Map<String, int>();
  num points;

  UserModel();

  UserModel.fromMap(this.id, Map<String, dynamic> m) {
    fName = m['fName'];
    lName = m['lName'];
    phone = '${m['phone'] ?? ''}';
    email = m['email'];
    gender = m['gender'];
    userNumber = m['userNumber'];
    referralNumber = m['referralNumber'];
    if (m['favIds'] != null) {
      (m['favIds'] as List).forEach((i) => favIds.add(i));
    }
    if (m['cartIds'] != null && (m['cartIds'] as List).isNotEmpty) {
      (m['cartIds'] as List)
          .forEach((i) => cartIds.add(CartItemModel.fromMap(i)));
      print(cartIds);
    }
    if (m['achievements'] != null && (m['achievements'] as Map).isNotEmpty) {
      achievements = (m['achievements']);
    }
    points = m['points'] ?? 0;
  }

  Map<String, dynamic> toMap() {
    return {
      'fName': this.fName,
      'lName': this.lName,
      'phone': this.phone,
      'email': this.email,
      'gender': this.gender,
      'userNumber': this.userNumber,
      'referralNumber': this.referralNumber,
      'favIds': this.favIds,
      'cartIds': this.cartIds.map((e) => e.toMap()).toList(),
      'achievements': this.achievements,
      'points': this.points,
    };
  }
}
