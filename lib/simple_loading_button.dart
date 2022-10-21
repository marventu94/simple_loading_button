library simple_loading_button;

import 'package:flutter/material.dart';

class SimpleLoadingButton extends StatefulWidget {
  final Function onPressed;
  final String label;
  final int fontSize;
  const SimpleLoadingButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.fontSize = 20,
  }) : super(key: key);

  @override
  State<SimpleLoadingButton> createState() => _SimpleLoadingButtonState();
}

class _SimpleLoadingButtonState extends State<SimpleLoadingButton>
    with TickerProviderStateMixin {
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
    end: const Offset(0.4, 0.0),
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
      color: (animateActive) ? Colors.blue.withAlpha(90) : Colors.blue,
      width: (animateActive)
          ? widget.fontSize * 6
          : (widget.fontSize * 6 - widget.fontSize.toDouble() * 0.7),
      height: widget.fontSize * 2.2,
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
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(left: widget.fontSize.toDouble() * 0.8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FadeTransition(
                    opacity: _animationFade,
                    child: SizedBox(
                      height: widget.fontSize.toDouble() * 0.7,
                      width: widget.fontSize.toDouble() * 0.7,
                      child: const CircularProgressIndicator(),
                    ),
                  ),
                  SlideTransition(
                    position: _animationSlide,
                    child: Text(
                      widget.label,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: widget.fontSize.toDouble(),
                      ),
                    ),
                  ),
                ],
              ),
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
}
