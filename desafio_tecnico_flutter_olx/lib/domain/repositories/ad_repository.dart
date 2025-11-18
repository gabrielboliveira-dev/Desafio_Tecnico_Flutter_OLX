import '../entities/ad_entity.dart';

abstract class AdRepository {
  Future<List<String>> getCategories();

  Future<List<AdEntity>> getAds({required int page, String? category});
}
