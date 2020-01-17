import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sy_travel_animation/style.dart';

import 'leopard_page.dart';
import 'dart:math' as math;

class PageOffsetNotifier with ChangeNotifier {
  double _offset = 0.0;
  double _page = 0;
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
  final PageController _pageController = PageController(initialPage: 0);

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
              TravelDetailLabel(),
              StartCampLabel(),
              StartTimeLabel(),
              BaseCampLabel(),
              BaseTimeLabel(),
              DistanceLabel(),
              TravelDots(),
              MapButton(),
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
    return Center(
      child: VultureCircle(),
    );
  }
}

class TravelDetailLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (_, notifier, child) => Positioned(
        left: 29 + MediaQuery.of(context).size.width - notifier.offset,
        top: 80.0 + 330 + 14,
        child: Opacity(
          opacity: math.max(4 * notifier.page - 3, 0),
          child: child,
        ),
      ),
      child: Text(
        "Travel Detail",
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

class StartCampLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (_, notifier, child) {
        final double opacity = math.max(4 * notifier.page - 3, 0);
        return Positioned(
          left: opacity * 21.0,
          top: 80.0 + 330 + 14 + 50,
          width: (MediaQuery.of(context).size.width - 22) / 3,
          child: Opacity(
            opacity: opacity,
            child: child,
          ),
        );
      },
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          "Start camp",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
        ),
      ),
    );
  }
}

class StartTimeLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (_, notifier, child) {
        final double opacity = math.max(4 * notifier.page - 3, 0);
        return Positioned(
          left: opacity * 21.0,
          top: 80.0 + 330 + 14 + 50 + 40,
          width: (MediaQuery.of(context).size.width - 22) / 3,
          child: Opacity(
            opacity: opacity,
            child: child,
          ),
        );
      },
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          "02:40 pm",
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w300, color: lighterGrey),
        ),
      ),
    );
  }
}

class BaseCampLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (_, notifier, child) {
        final double opacity = math.max(4 * notifier.page - 3, 0);
        return Positioned(
          right: opacity * 21.0,
          top: 80.0 + 330 + 14 + 50,
          width: (MediaQuery.of(context).size.width - 22) / 3,
          child: Opacity(
            opacity: opacity,
            child: child,
          ),
        );
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Start camp",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
        ),
      ),
    );
  }
}

class BaseTimeLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (_, notifier, child) {
        final double opacity = math.max(4 * notifier.page - 3, 0);
        return Positioned(
          right: opacity * 21.0,
          top: 80.0 + 330 + 14 + 50 + 40,
          width: (MediaQuery.of(context).size.width - 22) / 3,
          child: Opacity(
            opacity: opacity,
            child: child,
          ),
        );
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "07:30 am",
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w300, color: lighterGrey),
        ),
      ),
    );
  }
}

class DistanceLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (_, notifier, child) {
        final double opacity = math.max(4 * notifier.page - 3, 0);
        return Positioned(
          top: 80.0 + 330 + 14 + 50 + 40,
          width: (MediaQuery.of(context).size.width),
          child: Opacity(
            opacity: opacity,
            child: child,
          ),
        );
      },
      child: Center(
        child: Text(
          "72 km",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: white,
          ),
        ),
      ),
    );
  }
}

class MapButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 5,
      bottom: 4,
      child: Consumer<PageOffsetNotifier>(
        builder: (context, notifier, child) {
          final double opacity = math.max(4 * notifier.page - 3, 0);
          return Opacity(opacity: opacity, child: child);
        },
        child: FlatButton(
          child: Text(
            "ON MAP",
            style: TextStyle(fontSize: 12),
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}

class VultureCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        final double multiplier = math.max(4 * notifier.page - 3, 0);
        final double size =
            MediaQuery.of(context).size.width * multiplier * 0.5;
        return Container(
          margin: EdgeInsets.only(bottom: 180),
          decoration: BoxDecoration(shape: BoxShape.circle, color: lighterGrey),
          width: size,
          height: size,
        );
      },
    );
  }
}

class TravelDots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        final double opacity = math.max(4 * notifier.page - 3, 0);
        final double margin = 30 * opacity + 10;
        return Positioned(
          top: 80.0 + 330 + 14 + 50,
          height: 20,
          left: 0,
          right: 0,
          child: Center(
            child: Opacity(
              opacity: opacity,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: margin * 0.3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: lightGrey,
                    ),
                    width: 5,
                    height: 5,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: margin * 0.3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: lightGrey,
                    ),
                    width: 5,
                    height: 5,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: margin),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: white,
                    ),
                    width: 6,
                    height: 6,
                  ),
                  Container(
                    margin: EdgeInsets.only(right: margin),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: white),
                    ),
                    width: 6,
                    height: 6,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
