import 'package:flutter/material.dart';
import '../models/product.dart';
import '../theme/app_colors.dart';
import '../theme/tokens.dart';
import '../utils/formatters.dart';

class PriceTag extends StatelessWidget {
  final Product product;
  final double fontSize;

  const PriceTag({super.key, required this.product, this.fontSize = 14});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    if (!product.hasDiscount) {
      return Text(
        Money.format(product.basePrice, currency: product.currency),
        style: t.titleMedium?.copyWith(fontSize: fontSize),
      );
    }
    return Wrap(
      spacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          Money.format(product.discountPrice!, currency: product.currency),
          style: t.titleMedium?.copyWith(fontSize: fontSize, color: AppColors.danger),
        ),
        Text(
          Money.format(product.basePrice, currency: product.currency),
          style: t.bodySmall?.copyWith(
            fontSize: fontSize - 2,
            color: Tokens.textMuted(context),
            decoration: TextDecoration.lineThrough,
          ),
        ),
      ],
    );
  }
}
