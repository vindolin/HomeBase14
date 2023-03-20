import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class InfluxdbWidget extends StatefulWidget {
  const InfluxdbWidget({super.key});

  @override
  State<InfluxdbWidget> createState() => _InfluxdbWidgetState();
}

***REMOVED***

class _InfluxdbWidgetState extends State<InfluxdbWidget> {
  Timer? timer;

  void setTimer(int seconds) {
    timer?.cancel();
    timer = Timer.periodic(
      Duration(seconds: seconds),
      (Timer t) => setState(
        () {
          result = fetchResult();
        },
      ),
    );
  }

  @override
  void initState() {
    setTimer(5);
    result = fetchResult();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  late Future<List<List<TimePoint>>> result;

  Future<List<List<TimePoint>>> fetchResult() async {
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

    // await Future.delayed(const Duration(seconds: 1), () {});

    final solar = jsonDecode(response.body)['results'][0]['series'][0]['values'].map<TimePoint>(
      (e) {
        if (e[1] == null) {
          e[1] = 0;
        }
        return TimePoint(DateTime.parse(e[0]), e[1].toDouble() / 1000);
      },
    ).toList();

    response = await http.post(url, body: {
      'db': 'sensors',
      'q': '''
        SELECT
        mean(value)
        FROM sma WHERE
        (sensor = 'total_w')
        AND  (time >= now() - 12h)
        GROUP BY time(10m)
      ''',
    });

    // await Future.delayed(const Duration(seconds: 1), () {});

    final usage = jsonDecode(response.body)['results'][0]['series'][0]['values'].map<TimePoint>(
      (e) {
        if (e[1] == null) {
          e[1] = 0;
        }
        return TimePoint(DateTime.parse(e[0]), e[1].toDouble() / 1000);
      },
    ).toList();

    for (int i = 0; i < usage.length; i++) {
      usage[i].value = solar[i].value - usage[i].value;
    }

    return [solar, usage];
  }

  @override
  Widget build(BuildContext context) {
    var format = DateFormat('Hm');

    return FutureBuilder<List<List<TimePoint>>>(
      future: result,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;

          return Center(
            child: SfCartesianChart(
              title: ChartTitle(text: 'Solar Watt ☀️ ${snapshot.data![0].last.value.toStringAsFixed(1)} kW'),
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(numberFormat: NumberFormat('#0.0 kW')),
              legend: Legend(isVisible: true, alignment: ChartAlignment.near, position: LegendPosition.bottom),
              series: <LineSeries<TimePoint, String>>[
                LineSeries<TimePoint, String>(
                    name: 'Solar ${snapshot.data![0].last.value.toStringAsFixed(1)} kW',
                    // animationDuration: 0,
                    color: Colors.orange,
                    width: 3,
                    enableTooltip: true,
                    // onPointTap: (pointInteractionDetails) =>
                    //     print(pointInteractionDetails.dataPoints![pointInteractionDetails.pointIndex!].y),
                    dataSource: data[0],

                    // markerSettings: MarkerSettings(isVisible: true),
                    xValueMapper: (TimePoint points, _) => format.format(points.time),
                    yValueMapper: (TimePoint points, _) => points.value),
                LineSeries<TimePoint, String>(
                    name: 'Verbrauch ${(snapshot.data![1].last.value * 1000).toStringAsFixed(1)} W',
                    // animationDuration: 0,
                    color: Colors.pink,
                    width: 3,
                    enableTooltip: true,
                    // onPointTap: (pointInteractionDetails) =>
                    //     print(pointInteractionDetails.dataPoints![pointInteractionDetails.pointIndex!].y),
                    dataSource: data[1],

                    // markerSettings: MarkerSettings(isVisible: true),
                    xValueMapper: (TimePoint points, _) => format.format(points.time),
                    yValueMapper: (TimePoint points, _) => points.value)
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const Center(
            child: SizedBox(
          width: 64,
          height: 64,
          child: CircularProgressIndicator(),
        ));
      },
    );
  }
}

class TimePoint {
  TimePoint(this.time, this.value);
  final DateTime time;
  double value;
}
