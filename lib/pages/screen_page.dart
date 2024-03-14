import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class RouteForRead extends StatelessWidget {
  final String rtt;

  const RouteForRead({Key? key, required this.rtt})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
      ),
      body: SafeArea(
        bottom: false,
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: Uri.parse(rtt)),
        ),
      ),
    );
  }
}
