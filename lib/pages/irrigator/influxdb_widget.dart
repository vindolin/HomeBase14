import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '/models/network_addresses.dart';
import '/widgets/shader_widget.dart';

/// this widget draws a graph of the last 12 hours of soil moisture
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

    List<List<TimePoint>> resultList = [];

    // TODO find out how to query for multiple fields at once
    for (final fieldName in ['target', 'soil']) {
      var response = await dio.post(
        url,
        data: FormData.fromMap(
          {
            'db': 'sensors',
            'q': '''
              SELECT
              MEAN(value)
              FROM irrigator WHERE
              (sensor = '$fieldName')
              AND  (time >= NOW() - 12h)
              GROUP BY TIME(10m)
              FILL(previous)
      ''',
          },
        ),
      );

      resultList.add(
        response.data['results'][0]['series'][0]['values']
            .map<TimePoint>(
              (e) {
                e[1] ??= 0; // replace null with 0
                return TimePoint(DateTime.parse(e[0]), e[1].toDouble());
              },
            )
            .toList()
            .sublist(1), // remove first value because it is always null
      );
    }

    // ignore: dead_code
    if (false) {
      var response2 = await dio.post(
        url,
        data: FormData.fromMap(
          {
            'db': 'sensors',
            'q': '''
        SELECT *
        FROM irrigator
        WHERE sensor != 'valve'
        AND (time >= now() - 12h)
      ''',
          },
        ),
      );

      List<List<TimePoint>> resultList2 = [[], []];

      final fieldNames = ['target', 'soil'];
      for (var element in response2.data['results'][0]['series'][0]['values']) {
        // final fieldName = element[1];
        final [time, fieldName, value] = element;
        resultList2[fieldNames.indexOf(fieldName)].add(
          TimePoint(
            DateTime.parse(time),
            value.toDouble(),
          ),
        );
      }
      // this results in a broken graph, investigate!
      return resultList2;
    }

    return resultList;
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
              // title: ChartTitle(text: '${snapshot.data![0].last.value.toStringAsFixed(0)} %'),
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(numberFormat: NumberFormat('#0'), labelFormat: '{value}%'),
              legend: const Legend(isVisible: true, alignment: ChartAlignment.near, position: LegendPosition.bottom),
              series: <LineSeries<TimePoint, String>>[
                LineSeries<TimePoint, String>(
                    name: 'Ziel ${snapshot.data![0].last.value.toStringAsFixed(0)} %',
                    // animationDuration: 0,
                    color: Colors.red.withAlpha(200),
                    width: 2,
                    // dashArray: [1, 100],
                    enableTooltip: true,
                    // onPointTap: (pointInteractionDetails) =>
                    //     print(pointInteractionDetails.dataPoints![pointInteractionDetails.pointIndex!].y),
                    dataSource: data[0],

                    // markerSettings: MarkerSettings(isVisible: true),
                    xValueMapper: (TimePoint points, _) => format.format(points.time),
                    yValueMapper: (TimePoint points, _) => points.value),
                LineSeries<TimePoint, String>(
                    name: 'Aktuell ${(snapshot.data![1].last.value).toStringAsFixed(0)} %',
                    // animationDuration: 0,
                    color: Colors.blue,
                    width: 3,
                    enableTooltip: true,
                    // onPointTap: (pointInteractionDetails) =>
                    //     print(pointInteractionDetails.dataPoints![pointInteractionDetails.pointIndex!].y),
                    dataSource: data[1],

                    // markerSettings: MarkerSettings(isVisible: true),
                    xValueMapper: (TimePoint points, _) => format.format(points.time),
                    yValueMapper: (TimePoint points, _) => points.value),
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
