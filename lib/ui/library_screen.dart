import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:promohunter/models/membership_card_model.dart';
import 'package:promohunter/models/shop_model.dart';
import 'package:promohunter/providers/auth_provider.dart';
import 'package:promohunter/providers/home_provider.dart';
import 'package:promohunter/providers/product_provider.dart';
import 'package:promohunter/ui/brochure_screen.dart';

import 'package:promohunter/ui/product_screen.dart';
import 'package:promohunter/widgets/brochure_card.dart';
import 'package:promohunter/widgets/error_pop_up.dart';
import 'package:promohunter/widgets/loading_screen.dart';
import 'package:promohunter/widgets/membership_card.dart';
import 'package:promohunter/widgets/product_card.dart';
import 'package:promohunter/widgets/shopping_item_card.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LibraryScreen extends StatefulWidget {
  final int index;
  final int type;
  final ShopModel shop;

  const LibraryScreen({Key key, this.index = 0, this.type = 0, this.shop})
      : super(key: key);

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with TickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  @override
  Widget build(BuildContext context) {
    final ads = context.select((HomeProvider m) => m.ads);

    return ChangeNotifierProvider(
      create: (_) => TabIndexProvider(
        TabController(
          length: widget.type == 1 ? 2 : 4,
          vsync: this,
          initialIndex: widget.index,
        ),
        widget.type,
      ),
      builder: (ctx, child) => WillPopScope(
        onWillPop: () async {
          final provider = context.read<HomeProvider>();

          if (!provider.canPop) {
            provider.resetLists();
            return provider.toggleCanPop();
          } else {
            return true;
          }
        },
        child: Scaffold(
          key: _scaffoldKey,
          body: SafeArea(
            child: Column(
              children: [
                PreferredSize(
                  preferredSize: Size(MediaQuery.of(context).size.width, 100.0),
                  child: _TabBarHeader(),
                ),
                Expanded(
                  child: _TabBarBody(widget.shop),
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
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.1),
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
          ),
          floatingActionButton: widget.type == 1
              ? ctx.select((TabIndexProvider t) => t.index) == 0
                  ? null
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: FloatingActionButton(
                        backgroundColor: Theme.of(context).accentColor,
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          await context
                              .read<HomeProvider>()
                              .getMembershipCardType();
                          return showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16.0),
                              ),
                            ),
                            enableDrag: true,
                            isDismissible: true,
                            isScrollControlled: true,
                            builder: (BuildContext cts) => AddCardSheet(cts),
                          );
                        },
                      ),
                    )
              : Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: FloatingActionButton(
                    backgroundColor: Theme.of(context).accentColor,
                    child: Image.asset(
                      'assets/icons/search.png',
                      height: 22.0,
                      width: 22.0,
                    ),
                    onPressed: () => showModalBottomSheet(
                      backgroundColor: Colors.white,
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16.0),
                        ),
                      ),
                      enableDrag: true,
                      isDismissible: true,
                      isScrollControlled: true,
                      builder: (BuildContext cts) =>
                          SearchFilterSheet(context, 9),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class _TabBarHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _provider = context.watch<TabIndexProvider>();

    return Material(
      elevation: 3.0,
      color: Theme.of(context).accentColor,
      child: TabBar(
        controller: _provider.tabController,
        indicatorColor: Theme.of(context).primaryColor,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white,
        labelStyle: TextStyle(
          fontFamily: 'Calibri',
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
          color: Colors.white,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Calibri',
          fontSize: 16.0,
          color: Colors.white,
        ),
        tabs: (_provider.type == 1)
            ? [
                Tab(
                  text: 'Brochures',
                ),
                Tab(
                  text: 'Membership Cards',
                ),
              ]
            : [
                Tab(
                  text: 'Catalog',
                ),
                Tab(
                  text: 'Promo',
                ),
                Tab(
                  text: 'Favourites',
                ),
                Tab(
                  text: 'Shopping List',
                ),
              ],
      ),
    );
  }
}

