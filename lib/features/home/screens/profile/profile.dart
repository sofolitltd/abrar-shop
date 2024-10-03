import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '/features/authentication/controllers/user_controller.dart';
import '/features/home/controllers/product_controller.dart';
import '../../controllers/cart_controller.dart';
import '../cart/cart.dart';
import '../search/search_product.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    final productController = Get.put(ProductController());
    final cartController = Get.put(CartController());

    var user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      // backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title: const Text(
          'Profile',
          // style: TextStyle(color: Colors.white),
        ),
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
      body: Stack(
        children: [
          //
          Obx(() {
            if (userController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else if (user == null) {
              return _buildLoginPrompt(context);
            } else {
              return _buildProfileContent(context, user);
            }
          }),

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

      //
      bottomNavigationBar: user == null ? null : _buildSignOutButton(context),
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Center(
      child: Container(
        width: double.maxFinite,
        decoration: const BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blueAccent.shade100.withOpacity(.5),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(24),
              child: const Icon(
                Iconsax.user,
                size: 64,
                color: Colors.black26,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Please login first',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Get.toNamed('/login', arguments: '/profile');
              },
              icon: const Icon(Iconsax.personalcard),
              label: const Text(' Login Now'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, User user) {
    return ListView(
      children: [
        // _buildProfileHeader(user),
        const SizedBox(height: 16),
        _buildSettingsSection(context),
      ],
    );
  }

  Widget _buildProfileHeader(User user) {
    final userController = Get.put(UserController());

    return Obx(
      () => ListTile(
        tileColor: Colors.blueAccent,
        leading: const CircleAvatar(
          radius: 24,
        ),
        title: Text(
          userController.user.value.name,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          userController.user.value.email,
          style: const TextStyle(color: Colors.white),
        ),
        trailing: IconButton(
          onPressed: () {
            // Implement edit profile functionality here
          },
          icon: const Icon(
            Iconsax.edit,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    final userController = Get.put(UserController());

    return Container(
      constraints: const BoxConstraints(minHeight: 600),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, 'Account Settings'),
          const SizedBox(height: 8),
          ..._buildAccountSettings(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  List<Widget> _buildAccountSettings() {
    final List<Map<String, dynamic>> accountSettings = [
      {
        'title': 'My Address',
        'subtitle': 'Set shopping delivery address',
        'icon': Iconsax.home_wifi,
        'route': '/address',
      },
      {
        'title': 'My Cart',
        'subtitle': 'Add/Remove products and move to Checkout',
        'icon': Iconsax.shopping_bag,
        'route': '/cart',
      },
      {
        'title': 'My Orders',
        'subtitle': 'In-progress and Completed Products',
        'icon': Iconsax.bag,
        'route': '/orders',
      },
    ];

    return accountSettings.map((setting) {
      return ListTile(
        onTap: () => Get.toNamed(setting['route']),
        contentPadding: EdgeInsets.zero,
        title: Text(
          setting['title'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(setting['subtitle']),
        leading: Icon(
          setting['icon'],
          size: 32,
          color: Colors.blueAccent,
        ),
      );
    }).toList();
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
    );
  }

  //
  Widget _buildSignOutButton(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        onPressed: () {
          _showSignOutDialog(context); // Show dialog before sign out
        },
        child: const Text('Sign out'),
      ),
    );
  }

  // Helper method to show the sign-out dialog
  void _showSignOutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(), // Close the dialog
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Get.offAllNamed('/menu'); // Redirect to login
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
