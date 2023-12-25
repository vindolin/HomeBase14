import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:home_base_14/pages/remotes/remotes_widget.dart';

import 'package:ir_sensor_plugin/ir_sensor_plugin.dart';

import '/utils.dart';
import '/widgets/connection_bar_widget.dart';

class RemotesPage extends ConsumerWidget {
  const RemotesPage({super.key});

  Container createIconButton(String text, String hexCode) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 240),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        onTap: () async {
          await IrSensorPlugin.transmitString(pattern: hexCode);
        },
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontFamily: 'NerdFont', fontSize: 30),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('RemotesPage.build()');
    return Scaffold(
        appBar: AppBar(
          title: const Text('Remotes'),
          actions: const [ConnectionBar()],
        ),
        body: const SingleChildScrollView(
          child: RemotesWidget(),
        ));
  }
}
