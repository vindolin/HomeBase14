import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/models/mqtt_providers.dart';
import '/utils.dart';
import '/widgets/connection_bar_widget.dart';

class ThomasPage extends ConsumerWidget {
  const ThomasPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('ThomasPage.build()');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thomas'),
        actions: const [ConnectionBar()],
      ),
      body: const Center(
        child: DropdownButtonExample(),
      ),
    );
  }
}

class DropdownButtonExample extends ConsumerStatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  ConsumerState<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

const Map<String, String> options = {
  'none': '',
  'sleep': 'Sleep 😴',
  'hibernate': 'Hibernate 🐻',
};

class _DropdownButtonExampleState extends ConsumerState<DropdownButtonExample> {
  String dropdownValue = options.keys.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      onChanged: (String? value) {
        setState(() {
          print(value);
          dropdownValue = value!;
        });
      },
      items: options
          .map(
            (key, value) {
              return MapEntry(
                key,
                DropdownMenuItem<String>(
                  value: key,
                  child: Text(value),
                ),
              );
            },
          )
          .values
          .toList(),
    );
  }
}
