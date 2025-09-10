import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

void main() {
  runApp(OutingzApp());
}

class OutingzApp extends StatelessWidget {
  const OutingzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Outingz User App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
          labelLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          labelSmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w300,
            color: Colors.grey[600],
          ),
        ),
      ),
      home: AuthenticationRootWidget(),
    );
  }
}

// App color scheme
class AppColors {
  static const MaterialColor red = MaterialColor(0xFFE53E3E, <int, Color>{
    200: Color(0xFFFC8181),
    700: Color(0xFFB83736),
  });

  static const MaterialColor grey = MaterialColor(0xFF718096, <int, Color>{
    20: Color(0xFFF9F9F9),
  });

  static const Color white = Colors.white;
}

// Asset paths
class AssetResources {
  static const String ONBOARDING_1 = 'assets/images/onboarding_1.png';
  static const String ONBOARDING_2 = 'assets/images/onboarding_2.png';
  static const String ONBOARDING_3 = 'assets/images/onboarding_3.png';
  static const String LOGO = 'assets/images/logo.png';
}

class AuthenticationRootWidget extends StatefulWidget {
  const AuthenticationRootWidget({Key? key}) : super(key: key);

  @override
  State<AuthenticationRootWidget> createState() =>
      _AuthenticationRootWidgetState();
}

class _AuthenticationRootWidgetState extends State<AuthenticationRootWidget> {
  // Current slide index
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  // Onboarding content
  final List<String> _title = [
    "Stress free event booking",
    "Fast payment and easy ticketing",
    "Find your favourite shows",
  ];

  final List<String> _texts = [
    "Your key to hassle-free ticket booking to the hottest events in town",
  ];

  final List<String> images = [
    AssetResources.ONBOARDING_1,
    AssetResources.ONBOARDING_2,
    AssetResources.ONBOARDING_3,
  ];

  Timer? _timer;

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Start auto-progression timer
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      setState(() {
        // Cycle through slides every 3 seconds
        _currentIndex = (_currentIndex + 1) % _title.length;
        _pageController.jumpToPage(_currentIndex);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive design
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SizedBox(
        height: sh,
        child: Stack(
          children: [
            // Background image container
            Container(
              height: 0.6 * sh,
              width: double.infinity,
              color: AppColors.grey[20],
              child: PageView(
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    _currentIndex = value;
                  });
                },
                children: List.generate(
                  images.length,
                  (index) => SizedBox(
                    height: 0.6 * sh,
                    width: double.infinity,
                    child: Image.asset(
                      images[_currentIndex],
                      width: sw,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

            // Content card overlay
            Positioned(
              top: 0.52 * sh,
              child: Container(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: 40,
                ),
                margin: EdgeInsets.symmetric(horizontal: 22),
                width: 0.9 * sw,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                      color: const Color(0xFF909090).withAlpha(51),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Dynamic title based on current slide
                    Text(
                      _title[_currentIndex],
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    // Description text
                    Text(
                      _texts[0],
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    // Action button
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          print('Navigating to login...');
                          print('Setting user first time to true');

                          // Navigation logic would go here
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                _currentIndex == 2
                                    ? 'Get Started! (would go to login)'
                                    : 'Next! (would go to login)',
                              ),
                              backgroundColor: AppColors.red[700],
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.red[700],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          // Button text changes on last slide
                          _currentIndex == 2 ? 'Get Started' : 'Next',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // App logo at top
            Align(
              alignment: Alignment.topCenter,
              child: SafeArea(
                child: Container(
                  margin: EdgeInsets.only(top: Platform.isIOS ? 0 : 20),
                  height: 100,
                  width: 150,
                  child: Image.asset(AssetResources.LOGO),
                ),
              ),
            ),

            // Page indicators at bottom
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => Container(
                      margin: EdgeInsets.only(right: 4),
                      height: 6,
                      width: index == _currentIndex ? 40.0 : 20.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: index == _currentIndex
                            ? AppColors.red[700]
                            : AppColors.red[200],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
