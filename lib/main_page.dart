import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

class MapAnimationController extends AnimationController {
  final TickerProvider vsync;
  final Duration duration;

  MapAnimationController({this.vsync, this.duration})
      : super(vsync: vsync, duration: duration);
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController(initialPage: 0);

  AnimationController _animationController;
  AnimationController _mapAnimationController;
  double get maxHeight => (330 + 14.0);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));

    _mapAnimationController = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: 2000,
        ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _mapAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PageOffsetNotifier(_pageController),
      child: ListenableProvider.value(
        value: _animationController,
        child: ListenableProvider.value(
          value: _mapAnimationController,
          child: Scaffold(
            body: SafeArea(
              child: GestureDetector(
                onVerticalDragUpdate: _handleDragUpdate,
                onVerticalDragEnd: _handleDragEnd,
                child: Stack(
                  alignment: Alignment.center,
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
                    VerticalTravelDots(),
                    HorizontalTravelDots(),
                    MapButton(),
                    VultureIconLabel(),
                    LeopardIconLabel(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _animationController.value -= details.primaryDelta / maxHeight;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_animationController.isAnimating ||
        _animationController.status == AnimationStatus.completed) return;

    final double flingVelocity =
        details.velocity.pixelsPerSecond.dy / maxHeight;

    if (flingVelocity < 0.0)
      _animationController.fling(velocity: math.max(2.0, -flingVelocity));
    else if (flingVelocity > 0.0)
      _animationController.fling(velocity: math.min(-2.0, -flingVelocity));
    else
      _animationController.fling(
          velocity: _animationController.value < 0.5 ? -2.0 : 2.0);
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
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        return Positioned(
          left:
              1.2 * MediaQuery.of(context).size.width - notifier.offset * 0.85,
          child: Transform.scale(
            alignment: Alignment(0, 0.1),
            scale: 1 - 0.2 * animation.value,
            child: Opacity(opacity: 1 - 0.3 * animation.value, child: child),
          ),
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
    return Consumer<AnimationController>(
      builder: (context, animation, child) {
        return Positioned(
          top: (1 - animation.value) * (330 + 14) + 80,
          right: 24,
          child: child,
        );
      },
      child: Icon(
        Icons.keyboard_arrow_up,
        size: 28,
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
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (_, notifier, animation, child) => Positioned(
        left: 29 + MediaQuery.of(context).size.width - notifier.offset,
        top: 80.0 + (330 + 14) * (1 - animation.value),
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
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (_, notifier, animation, child) {
        final double opacity = math.max(4 * notifier.page - 3, 0);
        return Positioned(
          right: opacity * 21.0,
          top: 80.0 + (1 - animation.value) * (330 + 14) + 50,
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
          "Base camp",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
        ),
      ),
    );
  }
}

class BaseTimeLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (_, notifier, animation, child) {
        final double opacity = math.max(4 * notifier.page - 3, 0);
        return Positioned(
          right: opacity * 21.0,
          top: 80.0 + (1 - animation.value) * (330 + 14) + 50 + 40,
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
          onPressed: () {
            Provider.of<AnimationController>(context, listen: false).forward();
          },
        ),
      ),
    );
  }
}

class VultureCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        double multiplier = math.max(4 * notifier.page - 3, 0);
        if (animation.value > 0)
          multiplier = math.max(0.0, 1 - 2 * animation.value);
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

class HorizontalTravelDots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        double multiplier = math.max(4 * notifier.page - 3, 0);
        double opacity = multiplier;
        if (animation.value > 0) {
          multiplier = math.max(0.0, 1 - 4 * animation.value);
        }
        final double margin = 30 * multiplier;
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

class VerticalTravelDots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AnimationController>(
      builder: (context, animation, child) {
        if (animation.value < 0.2) return Container();
        double top = 80.0 +
            (1 - math.max(0.0, (animation.value - 0.2) * 1.25)) * (330 + 14) +
            50;
        double offset = 7.5;
        double height = 20 -
            2 * offset +
            (math.max(0.0, (animation.value - 0.2) * 1.25)) * (330 + 14);
        return Positioned(
          top: top + offset,
          height: height,
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  height: double.infinity,
                  width: 2,
                  color: white,
                ),
                Align(
                  alignment: Alignment(0, -1),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: white,
                    ),
                    width: 6,
                    height: 6,
                  ),
                ),
                Positioned(
                  top: animation.value - 0.2 > 0.8 * 2 / 3 ? null : 0,
                  bottom: animation.value - 0.2 > 0.8 * 2 / 3
                      ? 2 / 3 * (330 + 14)
                      : null,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 2, color: white),
                      color: mainBlack,
                    ),
                    width: 6,
                    height: 6,
                  ),
                ),
                Positioned(
                  top: animation.value - 0.2 > 0.8 * 1 / 3 ? null : 0,
                  bottom: animation.value - 0.2 > 0.8 * 1 / 3
                      ? 1 / 3 * (330 + 14)
                      : null,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 2, color: white),
                      color: mainBlack,
                    ),
                    width: 6,
                    height: 6,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class VultureIconLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AnimationController>(
      builder: (context, animation, child) {
        return Positioned(
          top: 80.0 + 330 * 2 / 3 + 40 - 40 * animation.value + 40,
          right: 40 + 70 * animation.value,
          child: Opacity(
              opacity: math.max(0.0, (animation.value - 0.75) * 4),
              child: child),
        );
      },
      child: SmallAnimalIconLabel(
        image: "assets/vultures.png",
        label: "Vulure",
      ),
    );
  }
}

class LeopardIconLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AnimationController>(
      builder: (context, animation, child) {
        return Positioned(
          top: 80.0 + 330 * 1 / 3 + 20,
          left: 30 + 70 * animation.value,
          child: Opacity(
              opacity: math.max(0.0, (animation.value - 0.75) * 4),
              child: child),
        );
      },
      child: SmallAnimalIconLabel(
        image: "assets/leopards.png",
        label: "Leopard",
      ),
    );
  }
}

class SmallAnimalIconLabel extends StatelessWidget {
  final String label;
  final String image;

  const SmallAnimalIconLabel(
      {Key key, @required this.label, @required this.image})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image.asset(image, width: 36, height: 36),
        SizedBox(height: 10),
        Text(
          label,
          style: TextStyle(fontSize: 10),
        ),
      ],
    );
  }
}
