import 'package:flutter/material.dart';
import 'package:promohunter/providers/auth_provider.dart';
import 'package:promohunter/utils/constants.dart';
import 'package:share/share.dart';

class MyAccountScreen extends StatelessWidget {
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
                          tag: 'card',
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
                                    "Hunter Card",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Calibri',
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    'Points : ${provider.currentUser.points}',
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
                                      labelText: 'Hunter Name',
                                    ),
                                  ),
                                  SizedBox(height: 16.0),
                                  TextFormField(
                                    enabled: false,
                                    initialValue:
                                        '${provider.currentUser.phone}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Calibri',
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w300,
                                    ),
                                    decoration: InputDecoration(
                                      labelText: 'Phone Number',
                                    ),
                                  ),
                                  SizedBox(height: 16.0),
                                  Stack(
                                    children: [
                                      TextFormField(
                                        enabled: false,
                                        initialValue:
                                            '${provider.currentUser.userNumber}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Calibri',
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w300,
                                        ),
                                        decoration: InputDecoration(
                                          labelText: 'User ID',
                                        ),
                                      ),
                                      Positioned(
                                        right: 8.0,
                                        bottom: 16.0,
                                        child: GestureDetector(
                                          onTap: () => Share.share(
                                              '${provider.currentUser.userNumber}'),
                                          child: Image.asset(
                                            'assets/icons/share.png',
                                            height: 24.0,
                                            width: 24.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16.0),
                                  if (provider.currentUser.referralNumber !=
                                      null) ...[
                                    TextFormField(
                                      enabled: false,
                                      initialValue:
                                          '${provider.currentUser.referralNumber}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Calibri',
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w300,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Referral ID',
                                      ),
                                    ),
                                    SizedBox(height: 16.0),
                                  ],
                                  SizedBox(height: 32.0),
                                  Text(
                                    'Achievements',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Calibri',
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 28.0),
                                  ...[
                                    Achievements.SuccessfulReferrals,
                                    Achievements.NoOfDaysAppInstalled,
                                    Achievements.PricesUpdates,
                                    Achievements.PromoHunted,
                                    Achievements.FavoritesAdded,
                                    Achievements.ProductsInList,
                                    Achievements.ProductsViewed,
                                    Achievements.ProductsRequested,
                                  ].map(
                                    (e) => Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 12.0),
                                        child: Text(
                                          '$e : ${provider.currentUser.achievements[e] ?? 0}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Calibri',
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ),
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
