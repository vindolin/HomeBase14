import 'package:flutter/material.dart';

import '/pages/home/home_page.dart';
import '/styles/text_styles.dart';
import '/utils.dart';
import '/widgets/mqtt_switch_widget.dart';
import '/widgets/connection_bar_widget.dart';
import 'dropdown_select_widget.dart';
import 'package:dio/dio.dart';

class ThomasPage extends StatelessWidget {
  const ThomasPage({super.key});

  @override
  Widget build(BuildContext context) {
    log('ThomasPage.build()');

    return pageAfterHome(
      context,
      Scaffold(
        appBar: AppBar(
          title: const Text('Thomas'),
          actions: const [ConnectionBar()],
          leading: homeBackButton(context),
        ),
        body: GridView.count(
          padding: const EdgeInsets.all(8),
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          children: [
            Card(
              color: Colors.amber[900],
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Text(
                    'Select sleep mode',
                    style: textStyleShadowOne,
                  ),
                  DropdownSelect(
                    options: {
                      'wakeup': '☕️ - wake up',
                      'sleep': '😴 - sleep',
                      'hibernate': '🐻 - hibernate',
                    },
                    statTopic: 'leech/sleep',
                    setTopic: 'leech/sleep/set',
                  ),
                ],
              ),
            ),
            Card(
              color: Colors.cyan[900],
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Text(
                    'Select Monitor',
                    style: textStyleShadowOne,
                  ),
                  DropdownSelect(
                    options: {
                      'tv': '📺 - TV',
                      'monitor': '💻 - Monitor',
                    },
                    statTopic: 'leech/screens',
                    setTopic: 'leech/screens/set',
                  ),
                ],
              ),
            ),
            const Card(
              child: Center(
                child: MqttSwitchWidget(
                  title: 'Meep A!',
                  statTopic: 'meep/a/stat',
                  setTopic: 'meep/a/set',
                  optimistic: true,
                  orientation: MqttSwitchWidgetOrientation.horizontal,
                ),
              ),
            ),
            const Card(
              child: Center(
                child: MqttSwitchWidget(
                  title: 'Meep B!',
                  statTopic: 'meep/b/stat',
                  setTopic: 'meep/b/set',
                  optimistic: false,
                  orientation: MqttSwitchWidgetOrientation.vertical,
                ),
              ),
            ),
            Card(
              child: TextButton(
                  onPressed: () async {
                    final dio = Dio();

                    var url = Uri.parse('***REMOVED***');

                    final rs = await dio.postUri(url,
                        data: FormData.fromMap({
                          'db': 'sensors',
                          'q':
                              '''SELECT mean(value) FROM sma WHERE (sensor = 'totw') AND  (time >= now() - 12h) GROUP BY time(5m)''',
                        }));

                    // final rs = await dio.post(
                    //   'http://***REMOVED***',
                    //   // 'http://***REMOVED***:8086/query?pretty=false',
                    //   data: {
                    //     'db': 'sensors',
                    //     'q':
                    //         '''SELECT mean(value) FROM sma WHERE (sensor = 'totw') AND  (time >= now() - 12h) GROUP BY time(5m)''',
                    //     'k': 'blub'
                    //   },
                    //   // options: Options(
                    //   //   headers: {'authorization': 'Basic ${base64Encode(utf8.encode('admin:***REMOVED***'))}'},
                    //   // ),
                    //   options: Options(
                    //     followRedirects: false,
                    //     validateStatus: (status) {
                    //       return status! < 500;
                    //     },
                    //   ),
                    // );

                    print(rs.data); // Response
                  },
                  child: const Text('diomio!')),
            ),
          ],
        ),
      ),
    );
  }
}
