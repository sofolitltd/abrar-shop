import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '/utils/constants/constants.dart';
import '../../controllers/product_controller.dart';
import '../../models/product_model.dart';
import '../products/products_details.dart';

class SearchProduct extends StatelessWidget {
  const SearchProduct({super.key});

  @override
  Widget build(BuildContext context) {
    // controller
    final productController = Get.put(ProductController());
    var productList = productController.allProducts;

    //
    return Autocomplete<ProductModel>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<ProductModel>.empty();
        }
        List<String> words = textEditingValue.text.toLowerCase().split(' ');
        return productList.where((ProductModel item) {
          return words.every((word) => item.name.toLowerCase().contains(word));
        });
      },
      displayStringForOption: (ProductModel option) => option.name,
      onSelected: (ProductModel productModel) {
        //
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black26),
          ),
          child: Row(
            children: [
              const Icon(
                Iconsax.search_normal,
                size: 20,
                color: Colors.black54,
              ),

              const SizedBox(width: 8),

              //
              Expanded(
                child: TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  onSubmitted: (_) => onFieldSubmitted(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    // fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: ' Search in store ...',
                    filled: true,
                    fillColor: Colors.white,
                    border: InputBorder.none,
                    suffix: GestureDetector(
                      onTap: () {
                        textEditingController.clear();
                      },
                      child: const Icon(
                        Iconsax.close_circle,
                        size: 18,
                        color: Colors.black54,
                      ),
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected<ProductModel> onSelected,
          Iterable<ProductModel> options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1042),
                height: MediaQuery.of(context).size.height - 32,
                width: MediaQuery.of(context).size.width - 32,
                padding: const EdgeInsets.all(12),
                child: ListView.separated(
                  itemCount: options.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(thickness: .5),
                  itemBuilder: (BuildContext context, int index) {
                    final ProductModel option = options.elementAt(index);
                    //
                    return InkWell(
                      onTap: () {
                        Get.to(
                          () => ProductsDetails(product: option),
                          transition: Transition.noTransition,
                        )?.then((_) {
                          productController.showSearchBar.value = false;
                        });
                      },
                      child: Row(
                        children: [
                          //
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12),
                            ),
                            width: 56,
                            height: 56,
                            child: option.images.isNotEmpty
                                ? Image.network(
                                    option.images[0],
                                    fit: BoxFit.cover,
                                  )
                                : const Placeholder(),
                          ),

                          const SizedBox(width: 16),

                          //
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  option.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(),
                                ),

                                const SizedBox(height: 8),

                                //
                                Text(
                                  '${option.regularPrice.toStringAsFixed(0)} $kTkSymbol',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                        fontSize: 18,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
