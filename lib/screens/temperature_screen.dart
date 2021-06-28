//Packages
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

//Local Files
import '../model/temperature/temperature_model.dart';
import '../model/temperature/temperature_record.dart';
import '../model/temperature/temperature_state.dart';
import '../model/user_model.dart';
import '../repository/user_repository.dart';

class TemperatureScreen extends StatefulWidget {
  static final Color acceptableTemperatureColor = Colors.green.shade300;
  static final Color unacceptableTemperatureColor = Colors.orange.shade300;
  static const double minTemperature = 35.0;
  static const double maxTemperature = 40.0;
  static const double unacceptableTemperature = 37.5;
  static const double temperatureDivisionWidth =
      0.1; // Smallest division is 0.1 celsius

  const TemperatureScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TemperatureScreenState();
  }
}

class TemperatureScreenState extends State<TemperatureScreen>
    with TickerProviderStateMixin {
  static const double leftPadding = 64.0;
  DateTime now = DateTime.now();
  late String _timeInterval = DateFormat('aa').format(now);
  late String currentTimeString = DateFormat('EEEE, d MMM').format(now);
  late final AnimationController _showFormAnimation = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  double _temperature = 36.0;
  bool _isSymptomless = false;
  bool _isHouseholdSymptomless = false;
  bool __isRedeclaring = false;

  bool get _isRedeclaring => __isRedeclaring;

  set _isRedeclaring(bool value) {
    _toAnimate = true;
    __isRedeclaring = value;
    if (!_isRedeclaring) {
      // Hide form
      _showFormAnimation.reverse();
    } else {
      _showFormAnimation.forward();
    }
  }

  bool _toAnimate = false;

  bool get _isGoodToDeclare =>
      _isSymptomless &&
      _isHouseholdSymptomless &&
      _isAcceptableTemperature(_temperature);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TemperatureModel(context.read<UserRepository>()),
      builder: (context, _) {
        // Set here instead of in AnimationController constructor so that
        // the animation does not play when screen is initialized.
        if (!_toAnimate) {
          _showFormAnimation.value =
              context.read<TemperatureModel>().temperatureState ==
                      TemperatureState.undeclared
                  ? 1
                  : 0;
        }
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backwardsCompatibility: false,
            backgroundColor: Colors.transparent,
            title: const Text('Temperature Declaration'),
            foregroundColor: Theme.of(context).textTheme.headline6!.color,
            titleSpacing: 8.0,
            elevation: 0,
          ),
          body: Column(
            children: [
              Material(
                clipBehavior: Clip.none,
                color: _getBackgroundColor(),
                child: Column(
                  children: [
                    SizedBox(
                      height:
                          kToolbarHeight + MediaQuery.of(context).padding.top,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: leftPadding),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Transform.translate(
                            offset: const Offset(0, -16.0),
                            child: Text(context
                                        .read<TemperatureModel>()
                                        .temperatureState ==
                                    TemperatureState.undeclared
                                ? 'Not declared yet'
                                : 'Declared'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                    child: Container(
                  color: _getBackgroundColor(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Column(
                        children: [
                          // Hide the temperature form once declared, unless
                          // declaring
                          AnimatedBuilder(
                            animation: _showFormAnimation,
                            builder: (context, child) {
                              return Opacity(
                                opacity: CurvedAnimation(
                                  parent: _showFormAnimation,
                                  curve: const Interval(0.75, 1.0),
                                ).value,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  heightFactor: CurvedAnimation(
                                    parent: _showFormAnimation,
                                    curve: const Interval(0.0, 0.75,
                                        curve: Curves.easeInOutCubic),
                                  ).value,
                                  child: child,
                                ),
                              );
                            },
                            child: _buildTemperatureForm(context),
                          ),
                          const SizedBox(height: 24.0),
                          _buildDeclareButton(context),
                          const SizedBox(height: 32.0),
                          _buildTemperatureList(context),
                        ],
                      ),
                    ),
                  ),
                )),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDeclareButton(BuildContext context) {
    final isTemperatureDeclared =
        context.read<TemperatureModel>().temperatureState !=
            TemperatureState.undeclared;
    if (isTemperatureDeclared && !_isRedeclaring) {
      return OutlinedButtonTheme(
        data: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
            textStyle: Theme.of(context).textTheme.headline6,
          ),
        ),
        child: OutlinedButton.icon(
          icon: const Icon(Icons.refresh),
          label: Text(isTemperatureDeclared ? 'Redeclare' : 'Declare'),
          onPressed: () {
            if (isTemperatureDeclared) {
              // Redeclaring temperature
              if (_isRedeclaring) {
                _tryDeclareTemperature(context, _temperature);
              } else {
                setState(() {
                  _isRedeclaring = true;
                });
              }
            } else {
              _tryDeclareTemperature(context, _temperature);
            }
          },
        ),
      );
    } else {
      return ElevatedButtonTheme(
        data: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: _isGoodToDeclare
                ? TemperatureScreen.acceptableTemperatureColor
                : TemperatureScreen.unacceptableTemperatureColor,
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
            textStyle: Theme.of(context).textTheme.headline6,
            onPrimary: Colors.black,
          ),
        ),
        child: ElevatedButton.icon(
          icon: _isGoodToDeclare
              ? const Icon(Icons.done)
              : const Icon(Icons.warning),
          label: Text(isTemperatureDeclared ? 'Redeclare' : 'Declare'),
          onPressed: () {
            if (isTemperatureDeclared && !_isRedeclaring) {
              setState(() {
                _isRedeclaring = true;
              });
            } else {
              _tryDeclareTemperature(context, _temperature);
            }
          },
        ),
      );
    }
  }

  Widget _buildTemperatureForm(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: leftPadding, right: 32.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(currentTimeString,
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            fontWeight: FontWeight.bold,
                          )),
                  const Spacer(),
                  DropdownButton<String>(
                    value: _timeInterval,
                    items: [
                      DateFormat('aa').format(DateTime.utc(2020, 1, 1, 11)),
                      DateFormat('aa').format(DateTime.utc(2020, 1, 1, 13)),
                    ].map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
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
                  const Text('I do not have COVID-19 symptoms.'),
                  const Spacer(),
                  Checkbox(
                      value: _isSymptomless,
                      onChanged: (value) {
                        setState(() {
                          _isSymptomless = value!;
                        });
                      }),
                ],
              ),
              Row(
                children: [
                  const Flexible(
                    flex: 3,
                    child: Text(
                      'Nobody in the same household has fever, '
                      'and/or is showing the above stated symptoms.',
                      softWrap: true,
                    ),
                  ),
                  const Spacer(),
                  Checkbox(
                      value: _isHouseholdSymptomless,
                      onChanged: (value) {
                        setState(() {
                          _isHouseholdSymptomless = value!;
                        });
                      }),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24.0),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: leftPadding, right: 48.0),
          child: Text('Temperature',
              style: Theme.of(context).textTheme.subtitle1?.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
        ),
        Padding(
          padding: const EdgeInsets.only(left: leftPadding - 24.0, right: 24.0),
          child: Slider.adaptive(
            label: _formatTemperature(_temperature),
            value: _temperature,
            min: TemperatureScreen.minTemperature,
            max: TemperatureScreen.maxTemperature,
            activeColor: _isAcceptableTemperature(_temperature)
                ? TemperatureScreen.acceptableTemperatureColor
                : TemperatureScreen.unacceptableTemperatureColor,
            onChanged: (temperature) {
              setState(() {
                _temperature = temperature;
              });
            },
          ),
        ),
        Text(_formatTemperature(_temperature),
            style: Theme.of(context).textTheme.headline4),
      ],
    );
  }

  Widget _buildTemperatureList(BuildContext context) {
    final temperatureModel = context.read<TemperatureModel>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: leftPadding, right: 24.0),
          child: Text('History', style: Theme.of(context).textTheme.headline6),
        ),
        const SizedBox(height: 16.0),
        Padding(
          padding: const EdgeInsets.only(left: leftPadding, right: 48.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (day) => _buildDayTile(context, day)),
          ),
        ),
        const SizedBox(height: 8.0),
        MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, position) {
              final record = temperatureModel.temperatureRecords[position];
              return ListTile(
                contentPadding:
                    const EdgeInsets.only(left: leftPadding, right: 48.0),
                title: Text(_getRecordTitle(record)),
                subtitle: Text(_getRecordSubtitle(record)),
                trailing: Text(_getRecordTrailing(record),
                    style: Theme.of(context).textTheme.subtitle1),
              );
            },
            itemCount: temperatureModel.temperatureRecords.length,
          ),
        ),
        const SizedBox(height: 32.0),
      ],
    );
  }

  Widget _buildDayTile(BuildContext context, int dayIndex) {
    final sunday = now.subtract(Duration(days: now.weekday));
    final day = sunday.add(Duration(days: dayIndex));
    final dayLetter = DateFormat.E().format(day)[0];
    final isDeclared = context
        .read<TemperatureModel>()
        .temperatureRecords
        .any((record) => record.time.isSameDate(day));
    final isToday = dayIndex == now.weekday;
    final backgroundColor = isDeclared
        ? (Theme.of(context).brightness == Brightness.light
            ? Colors.green.shade200
            : Colors.green.shade800)
        : Theme.of(context).dividerColor;
    final borderColor = isToday
        ? (Theme.of(context).brightness == Brightness.light
            ? Colors.green.shade700
            : Colors.green.shade300)
        : Colors.transparent;

    return Container(
      width: 32.0,
      height: 32.0,
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            width: 4.0,
            color: borderColor,
          )),
      alignment: Alignment.center,
      child: Text(dayLetter),
    );
  }

  static String _getRecordTitle(TemperatureRecord record) {
    return DateFormat('d MMM').format(record.time);
  }

  static String _getRecordSubtitle(TemperatureRecord record) {
    final timeOfDay = record.time.hour >= 12 ? 'Afternoon' : 'Morning';
    final timeAgo = timeago.format(record.time);
    return '$timeOfDay · $timeAgo';
  }

  static String _getRecordTrailing(TemperatureRecord record) {
    return _formatTemperature(record.temperature);
  }

  Color _getBackgroundColor() {
    return context.watch<UserModel>().temperatureState ==
            TemperatureState.acceptable
        ? (Theme.of(context).brightness == Brightness.light
            ? Colors.green.shade300
            : Colors.green.shade900)
        : (Theme.of(context).brightness == Brightness.light
            ? Colors.orange.shade300
            : Colors.deepOrange.shade900);
  }

  void _declareTemperature(BuildContext context, double temperature) {
    context.read<TemperatureModel>().declareTemperature(temperature);
    context.read<UserModel>().update();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Temperature declared')));
    setState(() {
      _isRedeclaring = false;
    });
  }

  void _tryDeclareTemperature(BuildContext context, double temperature) {
    if (_isGoodToDeclare) {
      _declareTemperature(context, temperature);
    } else {
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Text('Are you sure?'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Do you wish to declare your temperature?',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16.0),
                  const Text('You have declared that:'),
                  if (!_isSymptomless)
                    const Text('• You have COVID-19 symptoms.'),
                  if (!_isHouseholdSymptomless)
                    const Text(
                        '• Somebody in the same household has fever, and/or is showing COVID-19 symptoms.'),
                  if (!_isAcceptableTemperature(_temperature))
                    Text(
                        '• Your temperature is ${_formatTemperature(_temperature)}, which is above the acceptable range.'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _declareTemperature(context, temperature);
                  },
                  child: const Text('Yes'),
                ),
              ],
            );
          });
    }
  }

  static String _formatTemperature(double temperature) {
    return temperature.toStringAsFixed(1) + ' °C';
  }

  static bool _isAcceptableTemperature(double temperature) {
    return temperature < TemperatureScreen.unacceptableTemperature;
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
