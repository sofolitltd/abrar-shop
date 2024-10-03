import 'package:abrar/data/repositories/banners/banner_repository.dart';
import 'package:abrar/features/home/models/banner_model.dart';
import 'package:get/get.dart';

class BannerController extends GetxController {
  static BannerController get instance => Get.find();

  final isLoading = false.obs;
  final _brandsRepository = Get.put(BannerRepository());
  RxList<BannerModel> allBanner = <BannerModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBanners();
  }

  // fetch data
  fetchBanners() async {
    try {
      isLoading.value = true;
      final banner = await _brandsRepository.getAllBrands();

      //
      allBanner.assignAll(banner);

      isLoading.value = false;
    } catch (e) {
      throw 'Something wrong when fetch: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
