import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:promohunter/models/category_model.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;

  CategoryCard(this.category);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Stack(
        children: [
          Container(
            height: 120.0,
            width: 120.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: CachedNetworkImageProvider(category.picture),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            right: 0.0,
            left: 0.0,
            child: Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                '${category.name}',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'sans-serif',
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
