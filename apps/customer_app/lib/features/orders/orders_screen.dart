import 'package:core/core.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  static const _filters = ['All', 'In Progress', 'Delivered', 'Cancelled', 'Returned'];
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Tokens.background(context),
      body: SafeArea(
        child: Column(
          children: [
            const PageHeader(
              title: 'My Orders',
              subtitle: 'Keep track of delivered, in-progress, and cancelled orders all in one place.',
            ),
            SizedBox(
              height: 56,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, i) {
                  final selected = i == _selected;
                  return ChoiceChip(
                    label: Text(_filters[i]),
                    selected: selected,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      fontFamily: 'Urbanist', package: 'core',
                      fontWeight: FontWeight.w700,
                      color: selected ? Colors.white : Tokens.textPrimary(context),
                    ),
                    onSelected: (_) => setState(() => _selected = i),
                  );
                },
              ),
            ),
            const Expanded(
              child: EmptyState(
                icon: Icons.shopping_bag_outlined,
                title: 'No orders yet',
                message: 'Once you place an order it will appear here.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
