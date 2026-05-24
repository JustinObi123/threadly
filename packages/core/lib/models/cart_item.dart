class CartItem {
  final String productId;
  final String variantId;
  final String vendorId;
  final String title;
  final String imageUrl;
  final String size;
  final String color;
  final double unitPrice;
  final int qty;

  const CartItem({
    required this.productId,
    required this.variantId,
    required this.vendorId,
    required this.title,
    required this.imageUrl,
    required this.size,
    required this.color,
    required this.unitPrice,
    required this.qty,
  });

  CartItem copyWith({int? qty}) => CartItem(
        productId: productId,
        variantId: variantId,
        vendorId: vendorId,
        title: title,
        imageUrl: imageUrl,
        size: size,
        color: color,
        unitPrice: unitPrice,
        qty: qty ?? this.qty,
      );

  double get lineTotal => unitPrice * qty;

  Map<String, dynamic> toMap() => {
        'productId': productId,
        'variantId': variantId,
        'vendorId': vendorId,
        'title': title,
        'imageUrl': imageUrl,
        'size': size,
        'color': color,
        'unitPrice': unitPrice,
        'qty': qty,
      };

  factory CartItem.fromMap(Map<String, dynamic> m) => CartItem(
        productId: m['productId'],
        variantId: m['variantId'],
        vendorId: m['vendorId'],
        title: m['title'],
        imageUrl: m['imageUrl'] ?? '',
        size: m['size'] ?? '',
        color: m['color'] ?? '',
        unitPrice: (m['unitPrice'] as num).toDouble(),
        qty: (m['qty'] as num).toInt(),
      );
}
