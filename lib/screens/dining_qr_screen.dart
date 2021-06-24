import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../model/dining/dining_model.dart';
import '../model/dining/qr/dining_qr_bloc.dart';
import '../model/dining/qr/dining_qr_data.dart';
import '../model/dining/qr/dining_qr_event.dart';
import '../model/dining/qr/dining_qr_state.dart';
import 'dining_meal_screen.dart';

class DiningQrScreen extends StatefulWidget {
  const DiningQrScreen({Key? key}) : super(key: key);

  @override
  _DiningQrScreenState createState() => _DiningQrScreenState();
}

class _DiningQrScreenState extends State<DiningQrScreen> {
  final GlobalKey qrKey = GlobalKey();
  QRViewController? controller;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DiningQrBloc(context.read<DiningModel>().currentMenu!),
      child: BlocBuilder<DiningQrBloc, DiningQrState>(
        builder: (context, state) {
          return BlocListener<DiningQrBloc, DiningQrState>(
            listener: _onBlocUpdate,
            child: WillPopScope(
              onWillPop: () => _onWillPop(context, state),
              child: Scaffold(body: _buildContent(context, state)),
            ),
          );
        }
      ),
    );
  }

  void _onBlocUpdate(BuildContext context, DiningQrState state) async {
    if (state is ScanningQrState) {
      controller?.resumeCamera();
    } else {
      controller?.pauseCamera();
    }

    // Load meal screen
    if (state is MealLoadedState) {
      await Navigator.push(context, MaterialPageRoute(builder: (context) => DiningMealScreen(state.meal)));
      context.read<DiningQrBloc>().add(QrRetryEvent());
    }
  }

  // Handles back button navigation
  Future<bool> _onWillPop(BuildContext context, DiningQrState state) async {
    final diningQrBloc = context.read<DiningQrBloc>();
    if (state is ScanningQrState) {
      return true;
    } else {
      diningQrBloc.add(QrRetryEvent());
      return false;
    }
  }

  Widget _buildContent(BuildContext context, DiningQrState state) {
    if (state is ScanningQrState) {
      return Stack(
        alignment: Alignment.center,
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: (controller) =>
                _onQRViewCreated(context, controller),
          ),
          const Text('Scanning QR...'),
        ],
      );
    } else if (state is InvalidQrState) {
      return Center(
        child: Text(state.reason),
      );
    } else if (state is MealLoadedState) {
      return Center(
        child: Text(state.meal.toString()),
      );
    } else {
      throw Error();
    }
  }

  void _onQRViewCreated(BuildContext context, QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((barcode) {
      final diningQrBloc = context.read<DiningQrBloc>();
      final cuisineId = int.tryParse(barcode.code);
      if (cuisineId == null) {
        diningQrBloc.add(InvalidQrScannedEvent('QR code scanned is invalid'));
      } else {
        diningQrBloc.add(ValidQrScannedEvent(DiningQrData(cuisineId)));
      }
    });
  }
}
