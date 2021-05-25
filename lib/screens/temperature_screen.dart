import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TemperatureScreen extends StatefulWidget {
  static final Color acceptableTemperatureColor = Colors.green;
  static final Color unacceptableTemperatureColor = Colors.orange.shade300;
  static const double minTemperature = 35.0;
  static const double maxTemperature = 40.0;
  static const double unacceptableTemperature = 37.5;
  static const double temperatureDivisionWidth =
  0.1; // Smallest division is 0.1 celsius

  @override
  State<StatefulWidget> createState() {
    return TemperatureScreenState();
  }
}

class TemperatureScreenState extends State<TemperatureScreen> {
  String _timeInterval = DateFormat('aa').format(DateTime.now());
  String currentTimeString = DateFormat('EEEE, d MMM').format(DateTime.now());
  double _temperature = 36.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: TemperatureScreen.unacceptableTemperatureColor,
        child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.of(context).viewPadding.top,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.warning),
                        Container(width: 16.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Temperature Declaration',
                                style: Theme.of(context).textTheme.headline6),
                            Text('Not declared yet · 7 May (Afternoon)'),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ];
            },
            body: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 16.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 56.0, right: 32.0),
                      child: Column(
                          children: [
                            Row(
                              children: [
                                Text(currentTimeString,
                                    style: Theme.of(context).textTheme.subtitle1),
                                Spacer(),
                                DropdownButton(
                                  value: _timeInterval,
                                  items: [
                                    DateFormat('aa')
                                        .format(DateTime.utc(2020, 1, 1, 11)),
                                    DateFormat('aa')
                                        .format(DateTime.utc(2020, 1, 1, 13)),
                                  ].map((String value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _timeInterval = newValue!;
                                    });
                                  },
                                  underline: Container(),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text('I do not have COVID-19 symptoms.'),
                                Spacer(),
                                Checkbox(value: false, onChanged: null),
                              ],
                            ),
                            Row(
                              children: [
                                Flexible(
                                  flex: 3,
                                  child: Text(
                                    'Nobody in the same household has fever,'
                                    'and/or is showing the above stated symptoms.',
                                    softWrap: true,
                                  ),
                                ),
                                Spacer(),
                                Checkbox(value: false, onChanged: null),
                              ],
                            ),
                          ],
                        ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 32.0, right: 24.0),
                      child: Slider.adaptive(
                        label: _formatTemperature(_temperature),
                        value: _temperature,
                        min: TemperatureScreen.minTemperature,
                        max: TemperatureScreen.maxTemperature,
                        activeColor: _isAcceptableTemperature(_temperature)
                            ? TemperatureScreen.acceptableTemperatureColor
                            : TemperatureScreen.unacceptableTemperatureColor,
//                      divisions: (TemperatureRoute.maxTemperature -
//                          TemperatureRoute.minTemperature) ~/
//                          TemperatureRoute.temperatureDivisionWidth,
                        onChanged: (temperature) {
                          setState(() {
                            _temperature = temperature;
                          });
                        },
                      ),
                    ),
                    Text(_formatTemperature(_temperature),
                        style: Theme.of(context).textTheme.headline4),
                    ElevatedButtonTheme(
                      data: ElevatedButtonThemeData(
                        style: ElevatedButton.styleFrom(
                          primary: _isAcceptableTemperature(_temperature)
                              ? TemperatureScreen.acceptableTemperatureColor
                              : TemperatureScreen.unacceptableTemperatureColor,
                        )
                      ),
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.done),
                        label: Text('Declare'),
                        onPressed: () => _declareTemperature(_temperature),
                      ),
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }

  void _declareTemperature(double temperature) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('nice')));
  }

  static String _formatTemperature(double temperature) {
    return temperature.toStringAsFixed(1) + ' °C';
  }

  static bool _isAcceptableTemperature(double temperature) {
    return temperature < TemperatureScreen.unacceptableTemperature;
  }
}
