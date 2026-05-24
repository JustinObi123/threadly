// Barrel file — apps import only from package:core/core.dart
library core;

// Theme
export 'theme/app_colors.dart';
export 'theme/app_typography.dart';
export 'theme/app_theme.dart';
export 'theme/tokens.dart';

// Models
export 'models/address.dart';
export 'models/app_user.dart';
export 'models/category.dart';
export 'models/cart_item.dart';
export 'models/product.dart';
export 'models/product_variant.dart';
export 'models/store.dart';

// Repositories
export 'repositories/auth_repository.dart';
export 'repositories/product_repository.dart';
export 'repositories/cart_repository.dart';
export 'repositories/firebase_auth_repository.dart';
export 'repositories/firestore_product_repository.dart';
export 'repositories/firestore_cart_repository.dart';

// Providers
export 'config/providers.dart';
export 'config/env.dart';

// Widgets
export 'widgets/app_icon.dart';
export 'widgets/page_header.dart';
export 'widgets/product_card.dart';
export 'widgets/price_tag.dart';
export 'widgets/primary_button.dart';
export 'widgets/empty_state.dart';
export 'widgets/loading_view.dart';

// Utils
export 'utils/validators.dart';
export 'utils/formatters.dart';
