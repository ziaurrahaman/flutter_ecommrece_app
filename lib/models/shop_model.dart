class ShopModel {
  String id;
  String name;
  String picture;

  ShopModel(this.id, this.name, this.picture);

  ShopModel.fromMap(this.id, Map m)
      : name = m['name'],
        picture = m['picture'];

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();

    map['id'] = id;
    map['name'] = name;
    map['picture'] = picture;

    return map;
  }
}
