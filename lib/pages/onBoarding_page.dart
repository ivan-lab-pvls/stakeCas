import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:stake_trade/pages/home_page.dart';

class NewItemScreen extends StatelessWidget {
  final String details;

  const NewItemScreen({Key? key, required this.details}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: Uri.parse(details)),
        ),
      ),
    );
  }
}

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  ValueNotifier<int> page = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D2D3A),
      body: SingleChildScrollView(
        child: Column(children: [
          if (page.value == 0)
            Padding(
              padding: const EdgeInsets.only(top: 77),
              child: Image.asset('assets/first_onBoarding_image.png'),
            ),
          if (page.value == 1)
            Padding(
              padding: const EdgeInsets.only(top: 77),
              child: Image.asset('assets/second_onBoarding_image.png'),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 83, 11, 14),
            child: Column(children: [
              if (page.value == 0)
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Stake App welcomes you!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              if (page.value == 0)
                const Padding(
                  padding: EdgeInsets.only(bottom: 38),
                  child: Text(
                    'Learn how to buy/sell stocks safely! No money is needed, only your intuition.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: Color(0xFF90B6C8),
                        fontWeight: FontWeight.w400),
                  ),
                ),
              if (page.value == 1)
                const Padding(
                  padding: EdgeInsets.only(
                    bottom: 10,
                  ),
                  child: Text(
                    'How to play',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              if (page.value == 1)
                const Padding(
                  padding: EdgeInsets.only(bottom: 38),
                  child: Text(
                    'Buy first stocks. Generate event. Read the description. Repeat!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: Color(0xFF90B6C8),
                        fontWeight: FontWeight.w400),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(bottom: 46),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: page,
                      builder: (context, index, child) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: DotsIndicator(
                          dotsCount: 2,
                          position: page.value,
                          decorator: DotsDecorator(
                            size: const Size(8.0, 8.0),
                            activeSize: const Size(8.0, 8.0),
                            spacing: const EdgeInsets.all(3),
                            color: Colors.white,
                            activeColor: const Color(0xFF0072F4),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            activeShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 20, 18),
                child: InkWell(
                  onTap: () {
                    if (page.value == 0) {
                      page.value = 1;
                      setState(() {});
                    } else if (page.value == 1) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const HomePage()),
                      );
                    }
                  },
                  child: Container(
                      width: 152,
                      height: 44,
                      padding: const EdgeInsets.only(top: 13),
                      decoration: BoxDecoration(
                          color: const Color(0xFF0072F4),
                          borderRadius: BorderRadius.circular(60)),
                      child: const Text(
                        'Start',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      )),
                ),
              ),
            ]),
          )
        ]),
      ),
    );
  }
}
