import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../theme/app_colors.dart';
import '../theme/tokens.dart';
import 'price_tag.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final bool isFavorite;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onFavorite,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 4 / 5,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: product.images.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: product.images.first,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          placeholder: (_, __) => Container(color: Tokens.surfaceAlt(context)),
                          errorWidget: (_, __, ___) => Container(
                            color: Tokens.surfaceAlt(context),
                            child: const Icon(Icons.image_not_supported_outlined),
                          ),
                        )
                      : Container(color: Tokens.surfaceAlt(context)),
                ),
                if (product.hasDiscount)
                  Positioned(
                    top: 8, left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.danger,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text('-${product.discountPercent}%',
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                    ),
                  ),
                Positioned(
                  top: 4, right: 4,
                  child: IconButton(
                    onPressed: onFavorite,
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? AppColors.danger : Colors.white,
                      shadows: const [Shadow(blurRadius: 4, color: Colors.black54)],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(product.storeName,
              style: t.bodySmall?.copyWith(color: Tokens.textSecondary(context)),
              maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Text(product.title,
              style: t.titleMedium?.copyWith(fontSize: 14, color: Tokens.textPrimary(context)),
              maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          PriceTag(product: product),
          if (product.ratingCount > 0) ...[
            const SizedBox(height: 4),
            Row(children: [
              const Icon(Icons.star_rounded, size: 14, color: AppColors.warning),
              const SizedBox(width: 2),
              Text(product.rating.toStringAsFixed(1),
                  style: t.bodySmall?.copyWith(color: Tokens.textPrimary(context))),
              Text('  (${product.ratingCount})',
                  style: t.bodySmall?.copyWith(color: Tokens.textMuted(context))),
            ]),
          ],
        ],
      ),
    );
  }
}
