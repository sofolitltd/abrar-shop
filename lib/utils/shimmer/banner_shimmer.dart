import 'package:flutter/material.dart';

import '/utils/shimmer/shimmer_effect.dart';

class BannerShimmer extends StatelessWidget {
  const BannerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: const Column(
        children: [
          SizedBox(height: 4),

          //
          KShimmerEffect(height: 186, width: double.maxFinite, radius: 16),

          //
          SizedBox(height: 10),

          //
          KShimmerEffect(
            height: 14,
            width: 64,
            radius: 16,
          ),
        ],
      ),
    );
  }
}
