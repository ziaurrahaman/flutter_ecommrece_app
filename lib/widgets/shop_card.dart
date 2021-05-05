import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:promohunter/models/shop_model.dart';

class ShopCard extends StatelessWidget {
  final ShopModel shop;
  final int index;

  const ShopCard({Key key, @required this.shop, @required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      color: index.isOdd
          ? Theme.of(context).primaryColor
          : Theme.of(context).accentColor,
      child: Container(
        height: 130.0,
        width: 130.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          image: DecorationImage(
            image: CachedNetworkImageProvider(shop.picture),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
