import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:promohunter/models/cart_item_model.dart';
import 'package:promohunter/providers/auth_provider.dart';
import 'package:promohunter/providers/home_provider.dart';
import 'package:promohunter/providers/product_provider.dart';
import 'package:promohunter/ui/product_screen.dart';
import 'package:provider/provider.dart';

class ShoppingItemCard extends StatefulWidget {
  final CartItemModel cartItemModel;
  final int index;

  ShoppingItemCard(this.cartItemModel, this.index);

  @override
  _ShoppingItemCardState createState() => _ShoppingItemCardState();
}

class _ShoppingItemCardState extends State<ShoppingItemCard> {
  int quantity = 1;
  num total;
  num maxTotal;

  @override
  void initState() {
    super.initState();
    quantity = widget.cartItemModel.quantity;
    total = (widget.cartItemModel.productModel.minPrice) * quantity;
    maxTotal = (widget.cartItemModel.productModel.basicPrice) * quantity;
  }

  void _increase() {
    quantity++;
    updateQuantity();
    total += widget.cartItemModel.productModel.minPrice;
    maxTotal += widget.cartItemModel.productModel.basicPrice;
    context.read<HomeProvider>().changeTotalCartPrice(
        widget.cartItemModel.productModel.basicPrice,
        widget.cartItemModel.productModel.minPrice,
        true);
    if (mounted) setState(() {});
  }

  void _decrease() {
    if (quantity == 1) return;
    quantity--;
    updateQuantity();
    total -= widget.cartItemModel.productModel.minPrice;
    maxTotal -= widget.cartItemModel.productModel.basicPrice;
    context.read<HomeProvider>().changeTotalCartPrice(
        widget.cartItemModel.productModel.basicPrice,
        widget.cartItemModel.productModel.minPrice,
        false);
    if (mounted) setState(() {});
  }

  void updateQuantity() {
    context
        .read<AuthService>()
        .currentUser
        .cartIds
        .firstWhere((element) =>
            element.productModelId == widget.cartItemModel.productModelId)
        .quantity = quantity;
    context
        .read<HomeProvider>()
        .updateUser(context.read<AuthService>().currentUser);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.16),
            offset: Offset(0, 3),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: 8.0, top: 12.0, bottom: 12.0, right: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ChangeNotifierProvider<ProductProvider>(
                        create: (context) => ProductProvider(
                          provider.filteredCart[widget.index].productModel,
                          context.read<AuthService>().currentUser,
                        ),
                        child: ProductScreen(),
                      ),
                    ),
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.width * 0.3,
                    width: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                            widget.cartItemModel.productModel.picture),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${widget.cartItemModel.productModel.brandModel?.name}',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontFamily: 'sans-serif',
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  '${widget.cartItemModel.productModel.name}',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontFamily: 'sans-serif',
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              context.read<ProductProvider>().remFromCart();
                              context.read<HomeProvider>().remFromCart(
                                  widget.cartItemModel.productModelId);
                            },
                            child: Container(
                              padding: EdgeInsets.all(1.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.grey[800],
                                ),
                              ),
                              child: Icon(
                                Icons.clear,
                                size: 18.0,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          Text(
                            'Rs. ${total.toStringAsFixed(2)} / ',
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontFamily: 'sans-serif',
                              fontSize: 20.0,
                            ),
                          ),
                          Text(
                            '${maxTotal.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'sans-serif',
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.0),
                      Row(
                        children: [
                          Spacer(),
                          GestureDetector(
                            onTap: () => _decrease(),
                            child: Container(
                              padding: EdgeInsets.all(2.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.grey[400],
                                ),
                              ),
                              child: Icon(
                                Icons.remove,
                                size: 18.0,
                                color: Colors.grey[400],
                              ),
                            ),
                          ),
                          SizedBox(width: 16.0),
                          Text(
                            '$quantity',
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontFamily: 'sans-serif',
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 16.0),
                          GestureDetector(
                            onTap: () => _increase(),
                            child: Container(
                              padding: EdgeInsets.all(2.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                              child: Icon(
                                Icons.add,
                                size: 18.0,
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
