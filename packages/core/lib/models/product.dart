import 'product_variant.dart';

enum ProductCondition { brandNew, used }
enum ProductGender { men, women, unisex, kids }
enum ApprovalStatus { pending, approved, rejected }

class Product {
  final String id;
  final String vendorId;
  final String storeId;
  final String storeName;        // denormalized for listing performance
  final String title;
  final String description;
  final String brand;
  final String categoryId;
  final String? subcategoryId;
  final ProductGender gender;
  final ProductCondition condition;
  final double basePrice;
  final double? discountPrice;
  final String currency;
  final List<String> images;
  final List<String> tags;
  final List<String> sizes;
  final List<String> colors;
  final int totalStock;
  final bool isActive;
  final ApprovalStatus approvalStatus;
  final double rating;
  final int ratingCount;
  final int salesCount;
  final DateTime createdAt;
  final List<ProductVariant> variants;

  const Product({
    required this.id,
    required this.vendorId,
    required this.storeId,
    required this.storeName,
    required this.title,
    required this.description,
    required this.brand,
    required this.categoryId,
    this.subcategoryId,
    this.gender = ProductGender.unisex,
    this.condition = ProductCondition.brandNew,
    required this.basePrice,
    this.discountPrice,
    this.currency = 'USD',
    this.images = const [],
    this.tags = const [],
    this.sizes = const [],
    this.colors = const [],
    this.totalStock = 0,
    this.isActive = true,
    this.approvalStatus = ApprovalStatus.approved,
    this.rating = 0,
    this.ratingCount = 0,
    this.salesCount = 0,
    required this.createdAt,
    this.variants = const [],
  });

  double get effectivePrice => discountPrice ?? basePrice;
  bool get hasDiscount => discountPrice != null && discountPrice! < basePrice;
  int get discountPercent =>
      hasDiscount ? (((basePrice - discountPrice!) / basePrice) * 100).round() : 0;

  factory Product.fromMap(String id, Map<String, dynamic> m, {List<ProductVariant>? variants}) {
    ProductCondition condFrom(String? s) => s == 'used' ? ProductCondition.used : ProductCondition.brandNew;
    ProductGender genderFrom(String? s) {
      switch (s) {
        case 'men':   return ProductGender.men;
        case 'women': return ProductGender.women;
        case 'kids':  return ProductGender.kids;
        default:      return ProductGender.unisex;
      }
    }
    ApprovalStatus approvalFrom(String? s) {
      switch (s) {
        case 'pending':  return ApprovalStatus.pending;
        case 'rejected': return ApprovalStatus.rejected;
        default:         return ApprovalStatus.approved;
      }
    }

    return Product(
      id: id,
      vendorId: m['vendorId'] ?? '',
      storeId: m['storeId'] ?? '',
      storeName: m['storeName'] ?? '',
      title: m['title'] ?? '',
      description: m['description'] ?? '',
      brand: m['brand'] ?? '',
      categoryId: m['categoryId'] ?? '',
      subcategoryId: m['subcategoryId'],
      gender: genderFrom(m['gender']),
      condition: condFrom(m['condition']),
      basePrice: (m['basePrice'] as num?)?.toDouble() ?? 0,
      discountPrice: (m['discountPrice'] as num?)?.toDouble(),
      currency: m['currency'] ?? 'USD',
      images: List<String>.from(m['images'] ?? const []),
      tags: List<String>.from(m['tags'] ?? const []),
      sizes: List<String>.from(m['sizes'] ?? const []),
      colors: List<String>.from(m['colors'] ?? const []),
      totalStock: (m['totalStock'] as num?)?.toInt() ?? 0,
      isActive: m['isActive'] ?? true,
      approvalStatus: approvalFrom(m['approvalStatus']),
      rating: (m['rating'] as num?)?.toDouble() ?? 0,
      ratingCount: (m['ratingCount'] as num?)?.toInt() ?? 0,
      salesCount: (m['salesCount'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.tryParse(m['createdAt'] ?? '') ?? DateTime.now(),
      variants: variants ?? const [],
    );
  }
}
