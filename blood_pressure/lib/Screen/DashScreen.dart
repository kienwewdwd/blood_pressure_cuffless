import 'dart:async';
import 'dart:math';

import 'package:blood_pressure/Data_esp/temphumi.dart';
import 'package:blood_pressure/constrants.dart';
import 'package:blood_pressure/size_config.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:collection';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:firebase_database/firebase_database.dart';

const String esp_url = 'ws://192.168.99.100:99';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Timer? _timer;
  late int count;
  ChartSeriesController? _chartSeriesController;
  List<_ChartData> chartData_ECG = [];
  List<_ChartData> chartData_PPG = [];
  List<_ChartData> New_chartData_PPG = [];
  List<_ChartData> New_chartData_ECG = [];
  late DatabaseReference _data;

// Parameter of the websocket to connect with esp8266
  bool isLoaded = false;
  String msg = '';
  DataRunning dht = DataRunning(0, 0, 0);
  final channel = IOWebSocketChannel.connect(esp_url);

  // Date time
  final day = DateTime.now().day;
  final month = DateTime.now().month;
  final year = DateTime.now().year;
  final hour = DateTime.now().hour;
  final minute = DateTime.now().minute;



  @override
  void dispose() {
    _timer?.cancel();
    chartData_PPG.clear();
    _chartSeriesController = null;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // super.initState();
    channel.stream.listen(
      (message) {
        channel.sink.add('Flutter received $message');
        if (message == "connected") {
          print('Received from MCU: $message');
          if (!mounted) return;
          setState(() {
            msg = message;
          });
        } else {
          print('Received from MCU: $message');
          // {'tempC':'30.50','humi':'64.00'}
          Map<String, dynamic> json = jsonDecode(message);
          if (!mounted) return;
          setState(() {
            dht = DataRunning.fromJson(json);
            isLoaded = true;
          });
        }
        //channel.sink.close(status.goingAway);
      },
      onDone: () {
        //if WebSocket is disconnected
        print("Web socket is closed");
        if (!mounted) return;
        setState(() {
          msg = 'disconnected';
          isLoaded = false;
        });
      },
      onError: (error) {
        print(error.toString());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    chartData_ECG.add(_ChartData(chartData_ECG.length, dht.ECG));
    chartData_PPG.add(_ChartData(chartData_PPG.length, dht.PPG));
    int signalPointer = chartData_PPG.length - 1;

    int max_length = 90; // Giá trị ngưỡng tối đa

    // PPG
    if (chartData_PPG.length > max_length) {
      New_chartData_PPG = chartData_PPG.sublist(
        chartData_PPG.length - max_length,
        chartData_PPG.length,
      );
    } else {
      New_chartData_PPG = chartData_PPG;
    }
    if (chartData_PPG.length > 1500) {
      chartData_PPG.removeRange(0, chartData_PPG.length);
      chartData_PPG.add(_ChartData(chartData_PPG.length, dht.PPG));
    }
    // // ECG

    if (chartData_ECG.length > max_length) {
      New_chartData_ECG = chartData_ECG.sublist(
        chartData_ECG.length - max_length,
        chartData_ECG.length,
      );
    } else {
      New_chartData_ECG = chartData_ECG;
    }
    if (chartData_ECG.length > 1500) {
      chartData_ECG.removeRange(0, chartData_ECG.length);
      chartData_ECG.add(_ChartData(chartData_ECG.length, dht.ECG));
    }

    // if (chartData_ECG.length > max_length) {
    //   chartData_ECG.removeAt(0);
    //   chartData_ECG.add(_ChartData(chartData_ECG.length, dht.ECG));
    //   if (chartData_ECG.length > 300) {
    //     chartData_ECG.removeRange(0, chartData_ECG.length);
    //     chartData_ECG.add(_ChartData(chartData_ECG.length, dht.ECG));
    //   }
    // }
    setState(() {
      // chartData_PPG = chartData_PPG;
      // chartData_ECG = chartData_ECG;
    });

    return SizedBox(
      height: 30 * 90,
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: CustomColors.kBackgroundColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0)),
              ),
              child: SingleChildScrollView(
                child: Column(children: [
                  Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 3),
                            child: Text(
                                "Updated on $month-$day-$year, $hour:$minute",
                                style: TextStyle(
                                    color: CustomColors.kPrimaryColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // SizedBox(
                              //   width: 20,
                              // ),
                              Container(
                                  height: 150,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: CustomColors.kPrimaryColor,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 5,
                                          spreadRadius: 2,
                                          offset: Offset(0, 0)),
                                    ],
                                  ),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 12,
                                            ),
                                            SvgPicture.asset(
                                              'Images/assets/icons/blood-pressure-icon.svg',
                                              height: 50,
                                              color: Colors.red,
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                              "Your BP",
                                              style: TextStyle(
                                                  color:
                                                      CustomColors.kLightColor,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Text(
                                              '120',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 33),
                                            ),
                                            Text(
                                              '/',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 33),
                                            ),
                                            Text(
                                              '80',
                                              style: TextStyle(
                                                  color:
                                                      CustomColors.kLightColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 33),
                                            ),
                                            Text(
                                              'mmHg',
                                              style: TextStyle(
                                                  color:
                                                      CustomColors.kLightColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )),
                              // SizedBox(
                              //   width: 10,
                              // ),
                              Container(
                                  height: 150,
                                  width: 180,
                                  decoration: BoxDecoration(
                                    color: CustomColors.kPrimaryColor,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 5,
                                          spreadRadius: 2,
                                          offset: Offset(0, 0)),
                                    ],
                                  ),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 12,
                                            ),
                                            SvgPicture.asset(
                                              'Images/assets/icons/heart-rate-11.svg',
                                              height: 50,
                                              color: Colors.red,
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                              "Your HR",
                                              style: TextStyle(
                                                  color:
                                                      CustomColors.kLightColor,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Text(
                                              '80',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 33),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'BPM',
                                              style: TextStyle(
                                                  color:
                                                      CustomColors.kLightColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text('    Pulse Transit Time: ${dht.PTT} ',
                        style: TextStyle(
                          color: CustomColors.kPrimaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.transparent,
                              blurRadius: 5,
                              spreadRadius: 2,
                              offset: Offset(0, 0)),
                        ],
                      ),
                      child: SfCartesianChart(
                        enableAxisAnimation: true,
                        zoomPanBehavior: ZoomPanBehavior(enablePinching: true),
                        plotAreaBorderWidth: 2,
                        borderColor: CustomColors.kPrimaryColor,
                        plotAreaBorderColor: CustomColors.kPrimaryColor,
                        tooltipBehavior: TooltipBehavior(
                          enable: true,
                        ),
                        legend: Legend(),
                        title: ChartTitle(
                            text: 'PPG Signal',
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        primaryXAxis: NumericAxis(
                          title: AxisTitle(text: 'Time(s)'),
                        ),
                        primaryYAxis: NumericAxis(
                          title: AxisTitle(text: 'PPG Signal'),
                          // maximum: 24000,
                          // minimum: 20000\
                        ),
                        series: <LineSeries<_ChartData, int>>[
                          LineSeries<_ChartData, int>(
                            // onRendererCreated:
                            //     (ChartSeriesController controller) {
                            //   _chartSeriesController = controller;
                            // },
                            enableTooltip: true,
                            dataSource: New_chartData_PPG,
                            xValueMapper: (_ChartData data, _) => data.time,
                            yValueMapper: (_ChartData data, _) => data.data,
                            color: CustomColors.kPrimaryColor,
                            animationDuration: 300,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: SfCartesianChart(
                      plotAreaBorderWidth: 2,
                      plotAreaBorderColor: CustomColors.kPrimaryColor,
                      borderColor: CustomColors.kPrimaryColor,
                      tooltipBehavior: TooltipBehavior(
                        enable: true,
                      ),
                      legend: Legend(),
                      title: ChartTitle(
                          text: ' ECG Signal',
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      primaryXAxis:
                          NumericAxis(title: AxisTitle(text: 'Time(s)')),
                      primaryYAxis:
                          NumericAxis(title: AxisTitle(text: 'ECG Signal')),
                      series: <LineSeries<_ChartData, int>>[
                        LineSeries<_ChartData, int>(
                          enableTooltip: true,
                          dataSource: New_chartData_ECG,
                          xValueMapper: (_ChartData data, _) => data.time,
                          yValueMapper: (_ChartData data, _) => data.data,
                          color: CustomColors.kPrimaryColor,
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // void _updateDataSource(Timer timer) {
  //   if (chartData_PPG.length == 50) {
  //     chartData_PPG.removeAt(0);
  //     _chartSeriesController?.updateDataSource(
  //       addedDataIndexes: <int>[chartData_PPG.length - 1],
  //       removedDataIndexes: <int>[0],
  //     );
  //   } else {
  //     _chartSeriesController?.updateDataSource(
  //       addedDataIndexes: <int>[chartData_PPG.length - 1],
  //     );
  //   }
  //   count = count + 1;
  // }
}

class _ChartData {
  _ChartData(this.time, this.data);
  final int? time;
  final double? data;
}
