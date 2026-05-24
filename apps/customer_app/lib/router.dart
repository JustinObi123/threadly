import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/auth/login_screen.dart';
import 'features/auth/signup_screen.dart';
import 'features/auth/splash_screen.dart';
import 'features/cart/cart_screen.dart';
import 'features/catalog/catalog_screen.dart';
import 'features/favourites/favourites_screen.dart';
import 'features/home/home_screen.dart';
import 'features/misc/coming_soon_screen.dart';
import 'features/orders/orders_screen.dart';
import 'features/product/product_detail_screen.dart';
import 'features/profile/profile_info_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/shell/main_shell.dart';
import 'features/wallet/wallet_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: _AuthListenable(ref),
    redirect: (context, state) {
      final loggedIn   = auth.value != null;
      final loading    = auth.isLoading;
      final atAuthPage = state.matchedLocation == '/login' ||
                         state.matchedLocation == '/signup' ||
                         state.matchedLocation == '/splash';

      if (loading) return '/splash';
      if (!loggedIn && !atAuthPage) return '/login';
      if (loggedIn  && atAuthPage)  return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/login',  builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/signup', builder: (_, __) => const SignupScreen()),

      ShellRoute(
        builder: (_, __, child) => MainShell(child: child),
        routes: [
          GoRoute(path: '/',           builder: (_, __) => const HomeScreen()),
          GoRoute(path: '/favourites', builder: (_, __) => const FavouritesScreen()),
          GoRoute(path: '/wallet',     builder: (_, __) => const WalletScreen()),
          GoRoute(path: '/orders',     builder: (_, __) => const OrdersScreen()),
          GoRoute(path: '/profile',    builder: (_, __) => const ProfileScreen()),
        ],
      ),

      GoRoute(path: '/cart', builder: (_, __) => const CartScreen()),
      GoRoute(
        path: '/catalog',
        builder: (_, state) {
          final cat = state.uri.queryParameters['category'];
          return CatalogScreen(categoryId: cat);
        },
      ),
      GoRoute(
        path: '/product/:id',
        builder: (_, state) => ProductDetailScreen(productId: state.pathParameters['id']!),
      ),

      // Profile sub-screens
      GoRoute(path: '/profile/info',      builder: (_, __) => const ProfileInfoScreen()),
      GoRoute(path: '/profile/addresses', builder: (_, __) =>
          const ComingSoonScreen(title: 'My Addresses',     icon: Icons.location_on_outlined)),
      GoRoute(path: '/profile/gift-cards', builder: (_, __) =>
          const ComingSoonScreen(title: 'Gift Cards',       icon: Icons.card_giftcard)),
      GoRoute(path: '/profile/cashback', builder: (_, __) =>
          const ComingSoonScreen(title: 'Cashback Offers',  icon: Icons.local_offer_outlined)),
      GoRoute(path: '/profile/language', builder: (_, __) =>
          const ComingSoonScreen(title: 'Change Language',  icon: Icons.language)),
      GoRoute(path: '/profile/refer',    builder: (_, __) =>
          const ComingSoonScreen(title: 'Refer a Friend',   icon: Icons.group_add_outlined)),
      GoRoute(path: '/profile/vendor-inbox', builder: (_, __) =>
          const ComingSoonScreen(title: 'Vendor Inbox',     icon: Icons.chat_bubble_outline)),
      GoRoute(path: '/profile/driver-inbox', builder: (_, __) =>
          const ComingSoonScreen(title: 'Driver Inbox',     icon: Icons.chat_bubble_outline)),
      GoRoute(path: '/profile/help',     builder: (_, __) =>
          const ComingSoonScreen(title: 'Help & Support',   icon: Icons.help_outline)),
      GoRoute(path: '/profile/privacy',  builder: (_, __) =>
          const ComingSoonScreen(title: 'Privacy Policy',   icon: Icons.privacy_tip_outlined)),
      GoRoute(path: '/profile/terms',    builder: (_, __) =>
          const ComingSoonScreen(title: 'Terms & Conditions', icon: Icons.menu_book_outlined)),
    ],
  );
});

class _AuthListenable extends ChangeNotifier {
  _AuthListenable(Ref ref) {
    ref.listen(authStateProvider, (_, __) => notifyListeners());
  }
}
