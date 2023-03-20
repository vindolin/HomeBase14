import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '/models/app_settings.dart';

class UserSelect extends ConsumerWidget {
  const UserSelect({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appSettings = ref.watch(appSettingsProvider);

    void submitUser(User? user) async {
      ref.read(appSettingsProvider.notifier).saveUser(user!);
      await ref.read(appSettingsProvider.notifier).persistConnectionData();
    }

    void submitOnlyPortraitrientation(bool onlyPortrait) async {
      ref.read(appSettingsProvider.notifier).saveOnlyPortrait(onlyPortrait);
      await ref.read(appSettingsProvider.notifier).persistConnectionData();
    }

    return ListView(children: [
      DrawerHeader(
        decoration: BoxDecoration(
          image: DecorationImage(
            filterQuality: FilterQuality.medium,
            image: appSettings.user == User.thomas
                ? const AssetImage('assets/images/rivig.jpg')
                : const AssetImage('assets/images/lina.jpg'),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Text(translate('settings')),
      ),
      ListTile(
        title: Text(translate('user')),
      ),
      RadioListTile<User>(
        dense: true,
        title: const Text('Thomas'),
        value: User.thomas,
        selected: appSettings.user == User.thomas,
        groupValue: appSettings.user,
        onChanged: submitUser,
      ),
      RadioListTile<User>(
        dense: true,
        title: const Text('Mona'),
        value: User.mona,
        selected: appSettings.user == User.mona,
        groupValue: appSettings.user,
        onChanged: submitUser,
      ),
      const ListTile(
        title: Text('Sonstiges'),
      ),
      CheckboxListTile(
        value: appSettings.onlyPortrait,
        onChanged: (value) {
          submitOnlyPortraitrientation(value == true);
        },
        title: const Text('Nur Hochformat'),
        selected: appSettings.onlyPortrait,
      )
    ]);
  }
}
