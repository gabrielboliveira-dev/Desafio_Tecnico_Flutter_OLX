import '../../core/constants/api_constants.dart';
import '../../domain/entities/ad_entity.dart';
import '../../domain/repositories/ad_repository.dart';
import '../datasources/ad_api_datasources.dart';

class AdRepositoryImpl implements AdRepository {
  final AdApiDataSource dataSource;

  AdRepositoryImpl({required this.dataSource});

  @override
  Future<List<String>> getCategories() async {
    return await dataSource.getCategories();
  }

  @override
  Future<List<AdEntity>> getAds({required int page, String? category}) async {
    final int limit = ApiConstants.pageSize; // 10
    final int skip = (page - 1) * limit;

    final models = await dataSource.getAds(
      skip: skip,
      limit: limit,
      category: category,
    );

    return models;
  }
}
