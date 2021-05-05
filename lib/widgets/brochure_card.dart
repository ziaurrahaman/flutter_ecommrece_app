import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:promohunter/models/brochures_model.dart';

class BrochureCard extends StatelessWidget {
  final BrochuresModel brochuresModel;

  const BrochureCard({Key key, @required this.brochuresModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: EdgeInsets.all(4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.25,
              height: MediaQuery.of(context).size.width * 0.25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                      '${brochuresModel.shopModel?.picture}'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${brochuresModel.shopModel?.name}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontFamily: 'Calibri',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Start ${DateFormat.yMMMMd().format(brochuresModel.start)}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'sans-serif',
                      fontSize: 12.0,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    'End : ${DateFormat.yMMMMd().format(brochuresModel.end)}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'sans-serif',
                      fontSize: 12.0,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    '${brochuresModel.end.difference(DateTime.now()).inDays + 1.round()} Days left',
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'sans-serif',
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
