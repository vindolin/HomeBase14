import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '/models/network_addresses.dart';
import '/widgets/shader_widget.dart';

/// this widget draws a graph of the last 12 hours of solar and usage data
class InfluxdbWidget extends StatefulWidget {
  const InfluxdbWidget({super.key});

  @override
  State<InfluxdbWidget> createState() => _InfluxdbWidgetState();
}

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
    var url = influxdbAddress;

    final dio = Dio();

    // solar watt
    var response = await dio.post(
      url,
      data: FormData.fromMap(
        {
          'db': 'sensors',
          'q': '''
        SELECT
        mean(value)
        FROM sma WHERE
        (sensor = 'totw')
        AND  (time >= now() - 12h)
        GROUP BY time(5m)
      ''',
        },
      ),
    );

    // await Future.delayed(const Duration(seconds: 1), () {});

    final solar = response.data['results'][0]['series'][0]['values'].map<TimePoint>(
      (e) {
        // -2147483647 is an error value from the Tripower inverter
        if (e[1] == null || e[1] == -2147483648) {
          e[1] = 0;
        }
        return TimePoint(DateTime.parse(e[0]), e[1].toDouble() / 1000);
      },
    ).toList();

    // usage watt
    response = await dio.post(
      url,
      data: FormData.fromMap(
        {
          'db': 'sensors',
          'q': '''
        SELECT
        mean(value)
        FROM sma WHERE
        (sensor = 'total_w')
        AND  (time >= now() - 12h)
        GROUP BY time(5m)
      ''',
        },
      ),
    );

    // await Future.delayed(const Duration(seconds: 1), () {});

    final usage = response.data['results'][0]['series'][0]['values'].map<TimePoint>(
      (e) {
        if (e[1] == null) {
          e[1] = 0;
        }
        return TimePoint(DateTime.parse(e[0]), e[1].toDouble() / 1000);
      },
    ).toList();

    // xTODO solar can be empty, fix!
    for (int i = 0; i < usage.length; i++) {
      var usageValue = solar[i].value - usage[i].value;
      if (usageValue < 0) usageValue = 0.0; // correct error values
      usage[i].value = usageValue;
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
              primaryYAxis: NumericAxis(
                numberFormat: NumberFormat('#0.0 kW'),
              ),
              legend: const Legend(isVisible: true, alignment: ChartAlignment.near, position: LegendPosition.bottom),
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
          // return Text('${snapshot.error}');
          const ShaderWidget('tv_static.frag');
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
