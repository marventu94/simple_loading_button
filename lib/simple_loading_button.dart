library simple_loading_button;

import 'package:flutter/material.dart';

class SimpleLoadingButton extends StatefulWidget {
  final Function onPressed;
  final String label;
  final double fontSize;
  final Color? backgroundColor;
  final Color? textColor;

  const SimpleLoadingButton({
    Key? key,
    required this.onPressed,
    required this.label,
    this.fontSize = 16,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => SimpleLoadingButtonState();
}

class SimpleLoadingButtonState extends State<SimpleLoadingButton>
    with TickerProviderStateMixin {
  Future _future = Future.value();

  Future<void> triggerEvent() async {
    await widget.onPressed();
    return;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget btnIdle = TextButton(
      key: const ValueKey(0),
      onPressed: () {
        setState(() {
          _future = triggerEvent();
        });
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.all(widget.fontSize / 2),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2.0)),
        ),
        backgroundColor: widget.backgroundColor ?? theme.primaryColor,
      ),
      child: Text(
        widget.label,
        style: TextStyle(
          color: widget.textColor ?? Colors.white,
          fontSize: widget.fontSize,
        ),
      ),
    );

    Widget btnLoading = TextButton(
      key: const ValueKey(1),
      style: TextButton.styleFrom(
          padding: EdgeInsets.all(widget.fontSize / 2),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(2.0)),
          ),
          backgroundColor: (widget.backgroundColor != null)
              ? widget.backgroundColor!.withAlpha(90)
              : theme.primaryColor.withAlpha(90)),
      onPressed: null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 4),
          SizedBox(
            height: widget.fontSize * 0.7,
            width: widget.fontSize * 0.7,
            child: const CircularProgressIndicator(),
          ),
          const SizedBox(width: 12),
          Text(
            widget.label,
            style: TextStyle(
              color: widget.textColor ?? Colors.white,
              fontSize: widget.fontSize,
            ),
          ),
        ],
      ),
    );

    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        late Widget child;
        if (snapshot.connectionState == ConnectionState.waiting) {
          child = btnLoading;
        } else {
          child = btnIdle;
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          // ignore: todo
          //TODO: add fade and animatied size, both transition
          // transitionBuilder: (Widget child, Animation<double> animation) =>
          //     SizeTransition(
          //   axis: Axis.horizontal,
          //   sizeFactor: animation,
          //   child: child,
          // ),
          child: child,
        );
      },
    );
  }
}