class _TabBarBody extends StatelessWidget {
  final ShopModel shopModel;
  const _TabBarBody(this.shopModel);
  @override
  Widget build(BuildContext context) {
    final _controller = context.select((TabIndexProvider m) => m.tabController);
    final _type = context.select((TabIndexProvider m) => m.type);

    return TabBarView(
      controller: _controller,
      children: _type == 1
          ? [
              BrochuresTab(),
              MemberCardsTab(),
            ]
          : [
              CatalogTab(),
              PromoTab(shopModel),
              FavTab(),
              ShoppingListTab(),
            ],
    );
  }
}

class CatalogTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final products = context.watch<HomeProvider>().filteredProducts;
    final devieceSize = MediaQuery.of(context).size;

    return products.isEmpty
        ? Center(
            child: Text(
              'No Products Found',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontFamily: 'Calibri',
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : GridView.builder(
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: (devieceSize.height > 680) ? 0.8272 : 0.775),
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: (devieceSize.height > 680) ? 9 : 4.0),
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ChangeNotifierProvider<ProductProvider>(
                      create: (context) => ProductProvider(
                        products[index],
                        context.read<AuthService>().currentUser,
                      ),
                      child: ProductScreen(),
                    ),
                  ),
                ),
                child: ChangeNotifierProvider<ProductProvider>(
                  create: (context) => ProductProvider(
                    products[index],
                    context.read<AuthService>().currentUser,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: ProductCard(isExpand: true),
                  ),
                ),
              ),
            ),
          );
  }
}

class PromoTab extends StatelessWidget {
  final ShopModel shopModel;
  const PromoTab(this.shopModel);
  @override
  Widget build(BuildContext context) {
    final deals = context.watch<HomeProvider>().filteredDeals;
    final devieceSize = MediaQuery.of(context).size;

    return deals.isEmpty
        ? Center(
            child: Text(
              'No Products Found',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontFamily: 'Calibri',
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : GridView.builder(
            itemCount: deals.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: (devieceSize.height > 680) ? 0.8272 : 0.775),
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: (devieceSize.height > 680) ? 9 : 4.0),
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ChangeNotifierProvider<ProductProvider>(
                      create: (context) => ProductProvider(
                        deals[index],
                        context.read<AuthService>().currentUser,
                      ),
                      child: ProductScreen(
                        shopModel: shopModel,
                      ),
                    ),
                  ),
                ),
                child: ChangeNotifierProvider<ProductProvider>(
                  create: (context) => ProductProvider(
                    deals[index],
                    context.read<AuthService>().currentUser,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: ProductCard(
                      isExpand: true,
                      shopModel: shopModel,
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}

class BrochuresTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final brochures = context.watch<HomeProvider>().brochures;

    return brochures.isEmpty
        ? Center(
            child: Text(
              'No Brochures Found',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontFamily: 'Calibri',
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : ListView.builder(
            itemCount: brochures.length,
            itemBuilder: (context, index) => brochures[index].show
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              BrochureScreen(brochuresModel: brochures[index]),
                        ),
                      ),
                      child: BrochureCard(brochuresModel: brochures[index]),
                    ),
                  )
                : SizedBox(),
          );
  }
}

class MemberCardsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cards = context.watch<HomeProvider>().userMembershipCards;

    return cards.isEmpty
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "You don't currently have any cards.",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontFamily: 'Calibri',
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        : ListView.builder(
            itemCount: cards.length,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: GestureDetector(
                child: MembershipCard(membershipCardModel: cards[index]),
              ),
            ),
          );
  }
}

class FavTab extends StatefulWidget {
  @override
  _FavTabState createState() => _FavTabState();
}

class _FavTabState extends State<FavTab> {
  @override
  void initState() {
    super.initState();
    _initData();
  }

  _initData() async {
    await context.read<HomeProvider>().getFav(
          context.read<AuthService>().currentUser.favIds,
        );
  }

