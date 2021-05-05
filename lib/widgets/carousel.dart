import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide FontWeight;

class CarouselWithIndicator extends StatelessWidget {
  final List<String> newImgList;
  final BoxFit fit;
  final double height;

  CarouselWithIndicator(
    this.newImgList, {
    this.fit = BoxFit.contain,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width - 48;
    final double _height = height ?? ((_width / 16) * 9);

    return Container(
      height: _height + 20,
      child: CarouselSlider.builder(
        options: CarouselOptions(
          autoPlay: true,
          enlargeCenterPage: true,
          height: _height,
        ),
        itemCount: newImgList.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            width: _width,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              child: CachedNetworkImage(
                imageUrl: newImgList[index],
                fit: fit,
                alignment: Alignment.center,
                errorWidget: (BuildContext context, _, __) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.image,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Image not found',
                      textAlign: TextAlign.center,
                      textScaleFactor: 1,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  blurRadius: 6,
                  spreadRadius: 0,
                  offset: Offset(0, 3),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
