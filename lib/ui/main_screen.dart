import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:promohunter/models/category_model.dart';
import 'package:promohunter/models/product_request_model.dart';
import 'package:promohunter/models/shop_model.dart';
import 'package:promohunter/providers/auth_provider.dart';
import 'package:promohunter/providers/home_provider.dart';
import 'package:promohunter/providers/product_provider.dart';
import 'package:promohunter/ui/brochure_screen.dart';
import 'package:promohunter/ui/library_screen.dart';
import 'package:promohunter/ui/my_account_screen.dart';
import 'package:promohunter/ui/product_screen.dart';
import 'package:promohunter/widgets/brochure_card.dart';
import 'package:promohunter/widgets/category_card.dart';
import 'package:promohunter/widgets/drawer.dart';

import 'package:promohunter/widgets/membership_card.dart';
import 'package:promohunter/widgets/product_card.dart';
import 'package:promohunter/widgets/request_pop_up.dart';
import 'package:promohunter/widgets/shop_card.dart';
import 'package:quiver/strings.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MainScreen extends StatelessWidget {
  static const String routeName = 'MAIN_SCREEN';
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _navCategory(BuildContext context, CategoryModel categoryModel) {
    context.read<HomeProvider>().filterLibProducts(categoryModel);
    Navigator.of(context).push(
        CupertinoPageRoute(builder: (BuildContext context) => LibraryScreen()));
  }

  _navDeal(BuildContext context, ShopModel shopModel) {
    context.read<HomeProvider>().filterDealsByShop(shopModel);
    Navigator.of(context).push(CupertinoPageRoute(
        builder: (BuildContext context) => LibraryScreen(
              index: 1,
              shop: shopModel,
            )));
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthService>();
    final deals = context.watch<HomeProvider>().deals;
    final ads = context.select((HomeProvider m) => m.ads);
    final cats = context.watch<HomeProvider>().categories;
    final dealsShops = context.watch<HomeProvider>().dealsShops;
    final userMembershipCards =
        context.watch<HomeProvider>().userMembershipCards;
    final brochures = context.watch<HomeProvider>().brochures;
    final _pageSize = MediaQuery.of(context).size.height;
    final _notifySize = MediaQuery.of(context).padding.top;

    final appBar = AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: Colors.white,
        ),
        onPressed: () => _scaffoldKey.currentState.openDrawer(),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: IconButton(
              icon: Image.asset(
                'assets/icons/search.png',
                color: Colors.white,
                width: 24.0,
                height: 24.0,
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16.0),
                    ),
                  ),
                  enableDrag: true,
                  isDismissible: true,
                  isScrollControlled: true,
                  builder: (BuildContext cts) => SearchFilterSheet(cts, 7),
                );
              }),
        ),
      ],
    );
    final _appBarSize = appBar.preferredSize.height;

    return Scaffold(
      key: _scaffoldKey,
      appBar: appBar,
      drawer: AppDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).accentColor,
          onPressed: () => showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16.0),
              ),
            ),
            enableDrag: true,
            isDismissible: true,
            isScrollControlled: true,
            builder: (BuildContext context) => UpdatePrice(_scaffoldKey),
          ),
          child: Image.asset(
            'assets/icons/ticket.png',
            color: Theme.of(context).primaryColor,
            height: 48.0,
            width: 24.0,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: _pageSize - (_appBarSize + _notifySize + 80),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.0),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MyAccountScreen(),
                    )),
                    child: Hero(
                      tag: 'card',
                      child: Card(
                        margin: EdgeInsets.all(16.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Container(
                          padding: EdgeInsets.only(
                            top: 12.0,
                            left: 16.0,
                          ),
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
                                  Image.asset(
                                    'assets/icons/ph.png',
                                    width: 48.0,
                                    height: 48.0,
                                  ),
                                  SizedBox(width: 36.0),
                                  Column(
                                    children: [
                                      Text(
                                        'Hunter Card',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Calibri',
                                          fontSize: 28.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 16.0),
                                      Text(
                                        '${provider.currentUser.fName} ${provider.currentUser.lName}',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontFamily: 'Calibri',
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 4.0),
                                      Text(
                                        '${provider.currentUser.points ?? 0} Points',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontFamily: 'Calibri',
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (deals.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Promos',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'sans-serif',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).push(
                                CupertinoPageRoute(
                                    builder: (BuildContext context) =>
                                        LibraryScreen(index: 1))),
                            child: Text(
                              'See All',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontFamily: 'sans-serif',
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(width: 12.0),
                          ...deals
                              .map(
                                (p) => GestureDetector(
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ChangeNotifierProvider<
                                              ProductProvider>(
                                        create: (context) => ProductProvider(
                                          p,
                                          context
                                              .read<AuthService>()
                                              .currentUser,
                                        ),
                                        child: ProductScreen(),
                                      ),
                                    ),
                                  ),
                                  child:
                                      ChangeNotifierProvider<ProductProvider>(
                                    create: (context) => ProductProvider(
                                      p,
                                      context.read<AuthService>().currentUser,
                                    ),
                                    child: ProductCard(),
                                  ),
                                ),
                              )
                              .toList(),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.0),
                  ],
                  if (cats.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Categories',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'sans-serif',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(width: 8.0),
                          ...cats
                              .map(
                                (c) => GestureDetector(
                                  onTap: () => _navCategory(context, c),
                                  child: CategoryCard(c),
                                ),
                              )
                              .toList(),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.0),
                  ],
                  if (dealsShops.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Deals by Shop',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'sans-serif',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).push(
                                CupertinoPageRoute(
                                    builder: (BuildContext context) =>
                                        LibraryScreen(
                                          index: 1,
                                        ))),
                            child: Text(
                              'See All',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontFamily: 'sans-serif',
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(width: 10.0),
                          ...dealsShops
                              .map(
                                (s) => GestureDetector(
                                  onTap: () => _navDeal(context, s),
                                  child: ShopCard(
                                    shop: s,
                                    index: dealsShops.indexOf(s),
                                  ),
                                ),
                              )
                              .toList(),
                          SizedBox(width: 10.0),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.0),
                  ],
                  if (userMembershipCards.isNotEmpty) ...[
                    MembershipCardsWidget(),
                  ],
                  if (brochures.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Brochures',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'sans-serif',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).push(
                                CupertinoPageRoute(
                                    builder: (BuildContext context) =>
                                        LibraryScreen(type: 1))),
                            child: Text(
                              'See All',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontFamily: 'sans-serif',
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(width: 10.0),
                          ...brochures
                              .map(
                                (c) => GestureDetector(
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          BrochureScreen(brochuresModel: c),
                                    ),
                                  ),
                                  child: c.show
                                      ? BrochureCard(brochuresModel: c)
                                      : SizedBox(),
                                ),
                              )
                              .toList(),
                          SizedBox(width: 10.0),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.0),
                  ],
                ],
              ),
            ),
          ),
          if (ads.isNotEmpty) ...[
            Container(
              height: 80,
              width: MediaQuery.of(context).size.width,
              child: CarouselSlider(
                options: CarouselOptions(
                    autoPlayInterval: Duration(seconds: 5),
                    viewportFraction: 1.0,
                    autoPlay: true,
                    aspectRatio: 2,
                    enlargeCenterPage: true),
                items: ads.map((i) {
                  return GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => AddScreen(link: i.link)),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 80.0,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(0),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.1),
                            blurRadius: 0,
                            spreadRadius: 0,
                            offset: Offset(0, 3),
                          ),
                        ],
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(i.image),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class MembershipCardsWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

class _CarouselWithIndicatorState extends State<MembershipCardsWidget> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final userMembershipCards =
        context.watch<HomeProvider>().userMembershipCards;

    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'My Discount Cards',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'sans-serif',
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).push(CupertinoPageRoute(
                  builder: (BuildContext context) => LibraryScreen(
                        type: 1,
                        index: 1,
                      ))),
              child: Text(
                'See All',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontFamily: 'sans-serif',
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        ),
      ),
      CarouselSlider(
        options: CarouselOptions(
          height: 210.0,
          viewportFraction: 1.0,
          aspectRatio: 2.0,
          enableInfiniteScroll: false,
          onPageChanged: (index, reason) {
            setState(() {
              _current = index;
            });
          },
        ),
        items: userMembershipCards.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return MembershipCard(membershipCardModel: i);
            },
          );
        }).toList(),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: userMembershipCards.map((url) {
          int index = userMembershipCards.indexOf(url);
          return Container(
            width: 8.0,
            height: 8.0,
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _current == index
                  ? Color.fromRGBO(0, 0, 0, 0.9)
                  : Color.fromRGBO(0, 0, 0, 0.4),
            ),
          );
        }).toList(),
      ),
      SizedBox(height: 16.0),
    ]);
  }
}

