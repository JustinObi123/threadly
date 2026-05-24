class Store {
  final String id;
  final String vendorId;
  final String name;
  final String slug;
  final String? logoUrl;
  final String? bannerUrl;
  final String description;
  final double rating;
  final int ratingCount;
  final String? returnPolicy;
  final bool isActive;

  const Store({
    required this.id,
    required this.vendorId,
    required this.name,
    required this.slug,
    this.logoUrl,
    this.bannerUrl,
    this.description = '',
    this.rating = 0,
    this.ratingCount = 0,
    this.returnPolicy,
    this.isActive = true,
  });

  factory Store.fromMap(String id, Map<String, dynamic> m) => Store(
        id: id,
        vendorId: m['vendorId'] ?? '',
        name: m['name'] ?? '',
        slug: m['slug'] ?? '',
        logoUrl: m['logoUrl'],
        bannerUrl: m['bannerUrl'],
        description: m['description'] ?? '',
        rating: (m['rating'] as num?)?.toDouble() ?? 0,
        ratingCount: (m['ratingCount'] as num?)?.toInt() ?? 0,
        returnPolicy: m['returnPolicy'],
        isActive: m['isActive'] ?? true,
      );
}
