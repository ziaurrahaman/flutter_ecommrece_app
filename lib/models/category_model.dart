class CategoryModel {
  String id;
  String name;
  String picture;

  CategoryModel.fromMap(this.id, Map m)
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
