import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/transaction_type.dart';
import '../../providers/app_providers.dart';
import '../../widgets/summary_card.dart';

class DashboardView extends ConsumerWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(transactionsControllerProvider);
    final service = ref.watch(transactionServiceProvider);
    final income = service.incomeTotal(items);
    final expense = service.expenseTotal(items);
    final balance = income - expense;

    final recent = items.take(4).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Overview', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            SummaryCard(label: 'Balance', value: '\$${balance.toStringAsFixed(2)}', icon: Icons.account_balance_wallet, color: Colors.blue),
            SummaryCard(label: 'Income', value: '\$${income.toStringAsFixed(2)}', icon: Icons.arrow_downward, color: Colors.green),
            SummaryCard(label: 'Expenses', value: '\$${expense.toStringAsFixed(2)}', icon: Icons.arrow_upward, color: Colors.red),
            SummaryCard(label: 'Transactions', value: '${items.length}', icon: Icons.receipt_long, color: Colors.orange),
          ],
        ),
        const SizedBox(height: 18),
        Text('Recent', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        ...recent.map(
          (e) => ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(e.title),
            subtitle: Text(e.category),
            trailing: Text(
              '${e.type == TransactionType.income ? '+' : '-'}\$${e.amount.toStringAsFixed(2)}',
              style: TextStyle(color: e.type == TransactionType.income ? Colors.green : Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}
