import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productByIdProvider = FutureProvider.autoDispose.family<Product?, String>((ref, id) {
  return ref.watch(productRepositoryProvider).getById(id);
});

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});
  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  String? _selectedSize;
  String? _selectedColor;
  int _imageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(productByIdProvider(widget.productId));
    return Scaffold(
      body: async.when(
        loading: () => const LoadingView(),
        error: (e, _) => Scaffold(appBar: AppBar(), body: Center(child: Text('Error: $e'))),
        data: (product) {
          if (product == null) {
            return const EmptyState(icon: Icons.error_outline, title: 'Product not found');
          }
          _selectedSize  ??= product.sizes.isNotEmpty  ? product.sizes.first  : null;
          _selectedColor ??= product.colors.isNotEmpty ? product.colors.first : null;
          return _Detail(
            product: product,
            imageIndex: _imageIndex,
            onImage: (i) => setState(() => _imageIndex = i),
            selectedSize: _selectedSize,
            selectedColor: _selectedColor,
            onSize: (s) => setState(() => _selectedSize = s),
            onColor: (c) => setState(() => _selectedColor = c),
          );
        },
      ),
    );
  }
}

class _Detail extends ConsumerWidget {
  final Product product;
  final int imageIndex;
  final ValueChanged<int> onImage;
  final String? selectedSize;
  final String? selectedColor;
  final ValueChanged<String> onSize;
  final ValueChanged<String> onColor;

  const _Detail({
    required this.product,
    required this.imageIndex,
    required this.onImage,
    required this.selectedSize,
    required this.selectedColor,
    required this.onSize,
    required this.onColor,
  });

  Future<void> _addToCart(BuildContext context, WidgetRef ref) async {
    final user = ref.read(currentUserProvider);
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please sign in')));
      return;
    }
    if (product.sizes.isNotEmpty && selectedSize == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Choose a size')));
      return;
    }
    // Match to a variant if present; otherwise synthesize an id.
    final variant = product.variants.where(
      (v) => v.size == selectedSize && v.color == selectedColor,
    ).cast<ProductVariant?>().firstOrNull;
    final variantId = variant?.id ?? '${product.id}_${selectedSize ?? '_'}_${selectedColor ?? '_'}';

    await ref.read(cartRepositoryProvider).addItem(
      user.uid,
      CartItem(
        productId: product.id,
        variantId: variantId,
        vendorId: product.vendorId,
        title: product.title,
        imageUrl: product.images.isNotEmpty ? product.images.first : '',
        size: selectedSize ?? '',
        color: selectedColor ?? '',
        unitPrice: variant?.priceOverride ?? product.effectivePrice,
        qty: 1,
      ),
    );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to cart')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final image = product.images.isNotEmpty ? product.images[imageIndex.clamp(0, product.images.length - 1)] : null;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 420,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: image == null
                ? Container(color: Tokens.surfaceAlt(context), child: const Icon(Icons.checkroom, size: 80))
                : CachedNetworkImage(imageUrl: image, fit: BoxFit.cover),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (product.images.length > 1)
                  SizedBox(
                    height: 64,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: product.images.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, i) => GestureDetector(
                        onTap: () => onImage(i),
                        child: Container(
                          width: 64,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: i == imageIndex ? AppColors.primary : Tokens.border(context),
                              width: i == imageIndex ? 2 : 1,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: CachedNetworkImage(imageUrl: product.images[i], fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Text(product.storeName, style: t.bodyMedium?.copyWith(color: Tokens.textSecondary(context))),
                const SizedBox(height: 4),
                Text(product.title, style: t.headlineMedium),
                const SizedBox(height: 8),
                PriceTag(product: product, fontSize: 20),
                if (product.ratingCount > 0) ...[
                  const SizedBox(height: 8),
                  Row(children: [
                    const Icon(Icons.star_rounded, color: AppColors.warning, size: 18),
                    const SizedBox(width: 4),
                    Text('${product.rating.toStringAsFixed(1)} (${product.ratingCount} reviews)',
                        style: t.bodyMedium),
                  ]),
                ],
                const SizedBox(height: 24),
                if (product.sizes.isNotEmpty) ...[
                  Text('Size', style: t.titleMedium),
                  const SizedBox(height: 8),
                  Wrap(spacing: 8, children: [
                    for (final s in product.sizes)
                      ChoiceChip(
                        label: Text(s),
                        selected: s == selectedSize,
                        onSelected: (_) => onSize(s),
                      ),
                  ]),
                  const SizedBox(height: 20),
                ],
                if (product.colors.isNotEmpty) ...[
                  Text('Color', style: t.titleMedium),
                  const SizedBox(height: 8),
                  Wrap(spacing: 8, children: [
                    for (final c in product.colors)
                      ChoiceChip(
                        label: Text(c),
                        selected: c == selectedColor,
                        onSelected: (_) => onColor(c),
                      ),
                  ]),
                  const SizedBox(height: 20),
                ],
                Text('Description', style: t.titleMedium),
                const SizedBox(height: 6),
                Text(product.description, style: t.bodyMedium),
                const SizedBox(height: 32),
                PrimaryButton(
                  label: 'Add to cart',
                  icon: Icons.shopping_bag_outlined,
                  onPressed: () => _addToCart(context, ref),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite_border),
                  label: const Text('Save to wishlist'),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
