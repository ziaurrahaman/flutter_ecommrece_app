import 'package:flutter/material.dart';
import 'package:promohunter/providers/page_provider.dart';
import 'package:promohunter/ui/auth/login_screen.dart';
import 'package:provider/provider.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController _pageController = PageController();
  List<Widget> _pages = [
    OnBoardingScreenOne(),
    OnBoardingScreenTwo(),
    OnBoardingScreenThree(),
    OnBoardingScreenFour(),
  ];

  @override
  Widget build(BuildContext context) {
    final page = context.select((PageProvider p) => p.page);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                PageView(
                  controller: _pageController,
                  onPageChanged: context.watch<PageProvider>().changePage,
                  children: _pages,
                ),
                Positioned(
                  bottom: 24.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _pages
                        .map(
                          (e) => Container(
                            height: 8.0,
                            width: 8.0,
                            margin: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: page == _pages.indexOf(e)
                                  ? Theme.of(context).primaryColor
                                  : Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => page == 3
                ? Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                    settings: RouteSettings(
                      name: LoginScreen.routeName,
                    ),
                  ))
                : _pageController.nextPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.bounceOut,
                  ),
            child: Container(
              height: 48.0,
              width: MediaQuery.of(context).size.width,
              color: page == 0
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).accentColor,
              child: Center(
                child: Text(
                  page == 3 ? 'LOGIN' : 'NEXT',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Calibri',
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnBoardingScreenOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).accentColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Hero(
              tag: 'logo',
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/ph.png',
                    height: 120.0,
                    width: 120.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Promo',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontFamily: 'Calibri',
                          fontSize: 64.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Hunter',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Calibri',
                          fontSize: 20.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
            Text(
              'Welcome',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Calibri',
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Welcome to Promo Hunter. The Promo Hunter app powered by the community.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Calibri',
                fontSize: 20.0,
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

class OnBoardingScreenTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/pig.png',
              height: 180.0,
              width: 180.0,
            ),
            SizedBox(height: 32.0),
            Text(
              'Great Savings',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontFamily: 'Calibri',
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
              child: Text(
                ' Get Promo details about your favourite products and shop smartly',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Calibri',
                  fontSize: 20.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnBoardingScreenThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/crown.png',
              height: 180.0,
              width: 180.0,
            ),
            SizedBox(height: 32.0),
            Text(
              'Great Rewards',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontFamily: 'Calibri',
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
              child: Text(
                'Complete daily activities, get experience and level up for great rewards.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Calibri',
                  fontSize: 20.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnBoardingScreenFour extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/wallet.png',
              height: 180.0,
              width: 180.0,
            ),
            SizedBox(height: 32.0),
            Text(
              'Stay on Budget',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontFamily: 'Calibri',
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 48.0, vertical: 16.0),
              child: Text(
                'Create your own shopping list and control your shopping Budget.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Calibri',
                  fontSize: 20.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
