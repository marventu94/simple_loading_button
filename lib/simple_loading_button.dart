library simple_loading_button;

import 'package:flutter/material.dart';

class SimpleLoadingButton extends StatefulWidget {
  final Function onPressed;
  final String label;
  final double fontSize;
  final Color backgroundColor;
  final Color textColor;
  final FontWeight fontWeight;
  const SimpleLoadingButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.fontSize = 14.00,
    this.fontWeight = FontWeight.bold,
  }) : super(key: key);

  @override
  State<SimpleLoadingButton> createState() => _SimpleLoadingButtonState();
}

class _SimpleLoadingButtonState extends State<SimpleLoadingButton>
    with TickerProviderStateMixin {
  late double textLength;
  late double originWithButton;
  bool animateActive = false;
  int endBothAnimation = 0;
  late final AnimationController _controllerFade = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );

  late final Animation<double> _animationFade = CurvedAnimation(
    parent: _controllerFade,
    curve: Curves.easeIn,
  );

  late final AnimationController _controllerSlide = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );

  late final Animation<Offset> _animationSlide = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0.3, 0.0),
  ).animate(CurvedAnimation(
    parent: _controllerSlide,
    curve: Curves.easeIn,
  ));

  @override
  void dispose() {
    _controllerSlide.dispose();
    _controllerFade.dispose();
    super.dispose();
  }

  @override
  void initState() {
    textLength = calcTextSize(
        widget.label,
        TextStyle(
          fontSize: widget.fontSize,
          fontWeight: widget.fontWeight,
        ));
    originWithButton = textLength + 3 * widget.fontSize.toDouble();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      onEnd: () {
        setState(() {
          if (endBothAnimation < 2) {
            endBothAnimation++;
          }
        });
      },
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      color: (animateActive)
          ? widget.backgroundColor.withAlpha(90)
          : widget.backgroundColor,
      width: (animateActive) ? originWithButton * 1.2 : originWithButton,
      height: widget.fontSize * 2.5,
      child: InkWell(
        onTap: () async {
          if (endBothAnimation == 2) {
            endBothAnimation = 0;
          }
          if (!animateActive && endBothAnimation == 0) {
            triggerAnimation();
            await widget.onPressed();
            triggerAnimation();
          }
        },
        child: Center(
          child: SizedBox(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FadeTransition(
                  opacity: _animationFade,
                  child: SizedBox(
                    height: widget.fontSize.toDouble() * 0.7,
                    width: widget.fontSize.toDouble() * 0.7,
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(widget.backgroundColor),
                    ),
                  ),
                ),
                SlideTransition(
                  position: _animationSlide,
                  child: Text(
                    widget.label,
                    style: TextStyle(
                      color: widget.textColor,
                      fontSize: widget.fontSize.toDouble(),
                      fontWeight: widget.fontWeight,
                    ),
                  ),
                ),
                SizedBox(
                  height: widget.fontSize.toDouble() * 0.7001,
                  width: widget.fontSize.toDouble() * 0.7001,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  triggerAnimation() {
    setState(() {
      if (_controllerFade.status == AnimationStatus.completed) {
        _controllerFade.reverse();
      } else {
        if (_controllerFade.status == AnimationStatus.dismissed) {
          _controllerFade.forward();
        }
      }
      if (_controllerSlide.status == AnimationStatus.completed) {
        _controllerSlide.reverse();
      } else {
        if (_controllerSlide.status == AnimationStatus.dismissed) {
          _controllerSlide.forward();
        }
      }
      animateActive = !animateActive;
    });
  }

  double calcTextSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textScaleFactor: WidgetsBinding.instance.window.textScaleFactor,
    )..layout();
    return textPainter.size.width;
  }
}
