import '../models/product.dart';

enum ProductSort { newest, priceAsc, priceDesc, bestSelling, topRated }

class ProductQuery {
  final String? categoryId;
  final String? vendorId;
  final String? search;
  final double? minPrice;
  final double? maxPrice;
  final List<String> sizes;
  final List<String> colors;
  final List<String> brands;
  final ProductCondition? condition;
  final double? minRating;
  final ProductSort sort;
  final int limit;

  const ProductQuery({
    this.categoryId,
    this.vendorId,
    this.search,
    this.minPrice,
    this.maxPrice,
    this.sizes = const [],
    this.colors = const [],
    this.brands = const [],
    this.condition,
    this.minRating,
    this.sort = ProductSort.newest,
    this.limit = 40,
  });
}

abstract class ProductRepository {
  Future<List<Product>> list(ProductQuery query);
  Future<Product?> getById(String id);
  Future<List<Product>> trending({int limit = 10});
  Future<List<Product>> newArrivals({int limit = 10});
  Future<List<Product>> byVendor(String vendorId, {int limit = 40});
}
