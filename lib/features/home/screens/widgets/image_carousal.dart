import 'dart:async';

import 'package:abrar/features/home/models/banner_model.dart';
import 'package:flutter/material.dart';

class ImageCarousel extends StatefulWidget {
  final List<BannerModel> images;

  const ImageCarousel({super.key, required this.images});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final PageController _pageController = PageController(initialPage: 1);
  int _currentPage = 1;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startAutoSlide();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // Start auto sliding images every 3 seconds
  void startAutoSlide() {
    _timer?.cancel(); // Cancel previous timer if any
    _timer = Timer.periodic(const Duration(seconds: 10), (Timer timer) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  // Handle looping to create a seamless transition
  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
      if (index == widget.images.length + 1) {
        _currentPage = 1;
        _pageController.jumpToPage(1);
      } else if (index == 0) {
        _currentPage = widget.images.length;
        _pageController.jumpToPage(widget.images.length);
      }
    });
  }

  // Handle manual indicator tap
  void _onIndicatorTap(int index) {
    _timer?.cancel(); // Stop the timer temporarily
    _pageController.animateToPage(
      index + 1, // Offset due to extra first page
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    // Restart the timer after a short delay
    Future.delayed(const Duration(seconds: 1), () {
      startAutoSlide();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 214,
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 4),
          //
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                color: Colors.black12.withOpacity(.05),
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount:
                      widget.images.length + 2, // extra pages for looping
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Image.asset(
                          widget.images[widget.images.length - 1].imageUrl);
                    } else if (index == widget.images.length + 1) {
                      return Image.network(
                        widget.images[0].imageUrl,
                        fit: BoxFit.cover,
                      );
                    }
                    return Image.network(widget.images[index - 1].imageUrl);
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          //
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.images.length, (index) {
              return GestureDetector(
                onTap: () {
                  _onIndicatorTap(index); // Tap to change the image
                },
                child: AnimatedContainer(
                  duration:
                      const Duration(milliseconds: 300), // Animation duration
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width:
                      _currentPage == index + 1 ? 32 : 10, // Width transition
                  height:
                      _currentPage == index + 1 ? 14 : 10, // Height transition
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8), // Rounded rectangle
                    color: _currentPage == index + 1
                        ? Colors.blue
                        : Colors.grey, // Color transition
                  ),
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}
