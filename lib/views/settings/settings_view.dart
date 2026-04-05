import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/app_providers.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return ListView(
      children: [
        SwitchListTile(
          title: const Text('Dark mode'),
          value: themeMode == ThemeMode.dark,
          onChanged: (v) => ref.read(themeModeProvider.notifier).state =
              v ? ThemeMode.dark : ThemeMode.light,
        ),
        ListTile(
          leading: const Icon(Icons.file_download),
          title: const Text('Export transactions as CSV'),
          onTap: () async {
            final transactions = ref.read(transactionsControllerProvider);
            final rows = [
              ['id', 'title', 'amount', 'type', 'category', 'date', 'note']
            ];
            for (final t in transactions) {
              rows.add([
                t.id,
                t.title,
                t.amount,
                t.type.name,
                t.category,
                t.date.toIso8601String(),
                t.note,
              ]);
            }
            final csv = const ListToCsvConverter().convert(rows);
            final path = '${Directory.systemTemp.path}/expense_export.csv';
            await File(path).writeAsString(csv);
            if (context.mounted) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('CSV exported to $path')));
            }
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: () => ref.read(authControllerProvider.notifier).logout(),
        ),
      ],
    );
  }
}
