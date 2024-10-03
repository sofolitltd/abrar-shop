import 'package:abrar/features/home/screens/search/search_product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '/features/home/controllers/product_controller.dart';
import '/features/home/screens/products/products_details.dart';
import '/utils/constants/constants.dart';
import '/utils/k_text.dart';
import '/utils/shimmer/popular_product_shimmer.dart';
import '../../controllers/cart_controller.dart';
import '../../models/cart_model.dart';
import '../cart/cart.dart';

class Shop extends StatelessWidget {
  const Shop({super.key});

  @override
  Widget build(BuildContext context) {
    final productController = Get.put(ProductController());
    // productController.fetchProducts();
    productController.setProducts(
        'Latest Items', productController.allProducts);
    //
    final cartController = Get.put(CartController());

    //
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
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
              //
              IconButton.filledTonal(
                onPressed: () {
                  Get.to(
                    () => const Cart(),
                    transition: Transition.rightToLeft,
                  );
                },
                icon: const Icon(
                  Iconsax.shopping_bag,
                  size: 22,
                ),
              ),

              //
              Obx(
                () => Badge(
                  label: Text(
                    '${cartController.cartItems.length}',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          productController.fetchProducts();
        },
        child: Stack(
          children: [
            //
            Column(
              children: [
                const SizedBox(height: 5),

                // sort menu
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black26),
                    ),
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                    margin: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //
                        Text(
                          'Sort by:',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    // fontWeight: FontWeight.bold,
                                    height: 1.6,
                                  ),
                        ),

                        const SizedBox(width: 8),

                        //
                        Obx(
                          () => ButtonTheme(
                            alignedDropdown: true,
                            child: Container(
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.black12.withOpacity(.05),
                                // border: Border.all(color: Colors.black26),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: DropdownButton(
                                padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                                isDense: true,
                                isExpanded: true,
                                value:
                                    productController.selectedSortOption.value,
                                items: <String>[
                                  'Name',
                                  'Latest Items',
                                  'Low to High',
                                  'High to Low',
                                ].map((String menu) {
                                  return DropdownMenuItem(
                                    value: menu,
                                    child: Text(menu),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  productController.setProducts(
                                    value!,
                                    productController.allProducts,
                                  );
                                },
                                underline: const SizedBox(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // all products
                Obx(
                  () {
                    // loading
                    if (productController.isLoading.value == true) {
                      return Expanded(
                        child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                          child: const PopularProductShimmer(),
                        ),
                      );
                    }

                    // if featured category empty
                    if (productController.allProducts.isEmpty) {
                      return const Text('No data found');
                    }

                    // ui
                    return Expanded(
                      child: Container(
                        color: Colors.white,
                        child: GridView.builder(
                          // shrinkWrap: true,
                          // physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: .65,
                          ),
                          itemCount: productController.allProducts.length,
                          itemBuilder: (context, index) {
                            // category
                            final product =
                                productController.allProducts[index];

                            //
                            return GestureDetector(
                              onTap: () {
                                //  products details
                                Get.to(
                                  () => ProductsDetails(product: product),
                                  transition: Transition.noTransition,
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.black12),
                                ),
                                child: Column(
                                  children: [
                                    // image
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: const Border(
                                            bottom: BorderSide(
                                              color: Colors.black12,
                                            ),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.blueAccent.shade100
                                              .withOpacity(.5),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: product.images.isNotEmpty
                                                ? NetworkImage(
                                                    product.images[0])
                                                : const AssetImage(
                                                    'assets/images/no_image.png',
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // name
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //
                                          SizedBox(
                                            height: 40,
                                            child: KText(
                                              product.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                    height: 1.3,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),

                                          const SizedBox(height: 8),

                                          // price, add to cart
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.baseline,
                                            textBaseline:
                                                TextBaseline.ideographic,
                                            children: [
                                              //
                                              Text(
                                                '$kTkSymbol ${product.salePrice.toStringAsFixed(0)} ',
                                                textAlign: TextAlign.start,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                      height: 1.3,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),

                                              //
                                              InkWell(
                                                onTap: () {
                                                  var cartItem = CartItemModel(
                                                    id: product.id,
                                                    name: product.name,
                                                    price: product.salePrice,
                                                    imageUrl: product
                                                            .images.isNotEmpty
                                                        ? product.images[0]
                                                        : '',
                                                    quantity: 1,
                                                  );

                                                  // Toggle item in cart
                                                  cartController
                                                      .toggleItemInCart(
                                                          cartItem);
                                                },
                                                child: Obx(
                                                  () {
                                                    // Use Obx to observe changes in cartItems
                                                    bool isInCart =
                                                        cartController.cartItems
                                                            .any((item) =>
                                                                item.id ==
                                                                product.id);
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        color: isInCart
                                                            ? Colors.red
                                                            : Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        border: Border.all(
                                                          color: isInCart
                                                              ? Colors
                                                                  .transparent
                                                              : Colors.black38,
                                                        ),
                                                      ),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4),
                                                      child: Icon(
                                                        isInCart
                                                            ? Iconsax
                                                                .shopping_bag5
                                                            : Iconsax
                                                                .shopping_bag,
                                                        size: 18,
                                                        color: isInCart
                                                            ? Colors.white
                                                            : Colors
                                                                .black, // Change color based on cart status
                                                      ),
                                                    );
                                                  },
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
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            // Search bar overlay
            Obx(
              () => Positioned(
                top: 5,
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
      ),
    );
  }
}
