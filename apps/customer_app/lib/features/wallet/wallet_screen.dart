import 'package:core/core.dart';
import 'package:flutter/material.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Tokens.background(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PageHeader(
                title: 'My Wallet',
                subtitle: 'Track your balance, transactions, and payment methods.',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft, end: Alignment.bottomRight,
                      colors: [AppColors.walletStart, AppColors.walletEnd],
                    ),
                  ),
                  child: Column(children: [
                    Text('My Wallet',
                        style: t.titleSmall?.copyWith(color: AppColors.primarySoft)),
                    const SizedBox(height: 8),
                    Text(r'$ 0.00',
                        style: t.displayMedium?.copyWith(color: Colors.white)),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.walletCta,
                          foregroundColor: const Color(0xFF0E1430),
                        ),
                        child: const Text('Top up'),
                      ),
                    ),
                  ]),
                ),
              ),
              const SizedBox(height: 40),
              const EmptyState(
                icon: Icons.receipt_long_outlined,
                title: 'Transaction not found',
                message: 'Your past wallet activity will show up here.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
