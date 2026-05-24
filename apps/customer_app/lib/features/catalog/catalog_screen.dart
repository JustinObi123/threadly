import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CatalogFilter {
  final String? categoryId;
  final String? search;
  final double? minPrice;
  final double? maxPrice;
  final ProductSort sort;
  const CatalogFilter({this.categoryId, this.search, this.minPrice, this.maxPrice, this.sort = ProductSort.newest});

  CatalogFilter copyWith({String? categoryId, String? search, double? minPrice, double? maxPrice, ProductSort? sort}) =>
      CatalogFilter(
        categoryId: categoryId ?? this.categoryId,
        search: search ?? this.search,
        minPrice: minPrice ?? this.minPrice,
        maxPrice: maxPrice ?? this.maxPrice,
        sort: sort ?? this.sort,
      );
}

final catalogFilterProvider = StateProvider.autoDispose<CatalogFilter>((ref) => const CatalogFilter());

final catalogProductsProvider = FutureProvider.autoDispose<List<Product>>((ref) {
  final f = ref.watch(catalogFilterProvider);
  return ref.watch(productRepositoryProvider).list(ProductQuery(
    categoryId: f.categoryId,
    search: f.search,
    minPrice: f.minPrice,
    maxPrice: f.maxPrice,
    sort: f.sort,
  ));
});

class CatalogScreen extends ConsumerStatefulWidget {
  final String? categoryId;
  const CatalogScreen({super.key, this.categoryId});

  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> {
  final _searchCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(catalogFilterProvider.notifier).state =
          CatalogFilter(categoryId: widget.categoryId);
    });
  }

  @override
  void dispose() { _searchCtl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(catalogFilterProvider);
    final products = ref.watch(catalogProductsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(filter.categoryId == null
            ? 'Shop'
            : TopCategories.seed.firstWhere(
                (c) => c.id == filter.categoryId,
                orElse: () => const Category(id: '', name: 'Shop', slug: ''),
              ).name),
        actions: [
          PopupMenuButton<ProductSort>(
            icon: const Icon(Icons.sort),
            initialValue: filter.sort,
            onSelected: (s) => ref.read(catalogFilterProvider.notifier).state = filter.copyWith(sort: s),
            itemBuilder: (_) => const [
              PopupMenuItem(value: ProductSort.newest,      child: Text('Newest')),
              PopupMenuItem(value: ProductSort.priceAsc,    child: Text('Price: Low → High')),
              PopupMenuItem(value: ProductSort.priceDesc,   child: Text('Price: High → Low')),
              PopupMenuItem(value: ProductSort.bestSelling, child: Text('Best Selling')),
              PopupMenuItem(value: ProductSort.topRated,    child: Text('Top Rated')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchCtl,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search items, brands, vendors…',
                suffixIcon: _searchCtl.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchCtl.clear();
                          ref.read(catalogFilterProvider.notifier).state = filter.copyWith(search: '');
                        },
                      ),
              ),
              onSubmitted: (v) => ref.read(catalogFilterProvider.notifier).state = filter.copyWith(search: v),
            ),
          ),
          _CategoryChips(selected: filter.categoryId),
          Expanded(
            child: products.when(
              loading: () => const LoadingView(),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (items) {
                if (items.isEmpty) {
                  return const EmptyState(
                    icon: Icons.search_off,
                    title: 'No products match your filters',
                    message: 'Try a different category or clear the search.',
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.58,
                  ),
                  itemCount: items.length,
                  itemBuilder: (_, i) => ProductCard(
                    product: items[i],
                    onTap: () => context.push('/product/${items[i].id}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChips extends ConsumerWidget {
  final String? selected;
  const _CategoryChips({required this.selected});
  @override
  Widget build(BuildContext context, WidgetRef ref) => SizedBox(
        height: 44,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemCount: TopCategories.seed.length + 1,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final isAll = i == 0;
            final c = isAll ? null : TopCategories.seed[i - 1];
            final isSelected = isAll ? selected == null : c!.id == selected;
            return ChoiceChip(
              label: Text(isAll ? 'All' : c!.name),
              selected: isSelected,
              onSelected: (_) {
                final current = ref.read(catalogFilterProvider);
                ref.read(catalogFilterProvider.notifier).state =
                    CatalogFilter(categoryId: c?.id, search: current.search, sort: current.sort);
              },
            );
          },
        ),
      );
}
