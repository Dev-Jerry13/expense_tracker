import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/transaction_type.dart';
import '../../providers/app_providers.dart';

class ReportsView extends ConsumerWidget {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(transactionsControllerProvider)
        .where((e) => e.type == TransactionType.expense)
        .toList();

    final byCategory = <String, double>{};
    final byMonth = <int, double>{};

    for (final t in items) {
      byCategory[t.category] = (byCategory[t.category] ?? 0) + t.amount;
      byMonth[t.date.month] = (byMonth[t.date.month] ?? 0) + t.amount;
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Category Spend', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: PieChart(
            PieChartData(
              sections: byCategory.entries
                  .map(
                    (e) => PieChartSectionData(
                      value: e.value,
                      title: e.key,
                      radius: 70,
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text('Monthly Spend', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: BarChart(
            BarChartData(
              barGroups: byMonth.entries
                  .map((e) => BarChartGroupData(x: e.key, barRods: [BarChartRodData(toY: e.value)]))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
