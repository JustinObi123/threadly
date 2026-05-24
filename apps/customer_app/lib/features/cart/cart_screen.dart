import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartStreamProvider = StreamProvider.autoDispose<List<CartItem>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const Stream.empty();
  return ref.watch(cartRepositoryProvider).watch(user.uid);
});

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final cart = ref.watch(cartStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: cart.when(
        loading: () => const LoadingView(),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (items) {
          if (items.isEmpty) {
            return const EmptyState(
              icon: Icons.shopping_bag_outlined,
              title: 'Your cart is empty',
              message: 'Add a few pieces to get started.',
            );
          }
          final subtotal = items.fold<double>(0, (s, i) => s + i.lineTotal);
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) => _CartRow(item: items[i], userId: user!.uid),
                ),
              ),
              _CheckoutBar(subtotal: subtotal),
            ],
          );
        },
      ),
    );
  }
}

class _CartRow extends ConsumerWidget {
  final CartItem item;
  final String userId;
  const _CartRow({required this.item, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(cartRepositoryProvider);
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Tokens.border(context)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: 80, height: 100,
            child: item.imageUrl.isEmpty
                ? Container(color: Tokens.surfaceAlt(context))
                : CachedNetworkImage(imageUrl: item.imageUrl, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.title, style: t.titleMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text('${item.size} · ${item.color}',
                style: t.bodySmall?.copyWith(color: Tokens.textSecondary(context))),
            const SizedBox(height: 8),
            Row(children: [
              Text(Money.format(item.lineTotal), style: t.titleMedium),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () => repo.updateQty(userId, item.variantId, item.qty - 1),
              ),
              Text('${item.qty}', style: t.titleMedium),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => repo.updateQty(userId, item.variantId, item.qty + 1),
              ),
            ]),
          ],
        )),
      ]),
    );
  }
}

class _CheckoutBar extends StatelessWidget {
  final double subtotal;
  const _CheckoutBar({required this.subtotal});
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          border: Border(top: BorderSide(color: Tokens.border(context))),
        ),
        child: Column(children: [
          Row(children: [
            Text('Subtotal', style: t.bodyMedium),
            const Spacer(),
            Text(Money.format(subtotal), style: t.titleLarge),
          ]),
          const SizedBox(height: 12),
          PrimaryButton(
            label: 'Checkout',
            icon: Icons.lock_outline,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Checkout arrives in Phase 3 (Stripe)')),
              );
            },
          ),
        ]),
      ),
    );
  }
}
