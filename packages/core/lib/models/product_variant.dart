class ProductVariant {
  final String id;
  final String size;
  final String color;     // hex or name
  final String? sku;
  final double? priceOverride;
  final int stock;
  final String? imageUrl;

  const ProductVariant({
    required this.id,
    required this.size,
    required this.color,
    this.sku,
    this.priceOverride,
    required this.stock,
    this.imageUrl,
  });

  factory ProductVariant.fromMap(String id, Map<String, dynamic> m) => ProductVariant(
        id: id,
        size: m['size'] ?? '',
        color: m['color'] ?? '',
        sku: m['sku'],
        priceOverride: (m['priceOverride'] as num?)?.toDouble(),
        stock: (m['stock'] as num?)?.toInt() ?? 0,
        imageUrl: m['imageUrl'],
      );

  Map<String, dynamic> toMap() => {
        'size': size,
        'color': color,
        'sku': sku,
        'priceOverride': priceOverride,
        'stock': stock,
        'imageUrl': imageUrl,
      };
}
