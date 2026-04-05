import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../models/transaction_type.dart';
import '../../providers/app_providers.dart';
import '../../widgets/transaction_tile.dart';
import 'transaction_form_sheet.dart';

class TransactionsView extends ConsumerWidget {
  const TransactionsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(filteredTransactionsProvider);
    final filter = ref.watch(transactionFilterProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              TextField(
                onChanged: (v) => ref.read(transactionFilterProvider.notifier).state =
                    filter.copyWith(search: v),
                decoration: const InputDecoration(
                  hintText: 'Search title/note',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String?>(
                      value: filter.category,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: [
                        const DropdownMenuItem<String?>(value: null, child: Text('All')),
                        ...AppConstants.categories
                            .map((e) => DropdownMenuItem<String?>(value: e, child: Text(e))),
                      ],
                      onChanged: (v) => ref.read(transactionFilterProvider.notifier).state =
                          filter.copyWith(clearCategory: v == null, category: v),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<TransactionType?>(
                      value: filter.type,
                      decoration: const InputDecoration(labelText: 'Type'),
                      items: const [
                        DropdownMenuItem<TransactionType?>(value: null, child: Text('All')),
                        DropdownMenuItem(value: TransactionType.income, child: Text('Income')),
                        DropdownMenuItem(value: TransactionType.expense, child: Text('Expense')),
                      ],
                      onChanged: (v) => ref.read(transactionFilterProvider.notifier).state =
                          filter.copyWith(clearType: v == null, type: v),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 120),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) {
              final item = items[i];
              return TransactionTile(
                item: item,
                onDelete: () => ref.read(transactionsControllerProvider.notifier).remove(item.id),
                onEdit: () async {
                  final result = await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => TransactionFormSheet(initial: item),
                  );
                  if (result is! TransactionModel) return;
                  await ref.read(transactionsControllerProvider.notifier).upsert(result);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
