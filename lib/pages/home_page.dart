import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stake_trade/model/stock_item.dart';
import 'package:stake_trade/model/user.dart';
import 'package:stake_trade/pages/screen_page.dart';

UserItem user = UserItem(balance: 10000);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Stock> mystocks = [];
  List<Stock> stocks = [
    Stock(
        cost: 200.00,
        increasePercent: -0.30,
        name: 'Technology',
        positiveArticle: 'Technological innovations and breakthroughs:',
        positiveText:
            'Announcement of new technologies, technological breakthroughs, or patents can push the company\'s stocks higher.',
        negativeArticle: 'Technological obsolescence:',
        negativeText:
            'Rapid technological advancements or shifts in consumer preferences can render existing products or services obsolete, leading to a decline in demand and stock prices.',
        image: 'assets/technology.png'),
    Stock(
        cost: 120.00,
        increasePercent: 0.5,
        name: 'Pharmaceutical',
        positiveArticle: 'Strategic mergers and acquisitions',
        positiveText:
            'Participation in strategic mergers and acquisitions that strengthen the company\'s market positions or expand its portfolio of products and services can attract investor interest.',
        negativeArticle: 'Leadership scandals or controversies:',
        negativeText:
            'Scandals or controversies involving company executives or key personnel can erode investor trust and have a detrimental impact on stock prices.',
        image: 'assets/pharmaceutical.png'),
    Stock(
        cost: 280.00,
        increasePercent: 2.00,
        name: 'Financial',
        positiveArticle: 'Positive financial results:',
        positiveText:
            'Publishing positive financial reports, including revenue growth, profits, and growth indicators, can strengthen investor confidence and support stock prices.',
        negativeArticle: 'Macroeconomic factors:',
        negativeText:
            'Economic downturns, recessions, or geopolitical tensions can weaken consumer spending and corporate investment, negatively impacting technology companies\' earnings and stock prices.',
        image: 'assets/financial.png'),
    Stock(
        cost: 90,
        increasePercent: 1.0,
        name: 'Retail',
        positiveArticle: 'Growth in user base or activity:',
        positiveText:
            'Significant growth in the number of users or activity on the platform (such as an increase in active users, time spent on the site, or app downloads) can positively impact stocks.',
        negativeArticle: 'Negative press or public perception:',
        negativeText:
            'Negative media coverage, social media backlash, or public relations crises can tarnish a company\'s brand image and lead to a decrease in investor confidence, resulting in a drop in stock prices.',
        image: 'assets/retail.png'),
    Stock(
        cost: 150,
        increasePercent: -2.0,
        name: 'Energy',
        positiveArticle: 'Stable leadership and development strategy:',
        positiveText:
            'Confirmation of stable company leadership and announcement of a clear development strategy for the future can strengthen investor confidence and support stock prices.',
        negativeArticle: 'Supply chain disruptions:',
        negativeText:
            'Disruptions in the supply chain due to natural disasters, trade disputes, or geopolitical conflicts can disrupt production and distribution, affecting technology companies\' ability to meet market demand and impacting stock prices.',
        image: 'assets/energy.png'),
  ];
  Timer? timer;
  Timer? timer2;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
      const Duration(seconds: 3),
      (timer) {
        for (var stock in stocks) {
          Stock sameMyStock = mystocks
              .firstWhere((element) => element.name == stock.name, orElse: () {
            return Stock();
          });
          stock.increasePercent = doubleInRange(-3.0, 3.0);
          if (sameMyStock.increasePercent != null) {
            sameMyStock.increasePercent = stock.increasePercent;
          }
          stock.cost =
              stock.cost! + (stock.cost! * stock.increasePercent! / 100);
          if (sameMyStock.cost != null) {
            sameMyStock.cost = stock.cost;
          }

          setState(() {});
        }
      },
    );

    getShared();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Future(() {
      if (user.balance == 0 || user.balance! < 0) {
        timer!.cancel();
        showDialog(
            context: context,
            builder: (_) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Dialog(
                    backgroundColor: const Color(0xFF00212F),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: const Color(0xFF00212F),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(bottom: 16),
                              child: Text(
                                'Well...',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 16),
                              child: Text(
                                'Your balance is empty! Try one more time, but think all time!',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Color(0xFF90B6C8),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.clear();
                                if (context.mounted) {
                                  Phoenix.rebirth(context);
                                }
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(52, 11, 52, 11),
                                decoration: BoxDecoration(
                                    color: const Color(0xFF1C4256),
                                    borderRadius: BorderRadius.circular(60)),
                                child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Restart',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ]),
                              ),
                            ),
                          ]),
                    ),
                  )
                ],
              );
            });
      }
    });
    return Scaffold(
      backgroundColor: const Color(0xFF0D2D3A),
      body: DefaultTabController(
        length: 2,
        child: Column(children: [
          Container(
              padding: const EdgeInsets.fromLTRB(24, 65, 24, 12),
              decoration: const BoxDecoration(
                color: Color(0xFF00212F),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topLeft,
                    children: [
                      Container(
                        width: 157,
                        height: 31,
                        padding: const EdgeInsets.only(top: 2, left: 10),
                        decoration: BoxDecoration(
                            color: const Color(0xFF1C4256),
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          user.balance!.toStringAsFixed(2),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Positioned(
                        top: -13,
                        left: -10,
                        child: Image.asset(
                          'assets/money.png',
                          scale: 2.5,
                        ),
                      )
                    ],
                  ),
                  Image.asset(
                    'assets/logo.png',
                    scale: 2.5,
                  ),
                  InkWell(
                    onTap: () {
                      settingsDialog();
                    },
                    child: Image.asset(
                      'assets/settings.png',
                    ),
                  ),
                ],
              )),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: Container(
              padding: const EdgeInsets.only(left: 12, bottom: 12, top: 12),
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFA700FF), Color(0xFFE600FF)]),
                  borderRadius: BorderRadius.circular(20)),
              child: Row(children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8, top: 11),
                        child: Image.asset('assets/fire.png'),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text(
                          'Events of the day',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 11),
                        child: InkWell(
                          onTap: () {
                            Stock newSctock =
                                stocks.elementAt(Random().nextInt(5));
                            newSctock.increasePercent =
                                doubleInRange(-3.0, 3.0);
                            newSctock.cost = newSctock.cost! +
                                (newSctock.cost! *
                                    newSctock.increasePercent! /
                                    100);
                            stockEventDialog(newSctock);
                          },
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(0, 11, 0, 11),
                            decoration: BoxDecoration(
                                color: const Color(0xFF1C4256),
                                borderRadius: BorderRadius.circular(60)),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/generate.png'),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  const Text(
                                    'Generate',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ]),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Image.asset('assets/events.png'),
                  ],
                ))
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Container(
                height: 56,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      60,
                    ),
                    color: const Color(0xFF00212F),
                  ),
                  child: TabBar(
                    dividerHeight: 0,
                    padding: const EdgeInsets.all(8),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        60,
                      ),
                      color: const Color(0xFF1C4256),
                    ),
                    tabs: [
                      Tab(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/allstocks.png'),
                              const SizedBox(
                                width: 4,
                              ),
                              const Text(
                                'All Stocks',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                            ]),
                      ),
                      Tab(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/mystocks.png'),
                              const SizedBox(
                                width: 4,
                              ),
                              const Text(
                                'Your Stocks',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                            ]),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                SingleChildScrollView(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: getStocks(),
                )),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                    child: mystocks.isEmpty
                        ? const Text(
                            'Buy your first Stock in All stocks',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          )
                        : getMyStocks(),
                  ),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }

  Widget getStocks() {
    List<Widget> list = [];
    for (var stock in stocks) {
      list.add(InkWell(
        onTap: () {
          stockDescriptionDialog(stock);
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: const Color(0xFF00212F),
              borderRadius: BorderRadius.circular(10)),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              children: [
                Image.asset(
                  stock.image!,
                  scale: 3.6,
                ),
                const SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stock.name!,
                      style: const TextStyle(
                          fontFamily: 'Poppins', color: Colors.white),
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/money.png',
                          scale: 3.5,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          stock.cost!.toStringAsFixed(2),
                          style: const TextStyle(
                              fontFamily: 'Poppins', color: Color(0xFF90B6C8)),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
              decoration: BoxDecoration(
                  color: stock.increasePercent!.isNegative
                      ? const Color(0xFFE1214F)
                      : const Color(0xFF00FD00),
                  borderRadius: BorderRadius.circular(7)),
              child: Row(children: [
                stock.increasePercent!.isNegative
                    ? Image.asset(
                        'assets/down.png',
                      )
                    : Image.asset(
                        'assets/up.png',
                      ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  '${stock.increasePercent!.toStringAsFixed(2).replaceAll('-', '')}%',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: stock.increasePercent!.isNegative
                          ? Colors.white
                          : Colors.black),
                ),
              ]),
            ),
          ]),
        ),
      ));
      list.add(const SizedBox(
        height: 8,
      ));
    }
    return Column(
      children: list,
    );
  }

  void stockDescriptionDialog(Stock stock) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setstate) {
            timer2 = Timer.periodic(
              const Duration(seconds: 1),
              (timer) {
                if (context.mounted) {
                  setstate(() {});
                }
              },
            );
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Dialog(
                  backgroundColor: const Color(0xFF00212F),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: const Color(0xFF00212F),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${stock.name} Stock',
                              style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Image.asset('assets/close.png'))
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            stock.image!,
                            scale: 2,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                stock.name!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontFamily: 'Poppins', color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/money.png',
                                    scale: 3.5,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    stock.cost!.toStringAsFixed(2),
                                    style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Color(0xFF90B6C8)),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 2, 8, 2),
                                  decoration: BoxDecoration(
                                      color: stock.increasePercent!.isNegative
                                          ? const Color(0xFFE1214F)
                                          : const Color(0xFF00FD00),
                                      borderRadius: BorderRadius.circular(7)),
                                  child: Row(children: [
                                    stock.increasePercent!.isNegative
                                        ? Image.asset(
                                            'assets/down.png',
                                          )
                                        : Image.asset(
                                            'assets/up.png',
                                          ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      '${stock.increasePercent!.toStringAsFixed(2).replaceAll('-', '')}%',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color:
                                              stock.increasePercent!.isNegative
                                                  ? Colors.white
                                                  : Colors.black),
                                    ),
                                  ]),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 16, top: 16),
                        child: Divider(
                          color: Color(
                            0xFF1C4256,
                          ),
                          height: 1,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Text(
                                  'You have',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Row(
                                children: [
                                  Image.asset('assets/amount.png'),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    mystocks.firstWhere(
                                                (element) =>
                                                    element.name == stock.name,
                                                orElse: () {
                                              return Stock();
                                            }).amount !=
                                            null
                                        ? mystocks
                                            .firstWhere(
                                                (element) =>
                                                    element.name == stock.name,
                                                orElse: () {
                                              return Stock();
                                            })
                                            .amount!
                                            .toString()
                                        : '0',
                                    style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Color(0xFF90B6C8),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Image.asset(
                                'assets/money.png',
                                scale: 4,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                mystocks.firstWhere(
                                            (element) =>
                                                element.name == stock.name,
                                            orElse: () {
                                          return Stock();
                                        }).amount !=
                                        null
                                    ? (stock.cost! *
                                            mystocks.firstWhere(
                                                (element) =>
                                                    element.name == stock.name,
                                                orElse: () {
                                              return Stock();
                                            }).amount!)
                                        .toStringAsFixed(2)
                                    : 'You dont have any',
                                style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Color(0xFF90B6C8),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          )
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 16),
                        child: Divider(
                          color: Color(
                            0xFF1C4256,
                          ),
                          height: 1,
                        ),
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Last event',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              stock.increasePercent!.isNegative
                                  ? stock.negativeArticle!
                                  : stock.positiveArticle!,
                              style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                stock.increasePercent!.isNegative
                                    ? stock.negativeText!
                                    : stock.positiveText!,
                                style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Color(0xFF90B6C8),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: mystocks.firstWhere(
                                    (element) => element.name == stock.name,
                                    orElse: () {
                                  return Stock();
                                }).cost ==
                                null
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.spaceBetween,
                        children: [
                          if (mystocks.firstWhere(
                                  (element) => element.name == stock.name,
                                  orElse: () {
                                return Stock();
                              }).cost !=
                              null)
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);

                                  buySelldialog(stock, true);
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 11, 0, 11),
                                  decoration: BoxDecoration(
                                      color: const Color(0xFF1C4256),
                                      borderRadius: BorderRadius.circular(60)),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset('assets/sell.png'),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        const Text(
                                          'Sell',
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ]),
                                ),
                              ),
                            ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                buySelldialog(stock, false);
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 11, 0, 11),
                                decoration: BoxDecoration(
                                    color: const Color(0xFF1C4256),
                                    borderRadius: BorderRadius.circular(60)),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/buy.png'),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      const Text(
                                        'Buy',
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                        ],
                      )
                    ]),
                  ),
                )
              ],
            );
          });
        });
  }

  void stockEventDialog(Stock stock) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setstate) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Dialog(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: const Color(0xFF00212F),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${stock.name} Stock',
                              style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Image.asset('assets/close.png'))
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            stock.image!,
                            scale: 2,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                stock.name!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontFamily: 'Poppins', color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/money.png',
                                    scale: 3.5,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    stock.cost!.toStringAsFixed(2),
                                    style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Color(0xFF90B6C8)),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 2, 8, 2),
                                  decoration: BoxDecoration(
                                      color: stock.increasePercent!.isNegative
                                          ? const Color(0xFFE1214F)
                                          : const Color(0xFF00FD00),
                                      borderRadius: BorderRadius.circular(7)),
                                  child: Row(children: [
                                    stock.increasePercent!.isNegative
                                        ? Image.asset(
                                            'assets/down.png',
                                          )
                                        : Image.asset(
                                            'assets/up.png',
                                          ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      '${stock.increasePercent!.toStringAsFixed(2).replaceAll('-', '')}%',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color:
                                              stock.increasePercent!.isNegative
                                                  ? Colors.white
                                                  : Colors.black),
                                    ),
                                  ]),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 16, top: 16),
                        child: Divider(
                          color: Color(
                            0xFF1C4256,
                          ),
                          height: 1,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              stock.increasePercent!.isNegative
                                  ? stock.negativeArticle!
                                  : stock.positiveArticle!,
                              style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                stock.increasePercent!.isNegative
                                    ? stock.negativeText!
                                    : stock.positiveText!,
                                style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Color(0xFF90B6C8),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: mystocks.firstWhere(
                                    (element) => element.name == stock.name,
                                    orElse: () {
                                  return Stock();
                                }).cost ==
                                null
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              buySelldialog(stock, false);
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.fromLTRB(52, 11, 52, 11),
                              decoration: BoxDecoration(
                                  color: const Color(0xFF1C4256),
                                  borderRadius: BorderRadius.circular(60)),
                              child: Row(children: [
                                Image.asset('assets/buy.png'),
                                const SizedBox(
                                  width: 4,
                                ),
                                const Text(
                                  'Buy',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                              ]),
                            ),
                          ),
                        ],
                      )
                    ]),
                  ),
                )
              ],
            );
          });
        });
  }

  void buySelldialog(Stock stock, bool isSellDialog) {
    showDialog(
        context: context,
        builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Dialog(
                backgroundColor: const Color(0xFF00212F),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: const Color(0xFF00212F),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isSellDialog
                                ? 'Sell ${stock.name} Stock'
                                : 'Buy ${stock.name} Stock',
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Image.asset('assets/close.png'))
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 16, top: 16),
                        child: Divider(
                          color: Color(
                            0xFF1C4256,
                          ),
                          height: 1,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Text(
                                  'You have',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Row(
                                children: [
                                  Image.asset('assets/amount.png'),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    mystocks.firstWhere(
                                                (element) =>
                                                    element.name == stock.name,
                                                orElse: () {
                                              return Stock();
                                            }).amount !=
                                            null
                                        ? mystocks
                                            .firstWhere(
                                                (element) =>
                                                    element.name == stock.name,
                                                orElse: () {
                                              return Stock();
                                            })
                                            .amount!
                                            .toString()
                                        : '0',
                                    style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Color(0xFF90B6C8),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Image.asset(
                                'assets/money.png',
                                scale: 4,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                mystocks.firstWhere(
                                            (element) =>
                                                element.name == stock.name,
                                            orElse: () {
                                          return Stock();
                                        }).amount !=
                                        null
                                    ? (stock.cost! *
                                            mystocks.firstWhere(
                                                (element) =>
                                                    element.name == stock.name,
                                                orElse: () {
                                              return Stock();
                                            }).amount!)
                                        .toStringAsFixed(2)
                                    : '0',
                                style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Color(0xFF90B6C8),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          )
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 16),
                        child: Divider(
                          color: Color(
                            0xFF1C4256,
                          ),
                          height: 1,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Text(
                                  isSellDialog ? 'Sell price' : 'Buy price',
                                  style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Row(
                                children: [
                                  Image.asset('assets/amount.png'),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text(
                                    '1',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Color(0xFF90B6C8),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Image.asset(
                                'assets/money.png',
                                scale: 4,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                stock.cost!.toStringAsFixed(2),
                                style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Color(0xFF90B6C8),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          )
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 16),
                        child: Divider(
                          color: Color(
                            0xFF1C4256,
                          ),
                          height: 1,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (isSellDialog &&
                              mystocks.firstWhere(
                                      (element) => element.name == stock.name,
                                      orElse: () {
                                    return Stock();
                                  }).cost !=
                                  null) {
                            mystocks.firstWhere(
                                (element) => element.name == stock.name,
                                orElse: () {
                              return Stock();
                            }).amount = mystocks.firstWhere(
                                    (element) => element.name == stock.name,
                                    orElse: () {
                                  return Stock();
                                }).amount! -
                                1;
                            user.balance = user.balance! + stock.cost!;
                            if (mystocks.firstWhere(
                                    (element) => element.name == stock.name,
                                    orElse: () {
                                  return Stock();
                                }).amount ==
                                0) {
                              user.balance = user.balance! + stock.cost!;
                              mystocks.remove(stock);
                            }
                          } else {
                            if (mystocks.firstWhere(
                                    (element) => element.name == stock.name,
                                    orElse: () {
                                  return Stock();
                                }).cost ==
                                null) {
                              stock.amount = 1;
                              user.balance = user.balance! - stock.cost!;
                              mystocks.add(stock);
                            } else {
                              mystocks.firstWhere(
                                  (element) => element.name == stock.name,
                                  orElse: () {
                                return Stock();
                              }).amount = mystocks.firstWhere(
                                      (element) => element.name == stock.name,
                                      orElse: () {
                                    return Stock();
                                  }).amount! +
                                  1;
                              user.balance = user.balance! - stock.cost!;
                            }
                          }
                          addToShared(mystocks);
                          Navigator.pop(context);
                          setState(() {});
                        },
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(52, 11, 52, 11),
                          decoration: BoxDecoration(
                              color: const Color(0xFF1C4256),
                              borderRadius: BorderRadius.circular(60)),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                isSellDialog
                                    ? Image.asset('assets/sell.png')
                                    : Image.asset('assets/buy.png'),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  isSellDialog ? 'Sell' : 'Buy',
                                  style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        });
  }

  void settingsDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Dialog(
                backgroundColor: const Color(0xFF00212F),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: const Color(0xFF00212F),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Settings',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Image.asset('assets/close.png'))
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 16, top: 16),
                        child: Divider(
                          color: Color(
                            0xFF1C4256,
                          ),
                          height: 1,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    const RouteForRead(
                                      rtt:
                                          'https://docs.google.com/document/d/1kKSSswBJlcxKoHWDIMqHWXu9An1qoYo9Xjm5kaVRhSs/edit?usp=sharing',
                                    )),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Privacy Policy',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Color(0xFFE5F9FF),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                            Image.asset('assets/arrow.png')
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 16),
                        child: Divider(
                          color: Color(
                            0xFF1C4256,
                          ),
                          height: 1,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    const RouteForRead(
                                      rtt:
                                          'https://docs.google.com/document/d/1poov8ypcHm086vF_5NULavAkGJDtTxaGjgUWDNuvj84/edit?usp=sharing',
                                    )),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Terms of Use',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Color(0xFFE5F9FF),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                            Image.asset('assets/arrow.png')
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 16),
                        child: Divider(
                          color: Color(
                            0xFF1C4256,
                          ),
                          height: 1,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    const RouteForRead(
                                      rtt:
                                          'https://forms.gle/KTk8ozxsae7bUVfbA',
                                    )),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Support',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Color(0xFFE5F9FF),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                            Image.asset('assets/arrow.png')
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 16),
                        child: Divider(
                          color: Color(
                            0xFF1C4256,
                          ),
                          height: 1,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          InAppReview.instance.openStoreListing(appStoreId: '6479026355');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Rate app',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Color(0xFFE5F9FF),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                            Image.asset('assets/arrow.png')
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Divider(
                          color: Color(
                            0xFF1C4256,
                          ),
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        });
  }

  Widget getMyStocks() {
    List<Widget> list = [];
    for (var stock in mystocks) {
      list.add(InkWell(
        onTap: () {
          stockDescriptionDialog(stock);
        },
        child: Container(
          width: 178,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: const Color(0xFF00212F),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                stock.image!,
                scale: 3.6,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      stock.name!,
                      style: const TextStyle(
                          fontFamily: 'Poppins', color: Colors.white),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/money.png',
                          scale: 3.5,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          stock.cost!.toStringAsFixed(2),
                          style: const TextStyle(
                              fontFamily: 'Poppins', color: Color(0xFF90B6C8)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                      decoration: BoxDecoration(
                          color: stock.increasePercent!.isNegative
                              ? const Color(0xFFE1214F)
                              : const Color(0xFF00FD00),
                          borderRadius: BorderRadius.circular(7)),
                      child: Row(children: [
                        stock.increasePercent!.isNegative
                            ? Image.asset(
                                'assets/down.png',
                              )
                            : Image.asset(
                                'assets/up.png',
                              ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          '${stock.increasePercent!.toStringAsFixed(2).replaceAll('-', '')}%',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: stock.increasePercent!.isNegative
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Text(
                          'You have',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Row(
                        children: [
                          Image.asset('assets/amount.png'),
                          const SizedBox(
                            width: 5,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            stock.amount.toString(),
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xFF90B6C8),
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'assets/money.png',
                        scale: 4,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        (stock.cost! * stock.amount!).toStringAsFixed(2),
                        style: const TextStyle(
                            fontFamily: 'Poppins',
                            color: Color(0xFF90B6C8),
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ));
      list.add(const SizedBox(
        height: 8,
      ));
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        alignment:
            list.length == 2 ? WrapAlignment.start : WrapAlignment.center,
        runSpacing: 20,
        spacing: 5,
        children: list,
      ),
    );
  }

  double doubleInRange(num start, num end) =>
      Random().nextDouble() * (end - start) + start;
  Future<void> addToShared(
    List<Stock>? myStocks,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user', jsonEncode(user));
    if (myStocks != null) {
      prefs.setString('myStocks', jsonEncode(myStocks));
    }
  }

  void getShared() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user') != null) {
      Map<String, dynamic> userMap = jsonDecode(prefs.getString('user')!);
      if (UserItem.fromJson(userMap).balance != 0.00) {
        user = UserItem.fromJson(userMap);
      }
    } else {
      user.balance = 10000.00;
    }
    final List<dynamic> jsonData =
        jsonDecode(prefs.getString('myStocks') ?? '[]');

    mystocks = jsonData.map<Stock>((jsonList) {
      {
        return Stock.fromJson(jsonList);
      }
    }).toList();
    setState(() {});
  }
}
