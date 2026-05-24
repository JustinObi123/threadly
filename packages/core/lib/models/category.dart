class Category {
  final String id;
  final String name;
  final String slug;
  final String? parentId;
  final String? iconUrl;
  final int order;

  const Category({
    required this.id,
    required this.name,
    required this.slug,
    this.parentId,
    this.iconUrl,
    this.order = 0,
  });

  factory Category.fromMap(String id, Map<String, dynamic> m) => Category(
        id: id,
        name: m['name'] ?? '',
        slug: m['slug'] ?? '',
        parentId: m['parentId'],
        iconUrl: m['iconUrl'],
        order: m['order'] ?? 0,
      );
}

class TopCategories {
  static const List<Category> seed = [
    Category(id: 'men',         name: 'Men',         slug: 'men',         order: 1),
    Category(id: 'women',       name: 'Women',       slug: 'women',       order: 2),
    Category(id: 'kids',        name: 'Kids',        slug: 'kids',        order: 3),
    Category(id: 'shoes',       name: 'Shoes',       slug: 'shoes',       order: 4),
    Category(id: 'accessories', name: 'Accessories', slug: 'accessories', order: 5),
    Category(id: 'streetwear',  name: 'Streetwear',  slug: 'streetwear',  order: 6),
    Category(id: 'formalwear',  name: 'Formalwear',  slug: 'formalwear',  order: 7),
    Category(id: 'sportswear',  name: 'Sportswear',  slug: 'sportswear',  order: 8),
    Category(id: 'luxury',      name: 'Luxury',      slug: 'luxury',      order: 9),
    Category(id: 'thrift',      name: 'Thrift',      slug: 'thrift',      order: 10),
  ];
}
