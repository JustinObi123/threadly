import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Render a packaged SVG icon by name (without extension).
/// Usage: AppIcon('ic_home', size: 24, color: AppColors.primary)
class AppIcon extends StatelessWidget {
  final String name;
  final double size;
  final Color? color;

  const AppIcon(this.name, {super.key, this.size = 24, this.color});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/$name.svg',
      package: 'core',
      width: size,
      height: size,
      colorFilter: color == null ? null : ColorFilter.mode(color!, BlendMode.srcIn),
    );
  }
}

/// Quick reference for the icons bundled in this package.
class AppIcons {
  AppIcons._();
  static const home          = 'ic_home';
  static const search        = 'ic_search';
  static const cart          = 'ic_shoping_cart';
  static const favorite      = 'ic_fav';
  static const favoriteFill  = 'ic_like_fill';
  static const profile       = 'ic_profile';
  static const orders        = 'ic_orders';
  static const location      = 'ic_location';
  static const locationPin   = 'ic_location_pin';
  static const mail          = 'ic_mail';
  static const lock          = 'ic_lock';
  static const eye           = 'ic_password_show';
  static const eyeOff        = 'ic_password_close';
  static const phone         = 'ic_phone';
  static const apple         = 'ic_apple';
  static const google        = 'ic_google';
  static const close         = 'ic_close';
  static const edit          = 'ic_edit';
  static const delete        = 'ic_delete';
  static const plus          = 'ic_plus';
  static const share         = 'ic_share';
  static const send          = 'ic_send';
  static const copy          = 'ic_copy';
  static const chevronDown   = 'ic_down';
  static const help          = 'ic_help_support';
  static const privacy       = 'ic_privacy_policy';
  static const logout        = 'ic_logout';
  static const language      = 'ic_change_language';
  static const theme         = 'ic_light_dark';
  static const refer         = 'ic_refer';
  static const history       = 'ic_history';
  static const rate          = 'ic_rate';
  static const wallet        = 'ic_wallet';
  static const credit        = 'ic_credit';
  static const debit         = 'ic_debit';
  static const giftCode      = 'ic_gift_code';
  static const cashback      = 'ic_cashback_Offer';
  static const freeDelivery  = 'ic_free_delivery';
  static const homeAdd       = 'ic_home_add';
}
