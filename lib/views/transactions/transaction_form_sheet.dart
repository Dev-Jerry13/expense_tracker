import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/validators.dart';
import '../../models/transaction_model.dart';
import '../../models/transaction_type.dart';

class TransactionFormSheet extends StatefulWidget {
  const TransactionFormSheet({super.key, this.initial});

  final TransactionModel? initial;

  @override
  State<TransactionFormSheet> createState() => _TransactionFormSheetState();
}

class _TransactionFormSheetState extends State<TransactionFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _amount;
  late final TextEditingController _note;
  late TransactionType _type;
  late String _category;
  late DateTime _date;
  bool _recurring = false;

  @override
  void initState() {
    super.initState();
    final i = widget.initial;
    _title = TextEditingController(text: i?.title ?? '');
    _amount = TextEditingController(text: i?.amount.toString() ?? '');
    _note = TextEditingController(text: i?.note ?? '');
    _type = i?.type ?? TransactionType.expense;
    _category = i?.category ?? AppConstants.categories.first;
    _date = i?.date ?? DateTime.now();
    _recurring = i?.isRecurring ?? false;
  }

  @override
  void dispose() {
    _title.dispose();
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final model = TransactionModel(
      id: widget.initial?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: _title.text.trim(),
      amount: double.parse(_amount.text),
      type: _type,
      category: _category,
      date: _date,
      note: _note.text.trim(),
      isRecurring: _recurring,
    );
    Navigator.pop(context, model);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.initial == null ? 'Add Transaction' : 'Edit Transaction',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _title,
                  validator: (v) => Validators.requiredField(v, field: 'Title'),
                  decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _amount,
                  keyboardType: TextInputType.number,
                  validator: Validators.amount,
                  decoration: const InputDecoration(labelText: 'Amount', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<TransactionType>(
                  value: _type,
                  items: TransactionType.values
                      .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                      .toList(),
                  onChanged: (v) => setState(() => _type = v!),
                  decoration: const InputDecoration(labelText: 'Type', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _category,
                  items: AppConstants.categories
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => _category = v!),
                  decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                ),
                SwitchListTile.adaptive(
                  value: _recurring,
                  onChanged: (v) => setState(() => _recurring = v),
                  title: const Text('Recurring transaction'),
                ),
                TextFormField(
                  controller: _note,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'Note', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: Text('Date: ${_date.toLocal().toString().split(' ').first}')),
                    TextButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _date,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) setState(() => _date = picked);
                      },
                      child: const Text('Pick date'),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                FilledButton(onPressed: _save, child: const Text('Save')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
