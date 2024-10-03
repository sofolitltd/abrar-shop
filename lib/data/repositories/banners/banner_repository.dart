import 'package:abrar/features/home/models/banner_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BannerRepository extends GetxController {
  static BannerRepository get instance => Get.find();

  // var
  final _db = FirebaseFirestore.instance;

  /// get all categories
  Future<List<BannerModel>> getAllBrands() async {
    try {
      final snapshot = await _db.collection('banners').orderBy('index').get();
      final list = snapshot.docs
          .map((document) => BannerModel.fromJson(document))
          .toList();
      return list;
    } on FirebaseException catch (e) {
      throw 'Firebase error: $e';
    } catch (e) {
      throw 'Something wrong: $e';
    }
  }
}
