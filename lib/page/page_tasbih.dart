import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vibration/vibration.dart';

import '../tools/animated_flip_counter.dart';

class PageTasbih extends StatefulWidget {
  const PageTasbih({super.key});

  @override
  State<PageTasbih> createState() => PageTasbihState();
}

class PageTasbihState extends State<PageTasbih> {
  CarouselSliderController buttonCarouselController = CarouselSliderController();
  final PageController controller = PageController(viewportFraction: 0.15, initialPage: 5);
  final int numberOfCountsToCompleteRound = 33;
  String kBeadsCount = 'beadsCount';
  String kRoundCount = 'roundCount';
  int imageIndex = 1;
  int beadCounter = 0;
  int roundCounter = 0;
  int accumulatedCounter = 0;
  bool canVibrate = true;
  bool isDisposed = false;

  List<String> listTasbih = [
    'سُبْحَانَ ٱللَّٰهِ',
    'اَلْحَمْدُ للَّهِ',
    'ٱللَّٰهُ أَكْبَرُ',
    'لا إِلَهَ إِلاَّ اللهُ'
  ];

  final List<Color> bgColour = [
    Colors.teal.shade50,
    Colors.lime.shade50,
    Colors.lightBlue.shade50,
    Colors.pink.shade50,
    Colors.black12
  ];

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Tasbih",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
              tooltip: 'Change color',
              icon: const Icon(Icons.palette, color: Colors.black),
              onPressed: () {
                setState(() {
                  imageIndex < 5 ? imageIndex++ : imageIndex = 1;
                });
              }
          ),
          IconButton(
              tooltip: 'Reset counter',
              icon: const Icon(Icons.refresh, color: Colors.black),
              onPressed: () {
                confirmReset(context, _resetEverything);
              }
          ),
        ],
      ),
      body: GestureDetector(
        onTap: _clicked,
        onVerticalDragStart: (_) => _clicked(),
        child: SafeArea(
          child: Column(
            children: [
              // Counter display section
              Expanded(
                flex: isSmallScreen ? 3 : 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Round and Beads counters
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Counter(
                            counter: roundCounter,
                            counterName: 'Round',
                            fontSize: isSmallScreen ? 20 : 24,
                          ),
                          Counter(
                            counter: beadCounter,
                            counterName: 'Beads',
                            fontSize: isSmallScreen ? 20 : 24,
                          ),
                        ],
                      ),

                      // Accumulated counter
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                                'Total: ',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 14 : 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                )
                            ),
                            AnimatedFlipCounter(
                              value: accumulatedCounter,
                              duration: const Duration(milliseconds: 730),
                              size: isSmallScreen ? 14 : 16,
                              Textstyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Tasbih text carousel
              Expanded(
                flex: isSmallScreen ? 2 : 2,
                child: Column(
                  children: [
                    Expanded(
                      child: CarouselSlider(
                        carouselController: buttonCarouselController,
                        options: CarouselOptions(
                          height: isSmallScreen ? 80 : 100,
                          enlargeCenterPage: true,
                          viewportFraction: 0.8,
                        ),
                        items: [0, 1, 2, 3].map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                width: screenWidth * 0.75,
                                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                                decoration: BoxDecoration(
                                  color: bgColour[imageIndex - 1],
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    listTasbih[i],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 20 : 24,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),

                    // Navigation buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () {
                                buttonCarouselController.previousPage();
                              },
                              icon: const Icon(Icons.navigate_before,
                                  color: Colors.black87, size: 32)
                          ),
                          const SizedBox(width: 40),
                          IconButton(
                              onPressed: () {
                                buttonCarouselController.nextPage();
                              },
                              icon: const Icon(Icons.navigate_next,
                                  color: Colors.black87, size: 32)
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Beads visualization
              Expanded(
                flex: isSmallScreen ? 3 : 4,
                child: Container(
                  width: screenWidth * 0.6,
                  child: PageView.builder(
                    reverse: true,
                    physics: const NeverScrollableScrollPhysics(),
                    controller: controller,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (_, __) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Image.asset(
                          'assets/beads/bead-$imageIndex.png',
                          fit: BoxFit.contain,
                        ),
                      );
                    },
                    itemCount: null,
                  ),
                ),
              ),

              // Tap instruction with debug info
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.teal.shade200),
                      ),
                      child: Text(
                        'Ketuk layar untuk menghitung tasbih',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 12 : 14,
                          color: Colors.teal.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Debug info (remove this in production)
                    if (kDebugMode)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'DEBUG: B:$beadCounter R:$roundCounter A:$accumulatedCounter',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loadSettings() async {
    bool? canVibrate = await Vibration.hasVibrator();
    if (!isDisposed) {
      setState(() {
        this.canVibrate = canVibrate ?? false;
        loadData();
      });
    }
  }

  void loadData() {
    if (!isDisposed) {
      setState(() {
        beadCounter = GetStorage().read(kBeadsCount) ?? 0;
        roundCounter = GetStorage().read(kRoundCount) ?? 0;
        // Recalculate accumulated counter properly
        accumulatedCounter = roundCounter * numberOfCountsToCompleteRound + beadCounter;
      });
    }
  }

  void _resetEverything() {
    if (!isDisposed) {
      setState(() {
        beadCounter = 0;
        roundCounter = 0;
        accumulatedCounter = 0;
      });
    }
    GetStorage().write(kBeadsCount, 0);
    GetStorage().write(kRoundCount, 0);
  }

  void _clicked() {
    if (!isDisposed) {
      setState(() {
        beadCounter++;
        if (beadCounter > numberOfCountsToCompleteRound) {
          beadCounter = 1;  // Reset to 1, not 0
          roundCounter++;
          if (canVibrate) Vibration.vibrate(duration: 300, amplitude: 100);
        }
        // Calculate accumulated counter after updating beadCounter and roundCounter
        accumulatedCounter = roundCounter * numberOfCountsToCompleteRound + beadCounter;
      });

      // Save data after state update
      GetStorage().write(kBeadsCount, beadCounter);
      GetStorage().write(kRoundCount, roundCounter);

      // Animate bead movement
      int nextPage = controller.page!.round() + 1;
      controller.animateToPage(nextPage,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
      );
    }
  }
}

class Counter extends StatelessWidget {
  const Counter({
    super.key,
    required this.counter,
    required this.counterName,
    this.fontSize = 28,
  });

  final int counter;
  final String counterName;
  final double fontSize;


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: AnimatedFlipCounter(
            duration: const Duration(milliseconds: 300),
            value: counter,
            size: fontSize,
            Textstyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            counterName,
            style: const TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w400,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }
}

void confirmReset(BuildContext context, VoidCallback callback) {
  const confirmText = Text('Reset', style: TextStyle(color: Colors.red));
  const cancelText = Text('Batal', style: TextStyle(color: Colors.black87));
  const dialogTitle = Text("Reset Counter?",
      style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold));
  const dialogContent = Text("Tindakan ini tidak bisa dibatalkan.",
      style: TextStyle(color: Colors.black54));

  void confirmResetAction() {
    callback();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.white),
              SizedBox(width: 10),
              Text('Reset Counter berhasil.',
                  style: TextStyle(color: Colors.white, fontFamily: 'Noto'))
            ],
          ),
          backgroundColor: Colors.green.shade600,
          shape: const StadiumBorder(),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        )
    );
    Navigator.of(context).pop();
  }

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: dialogTitle,
        content: dialogContent,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: cancelText,
          ),
          TextButton(
            onPressed: confirmResetAction,
            child: confirmText,
          ),
        ],
      );
    },
  );
}