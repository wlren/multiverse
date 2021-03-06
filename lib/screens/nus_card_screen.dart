//Packages
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:provider/provider.dart';

//Local Files
import '../model/user_model.dart';

class NUSCardScreen extends StatefulWidget {
  const NUSCardScreen({Key? key}) : super(key: key);

  static const double horizontalPadding = 32.0;
  static const Color nusOrange = Color(0xFFF07D08);

  @override
  _NUSCardScreenState createState() => _NUSCardScreenState();
}

class _NUSCardScreenState extends State<NUSCardScreen> {
  @override
  Widget build(BuildContext context) {
    final userName = context.watch<UserModel>().userName;
    final admitTerm = context.watch<UserModel>().admitTerm;
    final careerType = context.watch<UserModel>().career;
    final studentId = context.watch<UserModel>().matric;

    /// Manually calculate cardRadius to ensure card displays correctly on
    /// different devices.
    final cardWidth =
        MediaQuery.of(context).size.width - 2 * NUSCardScreen.horizontalPadding;
    final cardHeight = cardWidth / (90 / 54);
    final cardRadius = 3 / 90 * cardWidth; // 3mm corners
    final whiteSectionHeight = cardHeight / 3.75 * 2.75;

    /// These two values are magic numbers derived from trial-and-error.
    final photoHeight = whiteSectionHeight * 2 / 3;
    final photoSpacing = photoHeight * 0.15;
    final nusLogoHeight = cardHeight * 0.3;

    final Widget card = Theme(
        data: Theme.of(context).copyWith(
          brightness: Brightness.light,
          textTheme: Theme.of(context).textTheme.apply(
                displayColor: Colors.black,
                bodyColor: Colors.black,
              ),
        ),
        child: AspectRatio(
          aspectRatio: 90 / 54, // 90mm by 54mm
          child: Material(
            elevation: 2.0,
            borderRadius: BorderRadius.circular(cardRadius),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(cardRadius),
              ),
              child: Column(
                children: [
                  /// Orange part of card, 1 / 3.75 of the card
                  Flexible(
                    flex: 100,
                    child: Container(
                        color: NUSCardScreen.nusOrange,
                        child: SizedBox.expand(
                          child: Stack(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text('Student Card',
                                    style: TextStyle(color: Colors.white)),
                              ),
                              Positioned(
                                  right: 0,
                                  child: Image.asset(
                                    'assets/images/nus-logo.jpg',
                                    height: nusLogoHeight,
                                  )),
                            ],
                          ),
                        )),
                  ),

                  /// White part of card
                  Flexible(
                    flex: 275,
                    child: Container(
                      color: Colors.white,
                      child: SizedBox.expand(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                bottom: 0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(userName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    const Text(''), // 1 line of spacing
                                    const Text('Admit Term:'),
                                    Text(admitTerm),
                                    Text('Career: $careerType'),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        const Text('Student ID:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(studentId,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    SizedBox(width: photoSpacing),

                                    /// Photo, with 0.75 aspect ratio
                                    SizedBox(
                                      height: photoHeight,
                                      child: AspectRatio(
                                        aspectRatio: 0.75,
                                        child: Container(
                                          color: Theme.of(context).canvasColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));

    final qrData =
        '$studentId;${DateFormat('yyyyMMdd').format(DateTime.now())};NUSSTU';

    return Scaffold(
      appBar: AppBar(
        title: const Text('NUS Card'),
        elevation: 0,
        backwardsCompatibility: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(NUSCardScreen.horizontalPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              card,
              const SizedBox(height: 16.0),
              QrImage(
                key: ValueKey(qrData),
                backgroundColor: Colors.white,
                data: qrData,
                size: 200.0,
                gapless: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
