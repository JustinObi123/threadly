import '../models/cart_item.dart';

abstract class CartRepository {
  Stream<List<CartItem>> watch(String userId);
  Future<List<CartItem>> get(String userId);
  Future<void> addItem(String userId, CartItem item);
  Future<void> updateQty(String userId, String variantId, int qty);
  Future<void> removeItem(String userId, String variantId);
  Future<void> clear(String userId);
}
