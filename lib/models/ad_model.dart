class AdModel {
  String id;
  String image;
  String link;

  // AdModel.fromMap(this.id, Map m) : this.image = m['image'];
  AdModel.fromMap(this.id, Map m) {
    this.image = m['image'];
    this.link = m['link'];
  }
}
