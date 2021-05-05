class MembershipCardModel {
  String id;
  MembershipCardType membershipCardType;
  String cardNumber;

  MembershipCardModel();

  MembershipCardModel.fromMap(this.id, Map m)
      : membershipCardType =
            MembershipCardType.fromMap(m['membershipCardType']),
        cardNumber = m['cardNumber'];

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();

    map['membershipCardType'] = membershipCardType.toMap();
    map['cardNumber'] = cardNumber;

    return map;
  }
}

class MembershipCardType {
  String codeType;
  String name;

  MembershipCardType.fromMap(Map m)
      : codeType = m['codeType'],
        name = m['name'];

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();

    map['codeType'] = codeType;
    map['name'] = name;

    return map;
  }
}
