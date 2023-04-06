import 'package:flutter/material.dart';
import '/models/app_settings.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final encrypted = encrypter.encrypt('testkey', iv: iv);
    // ignore: avoid_print
    print(encrypted.base64);
    return Container();
  }
}
