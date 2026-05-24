import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _trendingProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(productRepositoryProvider).trending(limit: 8),
);
final _newArrivalsProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(productRepositoryProvider).newArrivals(limit: 8),
);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trending = ref.watch(_trendingProvider);
    final newArrivals = ref.watch(_newArrivalsProvider);

    return Scaffold(
      backgroundColor: Tokens.background(context),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(_trendingProvider);
            ref.invalidate(_newArrivalsProvider);
          },
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: _TopBar()),
              const SliverToBoxAdapter(child: _SearchBar()),
              SliverToBoxAdapter(child: SectionTitle('Explore the Categories', onSeeAll: () => context.push('/catalog'))),
              const SliverToBoxAdapter(child: _CategoryStrip()),
              const SliverToBoxAdapter(child: _Banner()),
              SliverToBoxAdapter(child: SectionTitle('Trending now', onSeeAll: () => context.push('/catalog'))),
              SliverToBoxAdapter(child: _HorizontalProducts(asyncList: trending)),
              SliverToBoxAdapter(child: SectionTitle('New arrivals', onSeeAll: () => context.push('/catalog'))),
              SliverToBoxAdapter(child: _HorizontalProducts(asyncList: newArrivals)),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends ConsumerWidget {
  const _TopBar();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: Tokens.surfaceAlt(context),
          backgroundImage: user?.photoUrl != null ? NetworkImage(user!.photoUrl!) : null,
          child: user?.photoUrl == null
              ? Icon(Icons.person, size: 22, color: Tokens.textPrimary(context))
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user?.displayName ?? 'Welcome',
                style: t.bodySmall?.copyWith(color: Tokens.textSecondary(context))),
            const SizedBox(height: 2),
            Row(children: [
              const AppIcon(AppIcons.locationPin, size: 14, color: AppColors.primary),
              const SizedBox(width: 4),
              Flexible(
                child: Text('Set delivery address',
                    style: t.titleSmall,
                    overflow: TextOverflow.ellipsis),
              ),
              Icon(Icons.keyboard_arrow_down, size: 18, color: Tokens.textPrimary(context)),
            ]),
          ],
        )),
        InkWell(
          onTap: () => context.push('/cart'),
          borderRadius: BorderRadius.circular(50),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Tokens.surface(context),
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Tokens.subtleShadow(context), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: AppIcon(AppIcons.cart, size: 22, color: Tokens.textPrimary(context)),
          ),
        ),
      ]),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
        child: InkWell(
          onTap: () => context.push('/catalog'),
          borderRadius: BorderRadius.circular(40),
          child: Container(
            height: 58,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              color: Tokens.surface(context),
              borderRadius: BorderRadius.circular(40),
              boxShadow: [BoxShadow(color: Tokens.subtleShadow(context), blurRadius: 18, offset: const Offset(0, 6))],
            ),
            child: Row(children: [
              AppIcon(AppIcons.search, size: 22, color: Tokens.textPrimary(context)),
              const SizedBox(width: 12),
              Text('Search items, brands, vendors…',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Tokens.textSecondary(context))),
            ]),
          ),
        ),
      );
}

class _CategoryStrip extends StatelessWidget {
  const _CategoryStrip();

  static const _emojis = {
    'men': '👔', 'women': '👗', 'kids': '🧒', 'shoes': '👟',
    'accessories': '👜', 'streetwear': '🧢', 'formalwear': '🤵',
    'sportswear': '🏃', 'luxury': '💎', 'thrift': '♻️',
  };

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 110,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          scrollDirection: Axis.horizontal,
          itemCount: TopCategories.seed.length,
          separatorBuilder: (_, __) => const SizedBox(width: 14),
          itemBuilder: (_, i) {
            final c = TopCategories.seed[i];
            return InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () => context.push('/catalog?category=${c.id}'),
              child: Column(children: [
                Container(
                  width: 70, height: 70,
                  decoration: BoxDecoration(
                    color: Tokens.surface(context),
                    shape: BoxShape.circle,
                    border: Border.all(color: Tokens.border(context)),
                  ),
                  alignment: Alignment.center,
                  child: Text(_emojis[c.id] ?? '👕', style: const TextStyle(fontSize: 30)),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 76,
                  child: Text(c.name,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.primary, fontWeight: FontWeight.w600)),
                ),
              ]),
            );
          },
        ),
      );
}

class _Banner extends StatelessWidget {
  const _Banner();
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
        child: Container(
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [AppColors.primary, Color(0xFFFF914D)],
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Row(children: [
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Spring Drop',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white)),
                const SizedBox(height: 6),
                const Text('Up to 40% off curated streetwear.',
                    style: TextStyle(color: Colors.white, fontFamily: 'Urbanist', package: 'core')),
              ],
            )),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
              child: const Icon(Icons.arrow_forward, color: Colors.white),
            ),
          ]),
        ),
      );
}

class _HorizontalProducts extends StatelessWidget {
  final AsyncValue<List<Product>> asyncList;
  const _HorizontalProducts({required this.asyncList});
  @override
  Widget build(BuildContext context) {
    return asyncList.when(
      loading: () => const SizedBox(height: 320, child: LoadingView()),
      error: (e, _) => SizedBox(height: 120, child: Center(child: Text("Couldn't load: $e"))),
      data: (items) {
        if (items.isEmpty) {
          return const SizedBox(
            height: 140,
            child: EmptyState(icon: Icons.checkroom, title: 'No products yet'),
          );
        }
        return SizedBox(
          height: 340,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (_, i) => SizedBox(
              width: 180,
              child: ProductCard(
                product: items[i],
                onTap: () => context.push('/product/${items[i].id}'),
              ),
            ),
          ),
        );
      },
    );
  }
}
