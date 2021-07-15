//Package
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

//Local Files
import '../model/bus/bus_arrival_info.dart';

class BusRepository {
  static const url = 'https://nnextbus.nus.edu.sg';
  static const token = 'TlVTbmV4dGJ1czoxM2RMP3pZLDNmZVdSXiJU';

  BusRepository();

  Future<BusArrivalInfo> fetchBusArrivalInfo(String busStop) async {
    print('here');
    final response = await http
        .get(Uri.parse('$url/ShuttleService?busstopname=$busStop'), headers: {
      HttpHeaders.authorizationHeader: 'Basic $token',
    });
    print('here2');
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      return BusArrivalInfo.fromJson({});
    } else {
      print('help la');
      throw Exception('Failed to fetch bus information for $busStop');
    }
  }
}
