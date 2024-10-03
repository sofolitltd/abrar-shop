import 'package:abrar/features/home/controllers/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '/navigation_menu.dart';
import '/utils/constants/constants.dart';
import '/utils/k_text.dart';
import '../../controllers/cart_controller.dart';
import '../checkout/checkout.dart';
import '../search/search_product.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CartController());
    final productController = Get.put(ProductController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          //
          Obx(
            () => IconButton.filledTonal(
              onPressed: () {
                final productController = Get.find<ProductController>();
                productController.toggleSearchBar();
              },
              style: IconButton.styleFrom(
                backgroundColor: productController.showSearchBar.value
                    ? Colors.blueAccent
                    : null,
              ),
              icon: Icon(
                Iconsax.search_normal,
                size: 22,
                color:
                    productController.showSearchBar.value ? Colors.white : null,
              ),
            ),
          ),

          const SizedBox(width: 4),

          //
          Stack(
            alignment: Alignment.topRight,
            children: [
              const IconButton.filledTonal(
                onPressed: null,
                icon: Icon(
                  Iconsax.shopping_bag,
                  size: 22,
                ),
              ),

              // show total cart item
              Obx(
                () => Badge(
                  label: Text('${cartController.cartItems.length}'),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          //
          Obx(
            () {
              if (cartController.cartItems.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('No product found!'),
                      const SizedBox(height: 16),

                      //
                      ElevatedButton.icon(
                        onPressed: () {
                          NavigatorController navigatorController =
                              Get.find<NavigatorController>();
                          if (Get.currentRoute == '/menu') {
                            // Set the selected index to 0 (Home)
                            navigatorController.selectedIndex.value = 1;
                          } else {
                            (Get.offAll(() => const NavigationMenu()));
                            navigatorController.selectedIndex.value = 1;
                          }
                        },
                        icon: const Icon(
                          Iconsax.shop,
                          size: 16,
                        ),
                        label: const Text('Continue Shopping'),
                      ),
                    ],
                  ),
                );
              }

              return Container(
                color: Colors.white,
                margin: const EdgeInsets.only(top: 5),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: cartController.cartItems.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final cartItem = cartController.cartItems[index];

                    //
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image placeholder
                          Container(
                            height: 72,
                            width: 72,
                            decoration: BoxDecoration(
                              color: Colors.blueAccent.shade100.withOpacity(.5),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.black12),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: cartItem.imageUrl.isNotEmpty
                                    ? NetworkImage(cartItem.imageUrl)
                                    : const AssetImage(
                                        'assets/images/no_image.png',
                                      ),
                              ),
                            ),
                            // Assuming imageUrl is a valid image URL
                          ),
                          const SizedBox(width: 12),

                          // Name, price, add/remove
                          Expanded(
                            child: Container(
                              constraints: const BoxConstraints(
                                minHeight: 72,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  // name
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //
                                      Expanded(
                                        child: KText(
                                          cartItem.name,
                                          maxLines: 2,
                                          // overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                fontSize: 18,
                                                height: 1.3,
                                              ),
                                        ),
                                      ),

                                      const SizedBox(width: 8),

                                      // delete from cart
                                      GestureDetector(
                                        onTap: () {
                                          cartController
                                              .showDeleteConfirmationDialog(
                                                  cartItem);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          padding: const EdgeInsets.all(4),
                                          child: const Icon(
                                            Icons.delete_outline,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 2),

                                  // add/remove
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      //
                                      Expanded(
                                        child: Row(
                                          textBaseline:
                                              TextBaseline.ideographic,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.baseline,
                                          children: [
                                            Text(
                                              (cartItem.price *
                                                      cartItem.quantity)
                                                  .toStringAsFixed(0),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),

                                            const SizedBox(width: 4),
                                            //
                                            Text(
                                              '(${cartItem.price.toStringAsFixed(0)} x ${cartItem.quantity})',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                    color: Colors.black54,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(width: 8),

                                      //
                                      Row(
                                        children: [
                                          // Decrease quantity
                                          GestureDetector(
                                            onTap: () {
                                              cartController
                                                  .decreaseQuantityOf(cartItem);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black12,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              padding: const EdgeInsets.all(2),
                                              child: const Icon(
                                                Iconsax.minus,
                                              ),
                                            ),
                                          ),

                                          // Display quantity
                                          Container(
                                            constraints: const BoxConstraints(
                                                minWidth: 32),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 2),
                                            alignment: Alignment.center,
                                            child: Text(
                                              '${cartItem.quantity}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                            ),
                                          ),

                                          // Increase quantity
                                          GestureDetector(
                                            onTap: () {
                                              cartController
                                                  .increaseQuantityOf(cartItem);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.blueAccent,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              padding: const EdgeInsets.all(2),
                                              child: const Icon(
                                                Iconsax.add,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),

          // Search bar overlay
          Obx(
            () => Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Visibility(
                visible: productController.showSearchBar.value,
                child: Container(
                  color: Colors.white,
                  margin: const EdgeInsets.all(16),
                  child:
                      const SearchProduct(), // Assuming you're using the SearchBar widget
                ),
              ),
            ),
          ),
        ],
      ),

      // Checkout button with grand total
      bottomNavigationBar: Obx(
        () => Container(
          color: Colors.white,
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //
              if (cartController.cartItems.isNotEmpty) ...[
                //
                Obx(
                  () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Item: ${cartController.totalQuantity}',
                        ),
                        Text(
                          'Total Price: $kTkSymbol ${cartController.totalPrice.toStringAsFixed(0)}',
                        ),
                      ]),
                ),

                const SizedBox(height: 8),

                //
                ElevatedButton(
                  onPressed: () {
                    Get.to(
                      const CheckOut(),
                      transition: Transition.noTransition,
                    );
                  },
                  child: const Text('Checkout'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