class UpdatePrice extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  UpdatePrice(this.scaffoldKey);

  @override
  _UpdatePriceState createState() => _UpdatePriceState();
}

class _UpdatePriceState extends State<UpdatePrice> {
  final _controller = TextEditingController();
  final _price = TextEditingController();
  bool multipleSelect = false;
  bool _stageTwo = false;

  _updatePrice() async {
    if (isBlank(_price.text)) return;

    await context
        .read<HomeProvider>()
        .updatePrice(_price.text, context.read<AuthService>().currentUser);
    Navigator.of(context).pop();
    widget.scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('New Price Submitted'),
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(8.0),
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.clear,
                    size: 32.0,
                    color: Theme.of(context).accentColor,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Spacer(),
                Text(
                  'Update a Price',
                  style: TextStyle(
                    color: Color(0xFF808080),
                    fontFamily: 'sans-serif',
                    fontSize: 20.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Image.asset(
                    'assets/icons/ticket.png',
                    height: 32.0,
                    width: 32.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            if (_stageTwo) ...[
              Row(
                children: [
                  Text(
                    'Select Shop : ',
                    style: TextStyle(
                      color: Color(0xFF808080),
                      fontFamily: 'sans-serif',
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    provider.shops == null
                        ? 'Shop Name'
                        : "${provider.selectedShop?.name ?? ''}",
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontFamily: 'sans-serif',
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: provider.shops
                      .map(
                        (c) => GestureDetector(
                          onTap: () => provider.selectShop(c),
                          child: Container(
                            height: 100.0,
                            width: 100.0,
                            margin: EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              image: DecorationImage(
                                image:
                                    CachedNetworkImageProvider('${c.picture}'),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              SizedBox(height: 16.0),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Current promo price',
                  style: TextStyle(
                    color: Color(0xFFb3b3b3),
                    fontFamily: 'sans-serif',
                    fontSize: 18.0,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(4.0),
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  color: Color(0xFFf2f2f2),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                    '${provider.selectedProductAlternatePrice?.price ?? ''}'),
              ),
              SizedBox(height: 16.0),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'New Price',
                  style: TextStyle(
                    color: Color(0xFFb3b3b3),
                    fontFamily: 'sans-serif',
                    fontSize: 18.0,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(4.0),
                padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  color: Color(0xFFf2f2f2),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextField(
                  controller: _price,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontFamily: 'sans-serif',
                    fontSize: 18.0,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(0.0),
                    hintText: 'Set Price',
                    hintStyle: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontFamily: 'sans-serif',
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: () => _updatePrice(),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(4.0),
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Text(
                      'Update',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'sans-serif',
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ),
            ] else if (multipleSelect) ...[
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Select Product',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontFamily: 'sans-serif',
                    fontSize: 18.0,
                  ),
                ),
              ),
              ...provider.resultProducts
                  .map((e) => GestureDetector(
                        onTap: () {
                          if (_controller.text.isEmpty) return;
                          final provider = context.read<HomeProvider>();

                          provider.singleSelectedProduct = e;

                          setState(() => _stageTwo = true);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                e.brandModel?.name ?? '',
                                style: TextStyle(
                                  color: provider.selectedProducts
                                          .where(
                                              (element) => element.id == e.id)
                                          .isEmpty
                                      ? Color(0xFFb3b3b3)
                                      : Theme.of(context).accentColor,
                                  fontFamily: 'sans-serif',
                                  fontSize: 12.0,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                e.name,
                                style: TextStyle(
                                  color: provider.selectedProducts
                                          .where(
                                              (element) => element.id == e.id)
                                          .isEmpty
                                      ? Color(0xFFb3b3b3)
                                      : Theme.of(context).accentColor,
                                  fontFamily: 'sans-serif',
                                  fontSize: 18.0,
                                ),
                              ),
                              SizedBox(height: 8.0),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
              SizedBox(height: 16.0),
            ] else ...[
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Select Product',
                  style: TextStyle(
                    color: Color(0xFFb3b3b3),
                    fontFamily: 'sans-serif',
                    fontSize: 18.0,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(4.0),
                padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  color: Color(0xFFf2f2f2),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontFamily: 'sans-serif',
                          fontSize: 18.0,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(0.0),
                          hintText: 'Select Product',
                          hintStyle: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontFamily: 'sans-serif',
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final res =
                            await provider.selectProductByQBarcode(context);

                        if (!res) return;

                        if (provider.singleSelectedProduct != null) {
                          setState(() => _stageTwo = true);
                        } else if (provider.singleSelectedProduct == null &&
                            provider.resultProducts.isEmpty) {
                          final r = await showCupertinoDialog(
                            context: context,
                            builder: (context) => RequestProductPopUp(),
                          );
                          if (r ?? false) {
                            Navigator.pop(context);
                            showModalBottomSheet(
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16.0),
                                ),
                              ),
                              enableDrag: true,
                              isDismissible: true,
                              isScrollControlled: true,
                              builder: (BuildContext context) =>
                                  RequestProductSheet(widget.scaffoldKey),
                            );
                          }
                        } else {
                          multipleSelect = true;
                          if (mounted) setState(() {});
                        }
                      },
                      child: Image.asset(
                        'assets/icons/badge.png',
                        height: 32.0,
                        width: 32.0,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: () async {
                  if (_controller.text.isEmpty) return;
                  final provider = context.read<HomeProvider>();

                  provider.selectProduct(context, _controller.text);

                  if (provider.singleSelectedProduct != null) {
                    setState(() => _stageTwo = true);
                  } else if (provider.singleSelectedProduct == null &&
                      provider.resultProducts.isEmpty) {
                    final r = await showCupertinoDialog(
                      context: context,
                      builder: (context) => RequestProductPopUp(),
                    );
                    if (r ?? false) {
                      Navigator.pop(context);
                      showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16.0),
                          ),
                        ),
                        enableDrag: true,
                        isDismissible: true,
                        isScrollControlled: true,
                        builder: (BuildContext context) =>
                            RequestProductSheet(widget.scaffoldKey),
                      );
                    }
                  } else {
                    multipleSelect = true;
                    if (mounted) setState(() {});
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(4.0),
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Text(
                      'Search',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'sans-serif',
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class PromoHunterSheet extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  PromoHunterSheet(this.scaffoldKey);

  @override
  _PromoHunterSheetState createState() => _PromoHunterSheetState();
}

class _PromoHunterSheetState extends State<PromoHunterSheet> {
  final _controller = TextEditingController();
  bool multipleSelect = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();

    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.clear,
                  size: 32.0,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Spacer(),
              Text(
                'Promo Hunt',
                style: TextStyle(
                  color: Color(0xFFb3b3b3),
                  fontFamily: 'sans-serif',
                  fontSize: 20.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Image.asset(
                  'assets/icons/ph.png',
                  color: Color(0xFFb3b3b3),
                  height: 32.0,
                  width: 32.0,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          if (multipleSelect) ...[
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Select Product',
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontFamily: 'sans-serif',
                  fontSize: 18.0,
                ),
              ),
            ),
            ...provider.resultProducts
                .map((e) => GestureDetector(
                      onTap: () {
                        final provider = context.read<HomeProvider>();

                        if (provider.checkPromo(context, e,
                            context.read<AuthService>().currentUser))
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ChangeNotifierProvider<ProductProvider>(
                                create: (context) => ProductProvider(
                                  provider.singleSelectedProduct,
                                  context.read<AuthService>().currentUser,
                                ),
                                child: ProductScreen(),
                              ),
                            ),
                          );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.brandModel?.name ?? '',
                              style: TextStyle(
                                color: provider.selectedProducts
                                        .where((element) => element.id == e.id)
                                        .isEmpty
                                    ? Color(0xFFb3b3b3)
                                    : Theme.of(context).accentColor,
                                fontFamily: 'sans-serif',
                                fontSize: 12.0,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              e.name,
                              style: TextStyle(
                                color: provider.selectedProducts
                                        .where((element) => element.id == e.id)
                                        .isEmpty
                                    ? Color(0xFFb3b3b3)
                                    : Theme.of(context).accentColor,
                                fontFamily: 'sans-serif',
                                fontSize: 18.0,
                              ),
                            ),
                            SizedBox(height: 8.0),
                          ],
                        ),
                      ),
                    ))
                .toList(),
            SizedBox(height: 16.0),
          ] else ...[
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Select Product',
                style: TextStyle(
                  color: Color(0xFFb3b3b3),
                  fontFamily: 'sans-serif',
                  fontSize: 18.0,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(4.0),
              padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
              decoration: BoxDecoration(
                color: Color(0xFFf2f2f2),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontFamily: 'sans-serif',
                        fontSize: 18.0,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(0.0),
                        hintText: 'Select Product',
                        hintStyle: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontFamily: 'sans-serif',
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final res =
                          await provider.selectProductByQBarcode(context);

                      if (!res) return;

                      if (provider.singleSelectedProduct != null) {
                        if (provider.checkPromo(
                            context,
                            provider.singleSelectedProduct,
                            context.read<AuthService>().currentUser))
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ChangeNotifierProvider<ProductProvider>(
                                create: (context) => ProductProvider(
                                  provider.singleSelectedProduct,
                                  context.read<AuthService>().currentUser,
                                ),
                                child: ProductScreen(),
                              ),
                            ),
                          );
                      } else if (provider.singleSelectedProduct == null &&
                          provider.resultProducts.isEmpty) {
                        final r = await showCupertinoDialog(
                          context: context,
                          builder: (context) => RequestProductPopUp(),
                        );
                        if (r ?? false) {
                          Navigator.pop(context);
                          showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16.0),
                              ),
                            ),
                            enableDrag: true,
                            isDismissible: true,
                            isScrollControlled: true,
                            builder: (BuildContext context) =>
                                RequestProductSheet(widget.scaffoldKey),
                          );
                        }
                      } else {
                        multipleSelect = true;
                        if (mounted) setState(() {});
                      }
                    },
                    child: Image.asset(
                      'assets/icons/badge.png',
                      height: 32.0,
                      width: 32.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: () async {
                if (_controller.text.isEmpty) return;
                final provider = context.read<HomeProvider>();

                provider.selectProduct(context, _controller.text);

                if (provider.singleSelectedProduct != null) {
                  if (provider.checkPromo(
                      context,
                      provider.singleSelectedProduct,
                      context.read<AuthService>().currentUser))
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ChangeNotifierProvider<ProductProvider>(
                          create: (context) => ProductProvider(
                            provider.singleSelectedProduct,
                            context.read<AuthService>().currentUser,
                          ),
                          child: ProductScreen(),
                        ),
                      ),
                    );
                } else if (provider.singleSelectedProduct == null &&
                    provider.resultProducts.isEmpty) {
                  final r = await showCupertinoDialog(
                    context: context,
                    builder: (context) => RequestProductPopUp(),
                  );
                  if (r ?? false) {
                    Navigator.pop(context);
                    showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16.0),
                        ),
                      ),
                      enableDrag: true,
                      isDismissible: true,
                      isScrollControlled: true,
                      builder: (BuildContext context) =>
                          RequestProductSheet(widget.scaffoldKey),
                    );
                  }
                } else {
                  multipleSelect = true;
                  if (mounted) setState(() {});
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(4.0),
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Text(
                    'Check',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'sans-serif',
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class AddToShoppingListSheet extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  AddToShoppingListSheet(this.scaffoldKey);

  @override
  _AddToShoppingListSheetState createState() => _AddToShoppingListSheetState();
}

class _AddToShoppingListSheetState extends State<AddToShoppingListSheet> {
  final _controller = TextEditingController();
  bool multipleSelect = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();

    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.clear,
                  size: 32.0,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Spacer(),
              Text(
                'Add to Shopping List',
                style: TextStyle(
                  color: Color(0xFFb3b3b3),
                  fontFamily: 'sans-serif',
                  fontSize: 20.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Image.asset(
                  'assets/icons/small-cart.png',
                  color: Color(0xFFb3b3b3),
                  height: 32.0,
                  width: 32.0,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          if (multipleSelect) ...[
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Select Product',
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontFamily: 'sans-serif',
                  fontSize: 18.0,
                ),
              ),
            ),
            ...provider.resultProducts
                .map((e) => GestureDetector(
                      onTap: () => provider.toSelected(e),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.brandModel?.name ?? '',
                              style: TextStyle(
                                color: provider.selectedProducts
                                        .where((element) => element.id == e.id)
                                        .isEmpty
                                    ? Color(0xFFb3b3b3)
                                    : Theme.of(context).accentColor,
                                fontFamily: 'sans-serif',
                                fontSize: 12.0,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              e.name,
                              style: TextStyle(
                                color: provider.selectedProducts
                                        .where((element) => element.id == e.id)
                                        .isEmpty
                                    ? Color(0xFFb3b3b3)
                                    : Theme.of(context).accentColor,
                                fontFamily: 'sans-serif',
                                fontSize: 18.0,
                              ),
                            ),
                            SizedBox(height: 8.0),
                          ],
                        ),
                      ),
                    ))
                .toList(),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                provider
                    .addProductToCart(context.read<AuthService>().currentUser);
                Navigator.of(context).pop();
                widget.scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text('Added Successfully'),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 2),
                ));
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(4.0),
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Text(
                    'Add to list',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'sans-serif',
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ),
          ] else ...[
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Select Product',
                style: TextStyle(
                  color: Color(0xFFb3b3b3),
                  fontFamily: 'sans-serif',
                  fontSize: 18.0,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(4.0),
              padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
              decoration: BoxDecoration(
                color: Color(0xFFf2f2f2),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontFamily: 'sans-serif',
                        fontSize: 18.0,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.all(0.0),
                        hintText: 'Select Product',
                        hintStyle: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontFamily: 'sans-serif',
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final res =
                          await provider.selectProductByQBarcode(context);

                      if (!res) return;

                      if (provider.singleSelectedProduct != null) {
                        provider.addProductToCart(
                            context.read<AuthService>().currentUser);
                        Navigator.of(context).pop();
                        widget.scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text('Added Successfully'),
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 2),
                        ));
                      } else if (provider.singleSelectedProduct == null &&
                          provider.resultProducts.isEmpty) {
                        final r = await showCupertinoDialog(
                          context: context,
                          builder: (context) => RequestProductPopUp(),
                        );
                        if (r ?? false) {
                          Navigator.pop(context);
                          showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16.0),
                              ),
                            ),
                            enableDrag: true,
                            isDismissible: true,
                            isScrollControlled: true,
                            builder: (BuildContext context) =>
                                RequestProductSheet(widget.scaffoldKey),
                          );
                        }
                      } else {
                        multipleSelect = true;
                        if (mounted) setState(() {});
                      }
                    },
                    child: Image.asset(
                      'assets/icons/badge.png',
                      height: 32.0,
                      width: 32.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: () async {
                if (_controller.text.isEmpty) return;
                provider.selectProduct(context, _controller.text);

                if (provider.singleSelectedProduct != null) {
                  provider.addProductToCart(
                      context.read<AuthService>().currentUser);
                  print(provider.singleSelectedProduct.name);
                  Navigator.of(context).pop();
                  widget.scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text('Added Successfully'),
                    behavior: SnackBarBehavior.floating,
                    duration: Duration(seconds: 2),
                  ));
                } else if (provider.singleSelectedProduct == null &&
                    provider.resultProducts.isEmpty) {
                  final r = await showCupertinoDialog(
                    context: context,
                    builder: (context) => RequestProductPopUp(),
                  );
                  if (r ?? false) {
                    Navigator.pop(context);
                    showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16.0),
                        ),
                      ),
                      enableDrag: true,
                      isDismissible: true,
                      isScrollControlled: true,
                      builder: (BuildContext context) =>
                          RequestProductSheet(widget.scaffoldKey),
                    );
                  }
                } else {
                  multipleSelect = true;
                  if (mounted) setState(() {});
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(4.0),
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Text(
                    'Search',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'sans-serif',
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class RequestProductSheet extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  RequestProductSheet(this.scaffoldKey);

  @override
  _RequestProductSheetState createState() => _RequestProductSheetState();
}

class _RequestProductSheetState extends State<RequestProductSheet> {
  final _brand = TextEditingController();
  final _product = TextEditingController();

  @override
  void dispose() {
    _brand.dispose();
    _product.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();

    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.clear,
                  size: 32.0,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Spacer(),
              Text(
                'Add a Product',
                style: TextStyle(
                  color: Color(0xFFb3b3b3),
                  fontFamily: 'sans-serif',
                  fontSize: 20.0,
                ),
              ),
              SizedBox(width: 24.0),
            ],
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Brand Name',
              style: TextStyle(
                color: Color(0xFFb3b3b3),
                fontFamily: 'sans-serif',
                fontSize: 18.0,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: Color(0xFFf2f2f2),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: TextField(
              controller: _brand,
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontFamily: 'sans-serif',
                fontSize: 18.0,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(0.0),
                hintText: 'Brand Name',
                hintStyle: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontFamily: 'sans-serif',
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Product Name',
              style: TextStyle(
                color: Color(0xFFb3b3b3),
                fontFamily: 'sans-serif',
                fontSize: 18.0,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(4.0),
            padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: Color(0xFFf2f2f2),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: TextField(
              controller: _product,
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontFamily: 'sans-serif',
                fontSize: 18.0,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(0.0),
                hintText: 'Product Name',
                hintStyle: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontFamily: 'sans-serif',
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          GestureDetector(
            onTap: () async {
              if (_product.text.isEmpty || _brand.text.isEmpty) return;

              ProductRequestModel request =
                  ProductRequestModel(_brand.text, _product.text);

              await provider.sendProductRequest(
                  request, context.read<AuthService>().currentUser);

              Navigator.of(context).pop();

              widget.scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text('Request Sent Successfully'),
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 2),
              ));
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(4.0),
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'sans-serif',
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0,
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

class AddScreen extends StatelessWidget {
  final String link;
  AddScreen({this.link});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        initialUrl: link,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
