import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sy_travel_animation/style.dart';

import 'main_page.dart';
import 'dart:math' as math;

class LeopardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 80),
        The72Text(),
        SizedBox(height: 10),
        TravelDescriptionLabel(),
        SizedBox(height: 20),
        LeopardDescription(),
      ],
    );
  }
}

class LeopardImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animtaion, child) {
        return Positioned(
          left: -notifier.offset * 0.89,
          width: MediaQuery.of(context).size.width * 1.6,
          child: Opacity(
            opacity: 1 - 0.3 * animtaion.value,
            child: Transform.scale(
              alignment: Alignment(0.7,0),
              scale: 1-0.1*animtaion.value,
              child: child,
            ),
          ),
        );
      },
      child: IgnorePointer(child: Image.asset("assets/leopard.png")),
    );
  }
}

class The72Text extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Consumer<PageOffsetNotifier>(
        builder: (_, notifier, child) => Transform.translate(
          offset: Offset(-35 - notifier.offset, 0),
          child: child,
        ),
        child: RotatedBox(
          quarterTurns: 1,
          child: SizedBox(
            width: 330,
            child: FittedBox(
              fit: BoxFit.fill,
              child: Text(
                "72",
                style: TextStyle(
                  fontSize: 330,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LeopardDescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (_, notifier, child) => Opacity(
        opacity: math.max(1 - notifier.offset * 0.015, 0),
        child: child,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Text(
            "The leopard is distinguished by its well-camouflaged fur, opportunistic hunting behaviour, broad diet, and strength.",
            style: TextStyle(fontSize: 13, color: lightGrey)),
      ),
    );
  }
}

class TravelDescriptionLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (_, notifier, child) => Opacity(
        opacity: math.max(1 - notifier.offset * 0.015, 0),
        child: child,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Text(
          "Travel Description",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
