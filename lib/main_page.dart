import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sy_travel_animation/style.dart';

import 'leopard_page.dart';

class PageOffsetNotifier with ChangeNotifier {
  double _offset;
  double _page;
  double get offset => _offset;

  PageOffsetNotifier(PageController pageController) {
    pageController.addListener(() {
      _offset = pageController.offset;
      _page = pageController.page;
      notifyListeners();
    });
  }

  double get page => _page;
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PageOffsetNotifier(_pageController),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[
              PageView(
                controller: _pageController,
                physics: ClampingScrollPhysics(),
                children: <Widget>[
                  LeopardPage(),
                  VulturePage(),
                ],
              ),
              AppBar(),
              LeopardImage(),
              VultureImage(),
              ShareButton(),
              PageIndicator(),
              ArrowIcon(),
            ],
          ),
        ),
      ),
    );
  }
}

class AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
        child: Row(
          children: <Widget>[
            Text(
              "SY",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            Spacer(),
            Icon(Icons.menu),
          ],
        ),
      ),
    );
  }
}

class VultureImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        return Positioned(
          left:
              1.2 * MediaQuery.of(context).size.width - notifier.offset * 0.85,
          child: child,
        );
      },
      child: IgnorePointer(
          child: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: Image.asset(
          "assets/vulture.png",
          height: MediaQuery.of(context).size.height / 3,
        ),
      )),
    );
  }
}

class ShareButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 24,
      bottom: 16,
      child: Icon(Icons.share),
    );
  }
}

class ArrowIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 80.0 + 330 + 14,
      right: 24,
      child: Icon(
        Icons.keyboard_arrow_up,
        color: lighterGrey,
      ),
    );
  }
}

class PageIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) => Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(
                    255,
                    255 - (notifier.page.abs() * 160).round(),
                    255 - (notifier.page.abs() * 160).round(),
                    255 - (notifier.page.abs() * 160).round(),
                  ),
                ),
                width: 7,
                height: 7,
              ),
              SizedBox(
                width: 12,
                height: 24,
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(
                    255,
                    255 - ((1 - notifier.page).abs() * 160).round(),
                    255 - ((1 - notifier.page).abs() * 160).round(),
                    255 - ((1 - notifier.page).abs() * 160).round(),
                  ),
                ),
                width: 7,
                height: 7,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VulturePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center();
  }
}
