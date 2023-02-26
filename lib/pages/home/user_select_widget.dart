import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/models/app_settings.dart';

class UserSelect extends ConsumerWidget {
  const UserSelect({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appSettings = ref.watch(appSettingsProvider);

    void submitForm(User? user) async {
      ref.read(appSettingsProvider.notifier).saveUser(user!);
      await ref.read(appSettingsProvider.notifier).persistConnectionData();
    }

    return ListView(children: [
      const DrawerHeader(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/rivig.jpg'),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Text('Settings'),
      ),
      RadioListTile<User>(
        title: const Text('Thomas'),
        value: User.thomas,
        selected: appSettings.user == User.thomas,
        groupValue: appSettings.user,
        onChanged: submitForm,
      ),
      RadioListTile<User>(
        title: const Text('Mona'),
        value: User.mona,
        selected: appSettings.user == User.mona,
        groupValue: appSettings.user,
        onChanged: submitForm,
      ),
    ]);
  }
}