  @override
  Widget build(BuildContext context) {
    final fav = context.watch<HomeProvider>().filteredFav;
    final devieceSize = MediaQuery.of(context).size;

    return fav.isEmpty
        ? Center(
            child: Text(
              'No Products Found',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontFamily: 'Calibri',
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : GridView.builder(
            itemCount: fav.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: (devieceSize.height > 680) ? 0.8272 : 0.775),
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: (devieceSize.height > 680) ? 9 : 4.0),
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ChangeNotifierProvider<ProductProvider>(
                      create: (context) => ProductProvider(
                        fav[index],
                        context.read<AuthService>().currentUser,
                      ),
                      child: ProductScreen(),
                    ),
                  ),
                ),
                child: ChangeNotifierProvider<ProductProvider>(
                  create: (context) => ProductProvider(
                    fav[index],
                    context.read<AuthService>().currentUser,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: ProductCard(isExpand: false),
                  ),
                ),
              ),
            ),
          );
  }
}

class ShoppingListTab extends StatefulWidget {
  @override
  _ShoppingListTabState createState() => _ShoppingListTabState();
}

class _ShoppingListTabState extends State<ShoppingListTab> {
  @override
  void initState() {
    super.initState();
    _initData();
  }

  _initData() async {
    await context.read<HomeProvider>().getCart(
          context.read<AuthService>().currentUser.cartIds,
        );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();

    return provider.filteredCart == null
        ? LoadingWidget()
        : provider.filteredCart.isEmpty
            ? Center(
                child: Text(
                  'No Items Found',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontFamily: 'Calibri',
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Container(
                color: Colors.grey[200],
                child: Column(
                  children: [
                    SizedBox(height: 12.0),
                    Expanded(
                      child: ListView.builder(
                        itemCount: provider.filteredCart.length,
                        itemBuilder: (context, index) => GestureDetector(
                          child: ChangeNotifierProvider<ProductProvider>(
                            create: (context) => ProductProvider(
                              provider.filteredCart[index].productModel,
                              context.read<AuthService>().currentUser,
                            ),
                            child: ShoppingItemCard(
                                provider.filteredCart[index], index),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      color: Theme.of(context).accentColor,
                      child: Row(
                        children: [
                          Text(
                            'Total : Rs. ',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'sans-serif',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${provider.totalCartPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontFamily: 'sans-serif',
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            ' / ',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'sans-serif',
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${(provider.totalCartPrice + provider.totalCartDiscount).toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'sans-serif',
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
  }
}

class TabIndexProvider extends ChangeNotifier {
  final TabController tabController;
  final int type;

  TabIndexProvider(this.tabController, this.type) {
    tabController.addListener(() {
      notifyListeners();
    });
  }

  int get index => tabController?.index ?? 0;

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }
}

class SearchFilterSheet extends StatefulWidget {
  final BuildContext context;
  final int type;

  SearchFilterSheet(this.context, this.type);

  @override
  _SearchFilterSheetState createState() => _SearchFilterSheetState();
}

class _SearchFilterSheetState extends State<SearchFilterSheet> {
  final _catController = TextEditingController();
  final _brandController = TextEditingController();
  final _controller = TextEditingController();
  List<String> _categoris = [];
  String currentItemSelected = '';
  final selectedCategory = TextEditingController();

  getCategoryNames() {
    final cats = context.read<HomeProvider>().categories;
    for (int i = 0; i < cats.length; i++) {
      _categoris.add(cats[i].name);
    }
  }

  _search() {
    final provider = context.read<HomeProvider>();
    final index = widget.context.read<TabIndexProvider>().index;
    switch (index) {
      case 0:
        provider.searchProducts(_controller.text);
        Navigator.of(context).pop();
        if (widget.type == 7) {
          Navigator.of(context).push(CupertinoPageRoute(
              builder: (BuildContext context) => LibraryScreen(
                    index: 0,
                    type: 7,
                  )));
        }
        if (widget.type == 9) {
          Navigator.of(context).pop();
          Navigator.of(context).push(CupertinoPageRoute(
              builder: (BuildContext context) => LibraryScreen(
                    index: 0,
                    type: 7,
                  )));
        }

        break;
      case 1:
        provider.searchDeals(_controller.text);
        Navigator.of(context).pop();
        break;
      case 2:
        provider.searchFav(_controller.text);
        Navigator.of(context).pop();
        break;
      case 3:
        provider.searchCart(_controller.text);
        Navigator.of(context).pop();
        break;
    }
  }

  _filter() {
    print('controllerTextInButton: ${_catController.text}');
    final provider = context.read<HomeProvider>();
    final index = widget.context.read<TabIndexProvider>().index;
    switch (index) {
      case 0:
        provider.filterProducts(_catController.text, _brandController.text);
        Navigator.of(context).pop();
        if (widget.type == 7) {
          Navigator.of(context).push(CupertinoPageRoute(
              builder: (BuildContext context) => LibraryScreen(
                    index: 0,
                    type: 7,
                  )));
        }
        if (widget.type == 9) {
          Navigator.of(context).pop();
          Navigator.of(context).push(CupertinoPageRoute(
              builder: (BuildContext context) => LibraryScreen(
                    index: 0,
                    type: 7,
                  )));
        }
        break;
      case 1:
        provider.filterDeals(_catController.text, _brandController.text);
        Navigator.of(context).pop();
        break;
      case 2:
        provider.filterFav(_catController.text, _brandController.text);
        Navigator.of(context).pop();
        break;
      case 3:
        provider.filterCart(_catController.text, _brandController.text);
        Navigator.of(context).pop();
        break;
    }
  }

  @override
  void dispose() {
    _catController.dispose();
    _brandController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getCategoryNames();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
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
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                Spacer(),
                Text(
                  'Search and Filter',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontFamily: 'sans-serif',
                    fontSize: 20.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Image.asset(
                    'assets/icons/search.png',
                    color: Theme.of(context).accentColor,
                    height: 32.0,
                    width: 32.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(4.0),
              padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
              decoration: BoxDecoration(
                color: Color(0xFFf2f2f2),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                controller: _controller,
                style: TextStyle(
                  color: Color(0xFFb3b3b3),
                  fontFamily: 'sans-serif',
                  fontSize: 18.0,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(0.0),
                  hintText: 'Enter Product Name',
                  hintStyle: TextStyle(
                    color: Color(0xFFb3b3b3),
                    fontFamily: 'sans-serif',
                    fontSize: 18.0,
                  ),
                  suffix: IconButton(
                    icon: Icon(Icons.clear),
                    color: Color(0xFFb3b3b3),
                    onPressed: () => _controller.clear(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: () => _search(),
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
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 1.0,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '  OR  ',
                  style: TextStyle(
                    color: Color(0xFFb3b3b3),
                    fontFamily: 'sans-serif',
                    fontSize: 18.0,
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 1.0,
                    color: Color(0xFFb3b3b3),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'By Category',
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
                child: DropDownField(
                  hintText: 'Select Category',
                  items: _categoris,
                  onValueChanged: (value) {
                    setState(() {
                      currentItemSelected = value;
                      print('controller text : ${_catController.text}');
                    });
                  },
                  itemsVisibleInDropdown: 6,
                  value: currentItemSelected,
                  controller: _catController,
                  enabled: true,
                )),
            SizedBox(height: 16.0),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'By Brand',
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
                controller: _brandController,
                style: TextStyle(
                  color: Color(0xFFb3b3b3),
                  fontFamily: 'sans-serif',
                  fontSize: 18.0,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(0.0),
                  hintText: 'Select Brand',
                  hintStyle: TextStyle(
                    color: Color(0xFFb3b3b3),
                    fontFamily: 'sans-serif',
                    fontSize: 18.0,
                  ),
                  suffix: IconButton(
                    icon: Icon(Icons.clear),
                    color: Color(0xFFb3b3b3),
                    onPressed: () => _brandController.clear(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: () => _filter(),
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
                    'Filter',
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
        ),
      ),
    );
  }
}

class AddCardSheet extends StatefulWidget {
  final BuildContext context;

  AddCardSheet(this.context);

  @override
  _AddCardSheetState createState() => _AddCardSheetState();
}

class _AddCardSheetState extends State<AddCardSheet> {
  _submit() async {
    try {
      LoadingScreen.show(context);
      await context.read<HomeProvider>().submitMemberShipCard();
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
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
                'Add a Card',
                style: TextStyle(
                  color: Color(0xFFb3b3b3),
                  fontFamily: 'sans-serif',
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text(
                'Select Membership',
                style: TextStyle(
                  color: Color(0xFFb3b3b3),
                  fontFamily: 'sans-serif',
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(4.0),
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
            decoration: BoxDecoration(
              color: Color(0xFFf2f2f2),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: DropdownButtonFormField<MembershipCardType>(
              value: context.select(
                  (HomeProvider h) => h.membershipCardModel.membershipCardType),
              onChanged: context.watch<HomeProvider>().selectCardType,
              items: context
                  .select((HomeProvider h) => h.cardTypes)
                  ?.map((MembershipCardType e) =>
                      DropdownMenuItem<MembershipCardType>(
                          value: e,
                          child: Text(
                            '${e.name}',
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontFamily: 'sans-serif',
                              fontSize: 18.0,
                            ),
                          )))
                  ?.toList(),
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: Theme.of(context).accentColor,
                size: 32,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 4.0),
                isDense: true,
                border: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                filled: false,
                hintText: 'Select Membership',
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
            child: Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text(
                'Membership Number',
                style: TextStyle(
                  color: Color(0xFFb3b3b3),
                  fontFamily: 'sans-serif',
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
          SizedBox(height: 8.0),
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
                    onChanged: (value) => context
                        .read<HomeProvider>()
                        .membershipCardModel
                        .cardNumber = value,
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontFamily: 'sans-serif',
                      fontSize: 18.0,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(0.0),
                      hintText: 'Insert Number',
                      hintStyle: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontFamily: 'sans-serif',
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async =>
                      await context.read<HomeProvider>().getCardNumberByScan(),
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
            onTap: () => _submit(),
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

class SearchSheet extends StatefulWidget {
  final BuildContext context;

  SearchSheet(this.context);

  @override
  _SearchSheetState createState() => _SearchSheetState();
}

class _SearchSheetState extends State<SearchSheet> {
  final _controller = TextEditingController();

  _search() {
    final provider = context.read<HomeProvider>();
    final index = widget.context.read<TabIndexProvider>().index;
    switch (index) {
      case 0:
        provider.searchProducts(_controller.text);
        Navigator.of(context).pop();
        break;
      case 1:
        provider.searchDeals(_controller.text);
        Navigator.of(context).pop();
        break;
      case 2:
        provider.searchFav(_controller.text);
        Navigator.of(context).pop();
        break;
      case 3:
        provider.searchCart(_controller.text);
        Navigator.of(context).pop();
        break;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
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
                'Search Product',
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontFamily: 'sans-serif',
                  fontSize: 20.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Image.asset(
                  'assets/icons/search.png',
                  color: Theme.of(context).accentColor,
                  height: 32.0,
                  width: 32.0,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(4.0),
            padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
            decoration: BoxDecoration(
              color: Color(0xFFf2f2f2),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: TextField(
              controller: _controller,
              style: TextStyle(
                color: Color(0xFFb3b3b3),
                fontFamily: 'sans-serif',
                fontSize: 18.0,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(0.0),
                hintText: 'Enter Product Name',
                hintStyle: TextStyle(
                  color: Color(0xFFb3b3b3),
                  fontFamily: 'sans-serif',
                  fontSize: 18.0,
                ),
                suffix: IconButton(
                  icon: Icon(Icons.clear),
                  color: Color(0xFFb3b3b3),
                  onPressed: () => _controller.clear(),
                ),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          GestureDetector(
            onTap: () => _search(),
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
