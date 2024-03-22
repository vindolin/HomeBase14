import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '/models/app_settings.dart';

class SettingsForm extends ConsumerWidget {
  const SettingsForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appSettings = ref.watch(appSettingsProvider);

    return ListView(
      children: [
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
          onChanged: (value) => ref.read(appSettingsProvider.notifier).saveUser(value!),
        ),
        RadioListTile<User>(
          dense: true,
          title: const Text('Mona'),
          value: User.mona,
          selected: appSettings.user == User.mona,
          groupValue: appSettings.user,
          onChanged: (value) => ref.read(appSettingsProvider.notifier).saveUser(value!),
        ),
        const ListTile(
          title: Text('Sonstiges'),
        ),
        CheckboxListTile(
          value: appSettings.onlyPortrait,
          onChanged: (value) {
            ref.read(appSettingsProvider.notifier).saveOnlyPortrait(value == true);
          },
          title: const Text('Nur Hochformat'),
          selected: appSettings.onlyPortrait,
        ),
        CheckboxListTile(
          value: appSettings.showBrightness,
          onChanged: (value) {
            ref.read(appSettingsProvider.notifier).saveShowBrightness(value == true);
          },
          title: const Text('Bright/Dark anzeigen'),
          selected: appSettings.showBrightness,
        ),
        CheckboxListTile(
          value: appSettings.showVideo,
          onChanged: (value) {
            ref.read(appSettingsProvider.notifier).saveShowVideo(value == true);
          },
          title: const Text('Live video on home'),
          selected: appSettings.showBrightness,
        ),
        ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              refreshRateInput(
                translate('Kamera refresh rate Wifi'),
                appSettings.camRefreshRateWifi,
                ref.read(appSettingsProvider.notifier).saveCamRefreshRateWifi,
                ref.read(appSettingsProvider.notifier).persistAppSettings,
              ),
              refreshRateInput(
                translate('Kamera refresh rate mobile'),
                appSettings.camRefreshRateMobile,
                ref.read(appSettingsProvider.notifier).saveCamRefreshRateMobile,
                ref.read(appSettingsProvider.notifier).persistAppSettings,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget refreshRateInput(
  String label,
  int refreshRate,
  Function saveFunction,
  Function persistFunction,
) {
  return Row(
    children: [
      Text(label),
      const Spacer(),
      SizedBox(
        width: 30,
        child: TextFormField(
          initialValue: refreshRate.toString(),
          keyboardType: TextInputType.number,
          textAlign: TextAlign.end,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onEditingComplete: () => persistFunction(), // save on enter
          onChanged: (value) {
            try {
              saveFunction(int.parse(value));
            } on FormatException catch (_) {}
          },
        ),
      ),
    ],
  );
}
