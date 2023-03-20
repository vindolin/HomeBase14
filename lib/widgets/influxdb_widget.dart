import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class InfluxdbWidget extends ConsumerStatefulWidget {
  const InfluxdbWidget({super.key});

  @override
  ConsumerState<InfluxdbWidget> createState() => _InfluxdbWidgetState();
}

***REMOVED***

class _InfluxdbWidgetState extends ConsumerState<InfluxdbWidget> {
  late Future<List<TimePoint>> result;

  Future<List<TimePoint>> fetchResult() async {
    var url = Uri.parse('***REMOVED***');

    var response = await http.post(url, body: {
      'db': 'sensors',
      'q': '''
        SELECT
        mean(value)
        FROM sma WHERE
        (sensor = 'totw')
        AND  (time >= now() - 12h)
        GROUP BY time(10m)
      ''',
    });
    return jsonDecode(response.body)['results'][0]['series'][0]['values']
        .where(
          (element) => element[1] != null && element[1] > 0,
        )
        .toList()
        .map<TimePoint>(
      (e) {
        return TimePoint(DateTime.parse(e[0]), e[1].toDouble());
      },
    ).toList();
  }

  @override
  void initState() {
    result = fetchResult();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var format = DateFormat('Hm');

    return FutureBuilder<List<TimePoint>>(
      future: result,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Center(
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              series: <LineSeries<TimePoint, String>>[
                LineSeries<TimePoint, String>(
                    animationDuration: 0,
                    dataSource: snapshot.data!,
                    xValueMapper: (TimePoint points, _) => format.format(points.time),
                    yValueMapper: (TimePoint points, _) => points.value)
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}

class TimePoint {
  TimePoint(this.time, this.value);
  final DateTime time;
  final double value;
}
