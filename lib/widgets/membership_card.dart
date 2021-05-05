import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:promohunter/models/membership_card_model.dart';
import 'package:promohunter/providers/auth_provider.dart';
import 'package:promohunter/ui/membership_card_screen.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MembershipCard extends StatelessWidget {
  final MembershipCardModel membershipCardModel;

  const MembershipCard({Key key, @required this.membershipCardModel})
      : super(key: key);

  Widget get code {
    if (membershipCardModel.membershipCardType.codeType
        .contains(RegExp('qr', caseSensitive: false))) {
      return QrImage(
        data: membershipCardModel.cardNumber,
        version: QrVersions.auto,
        size: 80,
        gapless: false,
      );
    } else if (membershipCardModel.membershipCardType.codeType
        .contains(RegExp('barcode', caseSensitive: false))) {
      final svg = Barcode.codabar().toSvg(
        membershipCardModel.cardNumber,
        width: 200,
        height: 50,
        drawText: false,
      );
      return SvgPicture.string(svg);
    } else {
      return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MembershipCardScreen(
            membershipCardModel: membershipCardModel,
          ),
        ),
      ),
      child: Hero(
        tag: 'mcard',
        child: Card(
          color: Theme.of(context).accentColor,
          margin: EdgeInsets.symmetric(horizontal: 8.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: Container(
            height: 220.0,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        'MEMBERSHIP CARD',
                        // '${membershipCardModel.membershipCardType.name}',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'sans-serif',
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    // 'MEMBERSHIP CARD',
                    '${membershipCardModel.membershipCardType.name}',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'sans-serif',
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    '${context.select((AuthService a) => '${a.currentUser.fName} ${a.currentUser.lName}')}',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'sans-serif',
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Spacer(),
                Align(
                  alignment: Alignment.centerRight,
                  child: code,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
