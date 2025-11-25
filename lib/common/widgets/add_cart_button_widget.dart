import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/product_model.dart';
import 'package:flutter_restaurant/features/cart/providers/cart_provider.dart';
import 'package:flutter_restaurant/helper/product_helper.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class AddToCartButtonWidget extends StatelessWidget {
  const AddToCartButtonWidget({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, cartProvider, _) {
      int quantity = cartProvider.getCartProductQuantityCount(product);
      int cartIndex = cartProvider.getCartIndex(product);

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(quantity == 0 ? 10 : 50),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFD700).withAlpha(100),
              offset: const Offset(0, 2),
              blurRadius: 6,
              spreadRadius: 0,
            )
          ],
        ),
        child: quantity == 0
            ? Material(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFFFD700),
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  onTap: () => ProductHelper.addToCart(
                      cartIndex: cartIndex, product: product),
                  child: Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.add,
                      color: Colors.black,
                      size: 18,
                    ),
                  ),
                ),
              )
            : Material(
                borderRadius: BorderRadius.circular(50),
                color: const Color(0xFFFFD700),
                clipBehavior: Clip.hardEdge,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    InkWell(
                      onTap: () => cartProvider.onUpdateCartQuantity(
                          index: cartIndex, product: product, isRemove: true),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.remove,
                            size: 16, color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(quantity.toString(),
                          style: rubikMedium.copyWith(
                              color: Colors.black, fontSize: 14)),
                    ),
                    InkWell(
                      onTap: () => cartProvider.onUpdateCartQuantity(
                          index: cartIndex, product: product, isRemove: false),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add,
                            size: 16, color: Colors.black),
                      ),
                    ),
                  ]),
                ),
              ),
      );
    });
  }
}
