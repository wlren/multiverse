import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../model/dining/dining_model.dart';
import '../model/dining/qr/dining_qr_bloc.dart';
import '../model/dining/qr/dining_qr_data.dart';
import '../model/dining/qr/dining_qr_event.dart';
import '../model/dining/qr/dining_qr_state.dart';
import 'dining_redeem_screen.dart';

class DiningQrScreen extends StatefulWidget {
  const DiningQrScreen({Key? key}) : super(key: key);

  @override
  _DiningQrScreenState createState() => _DiningQrScreenState();
}

class _DiningQrScreenState extends State<DiningQrScreen> {
  static const backgroundColor = Color(0x44000000);
  static const Duration fadeDuration = Duration(seconds: 1);
  final GlobalKey qrKey = GlobalKey();
  QRViewController? controller;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        appBarTheme: AppBarTheme(
          backwardsCompatibility: false,
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
        ),
        scaffoldBackgroundColor: Colors.black,
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),
      child: BlocProvider(
        create: (context) => DiningQrBloc(context.read<DiningModel>().currentMenu!),
        child: BlocBuilder<DiningQrBloc, DiningQrState>(
          builder: (context, state) {
            return BlocListener<DiningQrBloc, DiningQrState>(
              listener: _onBlocUpdate,
              child: WillPopScope(
                onWillPop: () => _onWillPop(context, state),
                child: Scaffold(
                  extendBodyBehindAppBar: true,
                  appBar: AppBar(),
                  // TODO: Darken the rest of the body to match app bar
                  body: _buildContent(context, state),
                ),
              ),
            );
          }
        ),
      ),
    );
  }

  void _onBlocUpdate(BuildContext context, DiningQrState state) async {
    if (state is InvalidQrState) {
      controller?.resumeCamera();
    }

    // Load meal screen
    if (state is MealLoadedState) {
      await Navigator.push(context, MaterialPageRoute(builder: (context) => DiningRedeemScreen(state.meal)));
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
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 64.0),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32.0),
                        border: Border.all(
                          color: Colors.white,
                          width: 8.0,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0x77000000),
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: _Blink(
                      duration: fadeDuration,
                      child: Text('Scanning QR...',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
        // QR contains wrong content type
        diningQrBloc.add(InvalidFormatQrScannedEvent());
      } else {
        controller.pauseCamera().then((_) {
          diningQrBloc.add(ValidQrScannedEvent(DiningQrData(cuisineId)));
        });
      }
    });
  }
}

class _Blink extends StatefulWidget {
  const _Blink({Key? key, required this.child, required this.duration}) : super(key: key);

  final Widget child;
  final Duration duration;

  @override
  __BlinkState createState() => __BlinkState();
}

class __BlinkState extends State<_Blink> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      lowerBound: 0.5,
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _controller.value,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
