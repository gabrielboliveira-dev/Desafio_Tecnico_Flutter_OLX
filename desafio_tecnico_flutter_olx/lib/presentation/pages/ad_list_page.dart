import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ad_provider.dart';
import '../widgets/ad_list_item_widget.dart';
import '../widgets/category_filter_widget.dart';

class AdListPage extends StatefulWidget {
  const AdListPage({Key? key}) : super(key: key);

  @override
  State<AdListPage> createState() => _AdListPageState();
}

class _AdListPageState extends State<AdListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdProvider>().init();
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<AdProvider>().loadMoreAds();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OLX Clone'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Consumer<AdProvider>(
        builder: (context, provider, child) {
          if (provider.state == ViewState.loading && provider.ads.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.state == ViewState.error && provider.ads.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.errorMessage, textAlign: TextAlign.center),
                  ElevatedButton(
                    onPressed: () => provider.init(),
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              const SizedBox(height: 10),
              CategoryFilterWidget(
                categories: provider.categories,
                selectedCategory: provider.selectedCategory,
                onCategorySelected: (category) {
                  provider.selectCategory(category);
                  if (_scrollController.hasClients) {
                    _scrollController.jumpTo(0);
                  }
                },
              ),
              const Divider(),

              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => provider.init(),
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount:
                        provider.ads.length + (provider.isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == provider.ads.length) {
                        return const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final ad = provider.ads[index];
                      return AdListItemWidget(ad: ad);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
