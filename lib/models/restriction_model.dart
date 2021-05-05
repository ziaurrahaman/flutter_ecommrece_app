class RestrictionModel {
  String id;
  String name;

  RestrictionModel.fromMap(this.id, Map m) : name = m['name'];

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();

    map['id'] = id;
    map['name'] = name;

    return map;
  }
}
