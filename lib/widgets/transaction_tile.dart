import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction_model.dart';
import '../models/transaction_type.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({
    super.key,
    required this.item,
    this.onDelete,
    this.onEdit,
  });

  final TransactionModel item;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final isIncome = item.type == TransactionType.income;

    return Dismissible(
      key: ValueKey(item.id),
      background: Container(
        color: Colors.blueGrey,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onEdit?.call();
          return false;
        }
        onDelete?.call();
        return true;
      },
      child: Card(
        child: ListTile(
          title: Text(item.title),
          subtitle: Text('${item.category} • ${DateFormat.yMMMd().format(item.date)}'),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isIncome ? '+' : '-'}\$${item.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  color: isIncome ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (item.isRecurring)
                const Text('Recurring', style: TextStyle(fontSize: 10, color: Colors.orange)),
            ],
          ),
        ),
      ),
    );
  }
}
