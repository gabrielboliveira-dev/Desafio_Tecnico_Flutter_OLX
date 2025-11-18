import '../../domain/entities/ad_entity.dart';

class AdModel extends AdEntity {
  AdModel({
    required int id,
    required String title,
    required String thumbnail,
    required double price,
  }) : super(id: id, title: title, thumbnail: thumbnail, price: price);

  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
      id: json['id'],
      title: json['title'] ?? 'Sem Título',
      thumbnail: json['thumbnail'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
