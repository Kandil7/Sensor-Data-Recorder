import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensor_data_logging/services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'accelerometer_data.dart';
import 'excel_helper.dart';
import 'gyroscope_data.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sensors Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MyHomePage(title: 'Flutter Sensor Data Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<double>? _accelerometerValues;
  List<double>? _userAccelerometerValues;
  List<double>? _gyroscopeValues;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  List<AccelerometerData> _accelerometerData = [];
  List<GyroscopeData> _gyroscopeData = [];

  int backAndForth = 0;

  @override
  Widget build(BuildContext context) {
    final accelerometer =
    _accelerometerValues?.map((double v) => v.toStringAsFixed(1)).toList();

    final gyroscope =
    _gyroscopeValues?.map((double v) => v.toStringAsFixed(1)).toList();
    final userAccelerometer = _userAccelerometerValues
        ?.map((double v) => v.toStringAsFixed(1))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Sensor Data'),
        actions: [
          IconButton(onPressed: () async {
            await wirteToExcel(accelerometerData: _accelerometerData, gyroscopeData: _gyroscopeData);

          }, icon: Icon(Icons.save) )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Accelerometer: $accelerometer'),
              ],
            ),
          ),
          Expanded(
            child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                // Chart title
                title: ChartTitle(text: 'Acceleration Sensor Data'),
                // Enable legend
                legend: Legend(isVisible: true),
                // Enable tooltip
                tooltipBehavior: TooltipBehavior(enable: false),
                series: <ChartSeries<AccelerometerData, DateTime>>[
                  LineSeries<AccelerometerData, DateTime>(
                      dataSource: _accelerometerData,
                      xValueMapper: (AccelerometerData value, _) => value.getDate,
                      yValueMapper: (AccelerometerData value, _) => value.getValue[0],
                      name: 'X',
                      // Enable data label
                      dataLabelSettings:  DataLabelSettings(isVisible: true)),
                  LineSeries<AccelerometerData, DateTime>(
                      dataSource: _accelerometerData,
                      xValueMapper: (AccelerometerData value, _) => value.getDate,
                      yValueMapper: (AccelerometerData value, _) => value.getValue[1],
                      name: 'Y',
                      // Enable data label
                      dataLabelSettings:  DataLabelSettings(isVisible: true)),
                  LineSeries<AccelerometerData, DateTime>(
                      dataSource: _accelerometerData,
                      xValueMapper: (AccelerometerData value, _) => value.getDate,
                      yValueMapper: (AccelerometerData value, _) => value.getValue[2],
                      name: 'Z',
                      // Enable data label
                      dataLabelSettings:  DataLabelSettings(isVisible: true))
                ]),
          ),
          Padding(
            padding:  EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Gyroscope: $gyroscope'),
              ],
            ),
          ),
          Expanded(
            child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                // Chart title
                title: ChartTitle(text: 'Gyroscope Sensor Data'),
                // Enable legend
                legend: Legend(isVisible: true),
                // Enable tooltip
                tooltipBehavior: TooltipBehavior(enable: false),
                series: <ChartSeries<GyroscopeData, DateTime>>[
                  LineSeries<GyroscopeData, DateTime>(
                      dataSource: _gyroscopeData,
                      xValueMapper: (GyroscopeData value, _) => value.getDate,
                      yValueMapper: (GyroscopeData value, _) => value.getValue[0],
                      name: 'X',
                      // Enable data label
                      dataLabelSettings: const DataLabelSettings(isVisible: true)),
                  LineSeries<GyroscopeData, DateTime>(
                      dataSource:   _gyroscopeData,
                      xValueMapper: (GyroscopeData value, _) => value.getDate,
                      yValueMapper: (GyroscopeData value, _) => value.getValue[1],
                      name: 'Y',
                      // Enable data label
                      dataLabelSettings: const DataLabelSettings(isVisible: true)),
                  LineSeries<GyroscopeData, DateTime>(
                      dataSource: _gyroscopeData,
                      xValueMapper: (GyroscopeData value, _) => value.getDate,
                      yValueMapper: (GyroscopeData value, _) => value.getValue[2],
                      name: 'Z',
                      // Enable data label
                      dataLabelSettings: const DataLabelSettings(isVisible: true))
                ]),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Date: ${DateTime.now()}'),
              ],
            ),
          ),
          // a simple button to test the accelerometer
          Row(
            children: [
              // ElevatedButton(
              //   child: const Text("Start"),
              //   onPressed: () {
              //     if(backAndForth % 2 == 1){
              //       _accelerometerData.clear();
              //       _gyroscopeData.clear();
              //     }
              //     // start a stream that saves acceleroemeterData
              //     _streamSubscriptions.add(
              //         accelerometerEvents.listen((AccelerometerEvent event) {
              //           _accelerometerData.add(AccelerometerData(DateTime.now(), <double>[event.x, event.y, event.z]));
              //         })
              //     );
              //     // start a stream that saves gyroscopeData
              //     _streamSubscriptions.add(
              //         gyroscopeEvents.listen((GyroscopeEvent event) {
              //           _gyroscopeData.add(GyroscopeData(DateTime.now(), <double>[event.x, event.y, event.z]));
              //         })
              //     );
              //     backAndForth++;
              //   },
              // ),
              ElevatedButton(
                child: const Text("Start after 5 seconds"),
                onPressed: () {
                  Duration duration = Duration(seconds: 5);
                  Timer(duration, () {

                    if(backAndForth % 2 == 1){

                      setState(() {
                        _streamSubscriptions.clear();
                        _accelerometerData.clear();
                        _gyroscopeData.clear();
                      });
                    }

                    // start a stream that saves acceleroemeterData
                    
                    _streamSubscriptions.add(
                        accelerometerEvents.listen((AccelerometerEvent event) {
                          setState(() {
                            _accelerometerData.add(AccelerometerData(DateTime.now(), <double>[event.x, event.y, event.z]));
                          });

                        })
                    );
                    // start a stream that saves gyroscopeData
                    _streamSubscriptions.add(
                        gyroscopeEvents.listen((GyroscopeEvent event) {
                          setState(() {
                            _gyroscopeData.add(GyroscopeData(DateTime.now(), <double>[event.x, event.y, event.z]));
                          });

                        })
                    );
                    backAndForth++;
                  });


                  // start a stream that saves gyroscopeData
                  _streamSubscriptions.add(
                      gyroscopeEvents.listen((GyroscopeEvent event) {
setState(() {
  _gyroscopeData.add(GyroscopeData(DateTime.now(), <double>[event.x, event.y, event.z]));

});                      })
                  );
                  backAndForth++;

                },

              ),
              SizedBox(width: 10,),
              ElevatedButton(
                child: const Text("Start after 10 seconds"),
                onPressed: () {
                  Duration duration = Duration(seconds: 5);
                  Timer(duration, () {

                    if(backAndForth % 2 == 1){
                      setState(() {
                        _streamSubscriptions.clear();
                        _accelerometerData.clear();
                        _gyroscopeData.clear();
                      });
                    }
                    // start a stream that saves acceleroemeterData
                    _streamSubscriptions.add(
                        accelerometerEvents.listen((AccelerometerEvent event) {
                          setState(() {
                            _accelerometerData.add(AccelerometerData(DateTime.now(), <double>[event.x, event.y, event.z]));
                          });

                        })
                    );
                    // start a stream that saves gyroscopeData
                    _streamSubscriptions.add(
                        gyroscopeEvents.listen((GyroscopeEvent event) {
                          setState(() {
                            _gyroscopeData.add(GyroscopeData(DateTime.now(), <double>[event.x, event.y, event.z]));
                          });

                        })
                    );
                    backAndForth++;
                  });


                  // start a stream that saves gyroscopeData
                  _streamSubscriptions.add(
                      gyroscopeEvents.listen((GyroscopeEvent event) {
                        setState(() {
                          _gyroscopeData.add(GyroscopeData(DateTime.now(), <double>[event.x, event.y, event.z]));
                        });
                      })
                  );
                  backAndForth++;

                },

              ),
            ],
          ),
          Row(
            children: [
              // ElevatedButton(
              //   child: const Text("Start"),
              //   onPressed: () {
              //     if(backAndForth % 2 == 1){
              //       _accelerometerData.clear();
              //       _gyroscopeData.clear();
              //     }
              //     // start a stream that saves acceleroemeterData
              //     _streamSubscriptions.add(
              //         accelerometerEvents.listen((AccelerometerEvent event) {
              //           _accelerometerData.add(AccelerometerData(DateTime.now(), <double>[event.x, event.y, event.z]));
              //         })
              //     );
              //     // start a stream that saves gyroscopeData
              //     _streamSubscriptions.add(
              //         gyroscopeEvents.listen((GyroscopeEvent event) {
              //           _gyroscopeData.add(GyroscopeData(DateTime.now(), <double>[event.x, event.y, event.z]));
              //         })
              //     );
              //     backAndForth++;
              //   },
              // ),
              ElevatedButton(
                child: const Text("Start after 15 seconds"),
                onPressed: () {
                  Duration duration = Duration(seconds: 15);
                  Timer(duration, () {
                    if(backAndForth % 2 == 1){
                      setState(() {
                        _streamSubscriptions.clear();

                        _accelerometerData.clear();
                        _gyroscopeData.clear();
                      });
                    }
                    // start a stream that saves acceleroemeterData
                    _streamSubscriptions.add(
                        accelerometerEvents.listen((AccelerometerEvent event) {
                          setState(() {
                            _accelerometerData.add(AccelerometerData(DateTime.now(), <double>[event.x, event.y, event.z]));
                          });

                        })
                    );
                    // start a stream that saves gyroscopeData
                    _streamSubscriptions.add(
                        gyroscopeEvents.listen((GyroscopeEvent event) {
                        setState(() {
                          _gyroscopeData.add(GyroscopeData(DateTime.now(), <double>[event.x, event.y, event.z]));
                        });
                        })
                    );
                    backAndForth++;
                  });


                  // start a stream that saves gyroscopeData
                  _streamSubscriptions.add(
                      gyroscopeEvents.listen((GyroscopeEvent event) {
                        setState(() {
                          _gyroscopeData.add(GyroscopeData(DateTime.now(), <double>[event.x, event.y, event.z]));
                        });
                      })
                  );
                  backAndForth++;

                },

              ),
              SizedBox(width: 10,),
              ElevatedButton(
                child: const Text("Start after 20 seconds"),
                onPressed: () {
                  Duration duration = Duration(seconds: 20);
                  Timer(duration, () {

                    if(backAndForth % 2 == 1){
                      setState(() {
                        _streamSubscriptions.clear();

                        _accelerometerData.clear();
                        _gyroscopeData.clear();
                      });
                    }
                    // start a stream that saves acceleroemeterData
                    _streamSubscriptions.add(
                        accelerometerEvents.listen((AccelerometerEvent event) {
                          setState(() {
                            _accelerometerData.add(AccelerometerData(DateTime.now(), <double>[event.x, event.y, event.z]));
                          });

                        })
                    );
                    // start a stream that saves gyroscopeData
                    _streamSubscriptions.add(
                        gyroscopeEvents.listen((GyroscopeEvent event) {
                          setState(() {
                            _gyroscopeData.add(GyroscopeData(DateTime.now(), <double>[event.x, event.y, event.z]));
                          });

                        })
                    );
                    backAndForth++;
                  });


                  // start a stream that saves gyroscopeData
                  _streamSubscriptions.add(
                      gyroscopeEvents.listen((GyroscopeEvent event) {

                        setState(() {
                          _gyroscopeData.add(GyroscopeData(DateTime.now(), <double>[event.x, event.y, event.z]));
                        });
                        //_gyroscopeData.add(GyroscopeData(DateTime.now(), <double>[event.x, event.y, event.z]));


                      })
                  );
                  backAndForth++;

                },

              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ElevatedButton(
              child:  Text("Stop"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                maximumSize: Size(200, 44),
                minimumSize: Size(200, 44),
              ),
              onPressed: () {
                // stop all streams
                setState(() {
                  for (var element in _streamSubscriptions) {element.pause();}

                });



              },
            ),
          ),




        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    _streamSubscriptions.add(
      accelerometerEvents.listen(
            (AccelerometerEvent event) {
          setState(() {
            _accelerometerValues = <double>[event.x, event.y, event.z];
          });
        },
      ),
    );
    _streamSubscriptions.add(
      gyroscopeEvents.listen(
            (GyroscopeEvent event) {
          setState(() {
            _gyroscopeValues = <double>[event.x, event.y, event.z];
          });
        },
      ),
    );
    _streamSubscriptions.add(
      userAccelerometerEvents.listen(
            (UserAccelerometerEvent event) {
          setState(() {
            _userAccelerometerValues = <double>[event.x, event.y, event.z];
          });
        },
      ),
    );
    _streamSubscriptions.add(
      magnetometerEvents.listen(
            (MagnetometerEvent event) {
          setState(() {
          });
        },
      ),
    );
  }
}