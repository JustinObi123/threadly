import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import '../models/product_variant.dart';
import 'product_repository.dart';

class FirestoreProductRepository implements ProductRepository {
  FirestoreProductRepository({FirebaseFirestore? db})
      : _col = (db ?? FirebaseFirestore.instance).collection('products');

  final CollectionReference<Map<String, dynamic>> _col;

  Query<Map<String, dynamic>> _applyQuery(ProductQuery q) {
    Query<Map<String, dynamic>> ref = _col
        .where('approvalStatus', isEqualTo: 'approved')
        .where('isActive', isEqualTo: true);

    if (q.categoryId != null) ref = ref.where('categoryId', isEqualTo: q.categoryId);
    if (q.vendorId   != null) ref = ref.where('vendorId',   isEqualTo: q.vendorId);
    if (q.condition  != null) {
      ref = ref.where('condition',
          isEqualTo: q.condition == ProductCondition.used ? 'used' : 'new');
    }
    if (q.minPrice != null) ref = ref.where('basePrice', isGreaterThanOrEqualTo: q.minPrice);
    if (q.maxPrice != null) ref = ref.where('basePrice', isLessThanOrEqualTo: q.maxPrice);

    switch (q.sort) {
      case ProductSort.newest:      ref = ref.orderBy('createdAt',  descending: true);  break;
      case ProductSort.priceAsc:    ref = ref.orderBy('basePrice');                     break;
      case ProductSort.priceDesc:   ref = ref.orderBy('basePrice',  descending: true);  break;
      case ProductSort.bestSelling: ref = ref.orderBy('salesCount', descending: true);  break;
      case ProductSort.topRated:    ref = ref.orderBy('rating',     descending: true);  break;
    }
    return ref.limit(q.limit);
  }

  @override
  Future<List<Product>> list(ProductQuery query) async {
    final snap = await _applyQuery(query).get();
    var items = snap.docs.map((d) => Product.fromMap(d.id, d.data())).toList();

    // Client-side post-filters Firestore cannot combine in a single query.
    if (query.search != null && query.search!.isNotEmpty) {
      final s = query.search!.toLowerCase();
      items = items.where((p) =>
          p.title.toLowerCase().contains(s) ||
          p.brand.toLowerCase().contains(s) ||
          p.tags.any((t) => t.toLowerCase().contains(s))).toList();
    }
    if (query.sizes.isNotEmpty)  items = items.where((p) => p.sizes.any(query.sizes.contains)).toList();
    if (query.colors.isNotEmpty) items = items.where((p) => p.colors.any(query.colors.contains)).toList();
    if (query.brands.isNotEmpty) items = items.where((p) => query.brands.contains(p.brand)).toList();
    if (query.minRating != null) items = items.where((p) => p.rating >= query.minRating!).toList();
    return items;
  }

  @override
  Future<Product?> getById(String id) async {
    final snap = await _col.doc(id).get();
    if (!snap.exists) return null;
    final variants = await _col.doc(id).collection('variants').get();
    return Product.fromMap(
      snap.id,
      snap.data()!,
      variants: variants.docs.map((d) => ProductVariant.fromMap(d.id, d.data())).toList(),
    );
  }

  @override
  Future<List<Product>> trending({int limit = 10}) =>
      list(ProductQuery(sort: ProductSort.bestSelling, limit: limit));

  @override
  Future<List<Product>> newArrivals({int limit = 10}) =>
      list(ProductQuery(sort: ProductSort.newest, limit: limit));

  @override
  Future<List<Product>> byVendor(String vendorId, {int limit = 40}) =>
      list(ProductQuery(vendorId: vendorId, limit: limit));
}
