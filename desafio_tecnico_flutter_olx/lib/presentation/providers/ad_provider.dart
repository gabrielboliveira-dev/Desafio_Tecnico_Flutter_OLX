import 'package:flutter/material.dart';
import '../../domain/entities/ad_entity.dart';
import '../../domain/repositories/ad_repository.dart';

enum ViewState { initial, loading, success, error }

class AdProvider extends ChangeNotifier {
  final AdRepository repository;

  AdProvider({required this.repository});

  ViewState _state = ViewState.initial;
  String _errorMessage = '';

  List<AdEntity> _ads = [];
  List<String> _categories = [];

  int _currentPage = 1;
  String? _selectedCategory;
  bool _isLoadingMore = false;
  bool _hasMoreItems = true;

  ViewState get state => _state;
  String get errorMessage => _errorMessage;
  List<AdEntity> get ads => _ads;
  List<String> get categories => _categories;
  String? get selectedCategory => _selectedCategory;
  bool get isLoadingMore => _isLoadingMore;
  Future<void> init() async {
    _state = ViewState.loading;
    notifyListeners();

    try {
      final results = await Future.wait([
        repository.getCategories(),
        repository.getAds(page: 1, category: _selectedCategory),
      ]);

      _categories = results[0] as List<String>;
      _ads = results[1] as List<AdEntity>;

      _state = ViewState.success;
    } catch (e) {
      _state = ViewState.error;
      _errorMessage = 'Erro ao carregar dados iniciais: $e';
    }
    notifyListeners();
  }

  void selectCategory(String? category) {
    if (_selectedCategory == category) return;

    _selectedCategory = category;
    _currentPage = 1;
    _hasMoreItems = true;
    _ads = [];

    _fetchAdsInternal(isRefresh: true);
  }

  Future<void> loadMoreAds() async {
    if (_isLoadingMore || !_hasMoreItems || _state != ViewState.success) return;

    _isLoadingMore = true;
    notifyListeners();

    await _fetchAdsInternal(isRefresh: false);

    _isLoadingMore = false;
    notifyListeners();
  }

  Future<void> _fetchAdsInternal({required bool isRefresh}) async {
    try {
      if (isRefresh) {
        _state = ViewState.loading;
        notifyListeners();
      }

      final pageToFetch = isRefresh ? 1 : _currentPage + 1;

      final newAds = await repository.getAds(
        page: pageToFetch,
        category: _selectedCategory,
      );

      if (isRefresh) {
        _ads = newAds;
        _currentPage = 1;
      } else {
        _ads.addAll(newAds);
        if (newAds.isNotEmpty) {
          _currentPage++;
        }
      }

      if (newAds.isEmpty) {
        _hasMoreItems = false;
      }

      _state = ViewState.success;
    } catch (e) {
      if (isRefresh) {
        _state = ViewState.error;
        _errorMessage = 'Erro ao buscar anúncios: $e';
      } else {
        debugPrint('Erro no LoadMore: $e');
      }
    }
  }
}
