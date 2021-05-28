import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class NUSCardScreen extends StatelessWidget {
  const NUSCardScreen({Key? key}) : super(key: key);

  static const double horizontalPadding = 32.0;
  static const Color nusOrange = Color(0xFFF07D08);

  @override
  Widget build(BuildContext context) {
    const String userName = 'John Smith';
    const String admitTerm = '2020/2021 Semester 1';
    const String careerType = 'Undergraduate';
    const String studentId = 'A0201234Z';

    /// Manually calculate cardRadius to ensure card displays correctly on
    /// different devices.
    final double cardWidth =
        MediaQuery.of(context).size.width - 2 * horizontalPadding;
    final double cardHeight = cardWidth / (90 / 54);
    final double cardRadius = 3 / 90 * cardWidth; // 3mm corners
    final double whiteSectionHeight = cardHeight / 3.75 * 2.75;

    /// These two values are magic numbers derived from trial-and-error.
    final double photoHeight = whiteSectionHeight * 2 / 3;
    final double photoSpacing = photoHeight * 0.15;
    final double nusLogoHeight = cardHeight * 0.3;

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
                        color: nusOrange,
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
                                  children: const [
                                    Text(userName,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(''), // 1 line of spacing
                                    Text('Admit Term:'),
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
                                      children: const [
                                        Text('Student ID:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(studentId,
                                            style: TextStyle(
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('NUS Card'),
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        backwardsCompatibility: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(horizontalPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            card,
            QrImage(
              backgroundColor: Colors.white,
              data:
                  '$studentId;${DateTime.now().millisecondsSinceEpoch};NUSSTU',
              version: QrVersions.auto,
              size: 200.0,
            ),
          ],
        ),
      ),
    );
  }
}
