import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:promohunter/models/cart_item_model.dart';
import 'package:promohunter/models/product_model.dart';
import 'package:promohunter/models/shop_model.dart';
import 'package:promohunter/providers/auth_provider.dart';
import 'package:promohunter/providers/home_provider.dart';
import 'package:promohunter/providers/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:quiver/strings.dart';

import 'library_screen.dart';

class ProductScreen extends StatefulWidget {
  final ShopModel shopModel;
  const ProductScreen({Key key, this.shopModel}) : super(key: key);
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    _initData();
  }

  _initData() {
    context.read<ProductProvider>().increaseViews();
  }

  void manageFav(BuildContext context) {
    final provider = context.read<ProductProvider>();
    provider.isInFav ? provider.remFromFav() : provider.addToFav();
  }

  void manageCart(BuildContext context) {
    final provider = context.read<ProductProvider>();
    if (provider.isInCart) {
      provider.remFromCart();
      context.read<HomeProvider>().remFromCart(provider.product.id);
    } else {
      provider.addToCart();
      context
          .read<HomeProvider>()
          .addToCart(CartItemModel(provider.product.id, 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    final product = context.select((ProductProvider p) => p.product);
    final ads = context.select((HomeProvider m) => m.ads);
    final _pageSize = MediaQuery.of(context).size.height;
    final diviceSize = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFFf9ba00),
      body: Builder(
        builder: (context) => Column(
          children: [
            Container(
              height: _pageSize - 80,
              child: SliverContainer(
                floatingActionButton: GestureDetector(
                  onTap: () => showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16.0),
                      ),
                    ),
                    enableDrag: true,
                    isDismissible: true,
                    isScrollControlled: true,
                    builder: (context) => ChangeNotifierProvider.value(
                      value: provider,
                      child: ProductMoreSheet(),
                    ),
                  ),
                  child: Container(
                    height: 60.0,
                    width: 60.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFf9ba00),
                    ),
                    child: Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                  ),
                ),
                expandedHeight: 256.0,
                slivers: <Widget>[
                  SliverAppBar(
                    iconTheme: IconThemeData(color: Colors.white),
                    backgroundColor: Color(0xFF000c4f),
                    expandedHeight: 285.0,
                    pinned: false,
                    flexibleSpace: FlexibleSpaceBar(
                      background: CachedNetworkImage(
                          height: 300,
                          alignment: Alignment.center,
                          imageUrl: product.picture,
                          fit: BoxFit.cover),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(16.0),
                          color: Color(0xFF000c4f),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${product.name}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'sans-serif',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                '${provider.brand?.name ?? ''}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'sans-serif',
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(height: 16.0),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      provider.isInFav
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: Color(0xFFf9ba00),
                                      size: 28.0,
                                    ),
                                    onPressed: () => manageFav(context),
                                  ),
                                  SizedBox(width: 16.0),
                                  GestureDetector(
                                    onTap: () => showModalBottomSheet(
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
                                          UpdatePrice(_scaffoldKey, product),
                                    ),
                                    child: Image.asset(
                                      'assets/icons/ticket.png',
                                      height: 24.0,
                                      width: 24.0,
                                    ),
                                  ),
                                  SizedBox(width: 24.0),
                                  GestureDetector(
                                    onTap: () => manageCart(context),
                                    child: Image.asset(
                                      provider.isInCart
                                          ? 'assets/icons/cart-full.png'
                                          : 'assets/icons/small-cart.png',
                                      color: Color(0xFFf9ba00),
                                      width: 24.0,
                                      height: 24.0,
                                    ),
                                  ),
                                  SizedBox(width: 16.0),
                                  Text(
                                    '${product.noOfCart}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'sans-serif',
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    product.discountPercentage == '0'
                                        ? '${product.discountPercentage} %'
                                        : '-${product.discountPercentage} %',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'sans-serif',
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.0),
                              Row(
                                children: [
                                  Text(
                                    'Favourite of ${product.noOfFav} users',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'sans-serif',
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  Spacer(),
                                  Row(
                                    children: [
                                      if (product.minPrice !=
                                          product.basicPrice)
                                        Text(
                                          (widget.shopModel == null)
                                              ? 'Rs. ${product.minPrice} / '
                                              : 'Rs. ${product.shopPromoPrice(widget.shopModel.name)} / ',
                                          style: TextStyle(
                                            color: Color(0xFFf9ba00),
                                            fontFamily: 'sans-serif',
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      Text(
                                        '${product.basicPrice}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'sans-serif',
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              if (product.alternatePrices?.isNotEmpty ?? false)
                                ExpansionWidget(
                                  title: 'Deals',
                                  expanded: true,
                                  children: product.alternatePrices
                                      .map(
                                        (e) => Container(
                                          margin: EdgeInsets.all(8.0),
                                          padding: EdgeInsets.only(
                                            top: 12.0,
                                            bottom: 12.0,
                                            left: 16.0,
                                            right: 24.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width:
                                                        diviceSize.width * 0.4,
                                                    child: Text(
                                                      '${e.shopName}',
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontFamily:
                                                            'sans-serif',
                                                        fontSize: 20.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 4.0),
                                                  Text(
                                                    'Updated: ${e.lastUpdated.day}.${e.lastUpdated.month}.${e.lastUpdated.year}',
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontFamily: 'sans-serif',
                                                      fontSize: 14.0,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4.0),
                                                  Text(
                                                    'Confirmed by : ${e.confirmedBy}',
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontFamily: 'sans-serif',
                                                      fontSize: 14.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                'Rs. ${e.price}',
                                                style: TextStyle(
                                                  color: Color(0xFFf9ba00),
                                                  fontFamily: 'sans-serif',
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              SizedBox(height: 8.0),
                              if (product.description != null)
                                ExpansionWidget(
                                  title: 'Description',
                                  expanded: false,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 72.0,
                                        bottom: 8.0,
                                      ),
                                      child: Text(
                                        "${product.description}",
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'sans-serif',
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              SizedBox(height: 8.0),
                              if (provider.restrictions?.isNotEmpty ?? false)
                                ExpansionWidget(
                                  title: 'Restrictions',
                                  children: provider.restrictions
                                      .map(
                                        (r) => Padding(
                                          padding: const EdgeInsets.only(
                                            left: 72.0,
                                            bottom: 8.0,
                                          ),
                                          child: Text(
                                            "${r.name}",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'sans-serif',
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
    );
  }
}

class SliverContainer extends StatefulWidget {
  final List<Widget> slivers;
  final Widget floatingActionButton;
  final double expandedHeight;
  final double marginRight;
  final double topScalingEdge;

  SliverContainer({
    @required this.slivers,
    @required this.floatingActionButton,
    this.expandedHeight = 256.0,
    this.marginRight = 16.0,
    this.topScalingEdge = 96.0,
  });

  @override
  State<StatefulWidget> createState() => SliverFabState();
}

class SliverFabState extends State<SliverContainer> {
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CustomScrollView(
          controller: scrollController,
          slivers: widget.slivers,
        ),
      ],
    );
  }

  Widget _buildFab() {
    final topMarginAdjustVal =
        Theme.of(context).platform == TargetPlatform.iOS ? 12.0 : -4.0;
    final double defaultTopMargin = widget.expandedHeight + topMarginAdjustVal;

    double top = defaultTopMargin;
    double scale = 1.0;
    if (scrollController.hasClients) {
      double offset = scrollController.offset;
      top -= offset > 0 ? offset : 0;
      if (offset < defaultTopMargin - widget.topScalingEdge) {
        scale = 1.0;
      } else if (offset < defaultTopMargin - widget.topScalingEdge / 2) {
        scale = (defaultTopMargin - widget.topScalingEdge / 2 - offset) /
            (widget.topScalingEdge / 2);
      } else {
        scale = 0.0;
      }
    }

    return Positioned(
      top: top,
      right: widget.marginRight,
      child: Transform(
        transform: Matrix4.identity()..scale(scale, scale),
        alignment: Alignment.center,
        child: widget.floatingActionButton,
      ),
    );
  }
}

class ExpansionWidget extends StatefulWidget {
  final String title;
  final bool expanded;
  final List<Widget> children;

  const ExpansionWidget({
    Key key,
    @required this.title,
    @required this.children,
    this.expanded = false,
  }) : super(key: key);

  @override
  _ExpansionWidgetState createState() => _ExpansionWidgetState();
}

class _ExpansionWidgetState extends State<ExpansionWidget> {
  bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.expanded;
  }

  _toggleExpanded(bool val) {
    _expanded = val;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: widget.expanded,
      leading: Icon(
        Icons.info_outline,
        color: Colors.white,
      ),
      title: Text(
        widget.title,
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'sans-serif',
          fontSize: 16.0,
        ),
      ),
      trailing: Icon(
        _expanded ? Icons.expand_less : Icons.expand_more,
        color: Colors.white,
      ),
      children: widget.children ?? [],
      onExpansionChanged: _toggleExpanded,
    );
  }
}

class ProductMoreSheet extends StatelessWidget {
  void manageFav(BuildContext context) {
    final provider = context.read<ProductProvider>();
    provider.isInFav ? provider.remFromFav() : provider.addToFav();
    Navigator.of(context).pop();
  }

  void manageCart(BuildContext context) {
    final provider = context.read<ProductProvider>();
    provider.isInCart ? provider.remFromCart() : provider.addToCart();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();

    return Container(
      padding: EdgeInsets.all(8.0),
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
                'More Options',
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontFamily: 'sans-serif',
                  fontSize: 20.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(
                  Icons.more_vert,
                  color: Theme.of(context).accentColor,
                  size: 32.0,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              '${provider.product.name}',
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontFamily: 'Calibri',
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 16.0),
          ListTile(
            onTap: () => manageFav(context),
            leading: Icon(
              Icons.star,
              color: Theme.of(context).accentColor,
              size: 32.0,
            ),
            title: Text(
              provider.isInFav ? 'Remove from Favourites' : 'Add to Favourites',
              style: TextStyle(
                color: Color(0xFF808080),
                fontFamily: 'sans-serif',
                fontSize: 16.0,
              ),
            ),
          ),
          Divider(
            color: Theme.of(context).accentColor,
            thickness: 2.0,
          ),
          ListTile(
            onTap: () => manageCart(context),
            leading: Image.asset(
              'assets/icons/small-cart.png',
              color: Theme.of(context).accentColor,
              height: 32.0,
              width: 32.0,
            ),
            title: Text(
              provider.isInCart
                  ? 'Remove from Shopping List'
                  : 'Add to Shopping List',
              style: TextStyle(
                color: Color(0xFF808080),
                fontFamily: 'sans-serif',
                fontSize: 16.0,
              ),
            ),
          ),
          Divider(
            color: Theme.of(context).accentColor,
            thickness: 2.0,
          ),
          ListTile(
            leading: Image.asset(
              'assets/icons/ticket.png',
              height: 32.0,
              width: 32.0,
            ),
            title: Text(
              'Update a Price',
              style: TextStyle(
                color: Color(0xFF808080),
                fontFamily: 'sans-serif',
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UpdatePrice extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final ProductModel productModel;

  UpdatePrice(this.scaffoldKey, this.productModel);

  @override
  _UpdatePriceState createState() => _UpdatePriceState();
}

class _UpdatePriceState extends State<UpdatePrice> {
  final _price = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = context.read<HomeProvider>();
      provider.selectSingleSelectedProduct(widget.productModel);
    });
  }

  _updatePrice(BuildContext context) async {
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
                  provider.selectedShop == null
                      ? 'Shop Name'
                      : "${provider.selectedShop.name}",
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
                              image: CachedNetworkImageProvider('${c.picture}'),
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
                'Current Price',
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
              onTap: () => _updatePrice(context),
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
          ],
        ),
      ),
    );
  }
}
