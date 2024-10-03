import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/features/home/controllers/category_controller.dart';
import 'all_category_details.dart';

class AllCategories extends StatelessWidget {
  const AllCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.put(CategoryController());
    categoryController.allCategories();

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Categories'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          categoryController.allCategories();
        },
        child: Row(
          children: [
            // category
            Expanded(
              child: Obx(
                () => GridView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: categoryController.allCategories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: .9,
                  ),
                  itemBuilder: (_, index) {
                    //
                    final allCategory = categoryController.allCategories[index];

                    //
                    return GestureDetector(
                      onTap: () {
                        // featured category details
                        Get.to(
                          () => AllCategoryDetails(
                            category: allCategory,
                            isSubCategory: false,
                          ),
                          transition: Transition.noTransition,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black12),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            // image
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: .5,
                                  ),
                                  color: Colors.blueAccent.shade100
                                      .withOpacity(.5),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: allCategory.imageUrl.isNotEmpty
                                        ? NetworkImage(
                                            allCategory.imageUrl,
                                          )
                                        : const AssetImage(
                                            'assets/images/no_image.png'),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 8),

                            // name
                            SizedBox(
                              // width: 72,
                              height: 32,
                              child: Center(
                                child: Text(
                                  allCategory.name,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                        height: 1.2,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
