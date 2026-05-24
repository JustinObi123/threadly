import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cart_item.dart';
import 'cart_repository.dart';

/// Cart is stored as a single document per user: carts/{uid}
/// `items` is an array of maps. Small enough for a fashion-shop cart.
class FirestoreCartRepository implements CartRepository {
  FirestoreCartRepository({FirebaseFirestore? db})
      : _col = (db ?? FirebaseFirestore.instance).collection('carts');

  final CollectionReference<Map<String, dynamic>> _col;

  DocumentReference<Map<String, dynamic>> _doc(String uid) => _col.doc(uid);

  List<CartItem> _decode(Map<String, dynamic>? data) {
    final raw = (data?['items'] as List?) ?? const [];
    return raw.map((e) => CartItem.fromMap(Map<String, dynamic>.from(e as Map))).toList();
  }

  @override
  Stream<List<CartItem>> watch(String userId) =>
      _doc(userId).snapshots().map((s) => _decode(s.data()));

  @override
  Future<List<CartItem>> get(String userId) async =>
      _decode((await _doc(userId).get()).data());

  Future<void> _writeAll(String userId, List<CartItem> items) =>
      _doc(userId).set({
        'items': items.map((i) => i.toMap()).toList(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

  @override
  Future<void> addItem(String userId, CartItem item) async {
    final items = await get(userId);
    final idx = items.indexWhere((i) => i.variantId == item.variantId);
    if (idx >= 0) {
      items[idx] = items[idx].copyWith(qty: items[idx].qty + item.qty);
    } else {
      items.add(item);
    }
    await _writeAll(userId, items);
  }

  @override
  Future<void> updateQty(String userId, String variantId, int qty) async {
    final items = await get(userId);
    final idx = items.indexWhere((i) => i.variantId == variantId);
    if (idx < 0) return;
    if (qty <= 0) {
      items.removeAt(idx);
    } else {
      items[idx] = items[idx].copyWith(qty: qty);
    }
    await _writeAll(userId, items);
  }

  @override
  Future<void> removeItem(String userId, String variantId) async {
    final items = await get(userId);
    items.removeWhere((i) => i.variantId == variantId);
    await _writeAll(userId, items);
  }

  @override
  Future<void> clear(String userId) => _doc(userId).delete();
}
