import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '/models/network_addresses_provider.dart';
import '/widgets/shader_widget.dart';

// typedef Field = ({String name, Color color, Function nameFormat});
// typedef Fields = Map<String, Field>;

/// this widget draws a graph of the last 12 hours of soil moisture
class InfluxChartWidget extends ConsumerStatefulWidget {
  final String measurement;
  final dynamic fields;
  final String timeSpan;
  final String groupTime;
  final String? labelFormat;
  final String? numberFormat;
  final Function? titleFormat;
  final double? minimum;
  final double? maximum;
  const InfluxChartWidget({
    super.key,
    required this.measurement,
    required this.fields,
    required this.timeSpan,
    required this.groupTime,
    this.labelFormat,
    this.numberFormat,
    this.titleFormat,
    this.minimum,
    this.maximum,
  });

  @override
  ConsumerState<InfluxChartWidget> createState() => _InfluxdbWidgetState();
}

class _InfluxdbWidgetState extends ConsumerState<InfluxChartWidget> {
  Timer? timer;

  void setTimer(int seconds, String url) {
    timer?.cancel();
    timer = Timer.periodic(
      Duration(seconds: seconds),
      (Timer t) => setState(
        () {
          result = fetchResult(url);
        },
      ),
    );
  }

  @override
  void initState() {
    final networkAddress = ref.watch(networkAddressesProvider)['influxdb'];

    setTimer(5, networkAddress);
    result = fetchResult(networkAddress);
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  late Future<List<List<TimePoint>>> result;

  Future<List<List<TimePoint>>> fetchResult(String url) async {
    final dio = Dio();

    List<List<TimePoint>> resultList = [];
    var queries = '';
    // concatenate multiple queries into one request, so we can get the mean of the fields and make the Syncfusion chart happy
    for (var fieldName in widget.fields.keys) {
      queries += '''
        SELECT
        MEAN(value)
        FROM ${widget.measurement} WHERE
        (sensor = '$fieldName')
        AND  (time >= NOW() - ${widget.timeSpan})
        GROUP BY TIME(${widget.groupTime})
        FILL(previous);
      ''';
    }

    var response = await dio.post(
      url,
      data: FormData.fromMap(
        {
          'db': 'sensors',
          'q': queries,
        },
      ),
    );

    for (var i = 0; i < widget.fields.keys.length; i++) {
      if (response.data['results'][i].containsKey('series')) {
        resultList.add(
          response.data['results'][i]['series'][0]['values']
              .map<TimePoint>(
                (e) {
                  e[1] ??= 0; // replace null with 0
                  return TimePoint(DateTime.parse(e[0]), e[1].toDouble());
                },
              )
              .toList()
              .sublist(1), // remove first value because it is always null and leads to a dip in the chart
        );
      } else {
        resultList.add([]); // add empty list if no data is available so the chart has something to play with
      }
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
              title: widget.titleFormat != null
                  ? ChartTitle(text: widget.titleFormat!(data[0].last.value))
                  : const ChartTitle(),
              primaryXAxis: const CategoryAxis(),
              primaryYAxis: NumericAxis(
                numberFormat: NumberFormat(widget.numberFormat),
                labelFormat: widget.labelFormat,
                minimum: widget.minimum,
                maximum: widget.maximum,
              ),
              legend: const Legend(isVisible: true, alignment: ChartAlignment.near, position: LegendPosition.bottom),
              series: [
                ...data.map((e) {
                  final key = widget.fields.keys.elementAt(data.indexOf(e));
                  final fieldData = widget.fields[key];

                  return LineSeries<TimePoint, String>(
                    name: fieldData['name'],
                    dataSource: e,
                    color: fieldData['color'],
                    xValueMapper: (TimePoint tp, _) => format.format(tp.time),
                    yValueMapper: (TimePoint tp, _) => tp.value,
                  );
                })
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
