import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/ad_model.dart';

class AdApiDataSource {
  final http.Client client;

  AdApiDataSource({required this.client});

  Future<List<String>> getCategories() async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.categories}');
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => e.toString()).toList();
    } else {
      throw Exception('Erro ao buscar categorias');
    }
  }

  Future<List<AdModel>> getAds({
    required int skip,
    required int limit,
    String? category,
  }) async {
    String endpoint;
    if (category != null && category.isNotEmpty) {
      endpoint =
          '${ApiConstants.baseUrl}${ApiConstants.productsByCategory}/$category';
    } else {
      endpoint = '${ApiConstants.baseUrl}${ApiConstants.products}';
    }

    final uri = Uri.parse('$endpoint?limit=$limit&skip=$skip');

    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List products = data['products'];

      return products.map((json) => AdModel.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar anúncios: ${response.statusCode}');
    }
  }
}
