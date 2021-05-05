import 'package:barcode/barcode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:promohunter/models/membership_card_model.dart';
import 'package:promohunter/providers/auth_provider.dart';
import 'package:promohunter/providers/home_provider.dart';
import 'package:promohunter/widgets/error_pop_up.dart';
import 'package:promohunter/widgets/loading_screen.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MembershipCardScreen extends StatelessWidget {
  final MembershipCardModel membershipCardModel;

  const MembershipCardScreen({Key key, @required this.membershipCardModel})
      : super(key: key);

  Widget get code {
    if (membershipCardModel.membershipCardType.codeType
        .contains(RegExp('qr', caseSensitive: false))) {
      return QrImage(
        data: membershipCardModel.cardNumber,
        version: QrVersions.auto,
        size: 110,
        gapless: false,
      );
    } else if (membershipCardModel.membershipCardType.codeType
        .contains(RegExp('barcode', caseSensitive: false))) {
      final svg = Barcode.codabar().toSvg(
        membershipCardModel.cardNumber,
        width: 260,
        height: 60,
        drawText: false,
      );
      return SvgPicture.string(svg);
    } else {
      return SizedBox();
    }
  }

  _delete(BuildContext context) async {
    bool delete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        contentPadding: EdgeInsets.all(8.0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.clear,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.error_outline,
                  color: Theme.of(context).accentColor,
                ),
              ],
            ),
            SizedBox(height: 24.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Are you sure you want to delete your membership?",
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 32.0),
            GestureDetector(
              onTap: () => Navigator.pop(context, true),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 12.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Center(
                  child: Text(
                    "YES, Delete",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    if (delete ?? false) {
      try {
        LoadingScreen.show(context);
        await context
            .read<HomeProvider>()
            .deleteMembershipCard(membershipCardModel);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      } catch (e) {
        Navigator.of(context).pop();

        showCupertinoDialog(
          context: context,
          builder: (context) => ErrorPopUp(message: '$e'),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthService>();

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          overflow: Overflow.visible,
          children: [
            Container(
              height: 210.0,
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).primaryColor,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 140.0),
                    Stack(
                      overflow: Overflow.visible,
                      children: [
                        Hero(
                          tag: 'mcard',
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(
                                  vertical: 48.0, horizontal: 16.0),
                              decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 16.0),
                                  Text(
                                    "Membership Card",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Calibri',
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    '${membershipCardModel.membershipCardType?.name}',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontFamily: 'Calibri',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  SizedBox(height: 16.0),
                                  TextFormField(
                                    enabled: false,
                                    initialValue:
                                        '${provider.currentUser.fName} ${provider.currentUser.lName}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Calibri',
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w300,
                                    ),
                                    decoration: InputDecoration(
                                      labelText: 'Card Holder Name',
                                    ),
                                  ),
                                  SizedBox(height: 16.0),
                                  TextFormField(
                                    enabled: false,
                                    initialValue:
                                        '${membershipCardModel.cardNumber}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Calibri',
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w300,
                                    ),
                                    decoration: InputDecoration(
                                      labelText: 'Voucher Number',
                                    ),
                                  ),
                                  SizedBox(height: 32.0),
                                  code,
                                  SizedBox(height: 16.0),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.delete_outline,
                                        color: Colors.white,
                                        size: 32.0,
                                      ),
                                      onPressed: () => _delete(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: -40.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            height: 80.0,
                            width: 80.0,
                            padding: EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.white, width: 1.5),
                            ),
                            child: Image.asset(
                              'assets/icons/ph.png',
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
