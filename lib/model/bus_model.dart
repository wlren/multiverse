import 'package:flutter/material.dart';
import 'package:multiverse/model/bus/bus_arrival_info.dart';
import 'package:multiverse/model/bus/bus_route.dart';
import 'package:multiverse/model/bus/bus_route_info.dart';
import 'package:multiverse/repository/bus_repository.dart';

class BusModel extends ChangeNotifier {
  final BusRepository busRepo;

  BusModel(this.busRepo) {
    update();
  }

  void update() async {
    arrivalInfo = await busRepo.fetchBusArrivalInfo('COM2');
    notifyListeners();
  }

  BusArrivalInfo arrivalInfo = BusArrivalInfo.fromJson({});
}
