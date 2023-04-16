import 'package:flutter/material.dart';

class CustomExpanded extends StatefulWidget {
  const CustomExpanded({
    Key? key,
    required this.controller,
    this.children = const <Widget>[],
    this.titleChild,
    this.headercolor = Colors.white,
    this.headerPadding = const EdgeInsets.all(8.0),
    this.headerMargin = const EdgeInsets.symmetric(
      horizontal: 8.0,
    ),
    this.childrenMargin = EdgeInsets.zero,
    this.iconColor,
    this.headerShape,
  }) : super(key: key);
  final AnimationController controller;
  final List<Widget> children;
  final Widget? titleChild;
  final Color headercolor;
  final EdgeInsetsGeometry headerPadding;
  final EdgeInsetsGeometry headerMargin;
  final EdgeInsetsGeometry childrenMargin;
  final ShapeBorder? headerShape;
  final Color? iconColor;
  @override
  State<CustomExpanded> createState() => _CustomExpandedState();
}

class _CustomExpandedState extends State<CustomExpanded> {
  void _scrollToSelectedContent({required GlobalKey expansionTileKey}) {
    final keyContext = expansionTileKey.currentContext;
    if (keyContext != null) {
      Future.delayed(const Duration(milliseconds: 200)).then((value) {
        Scrollable.ensureVisible(keyContext,
            duration: const Duration(milliseconds: 200));
      });
    }
  }

  final GlobalKey expansionTileKey = GlobalKey();
  bool get isExpanded => widget.controller.status == AnimationStatus.completed;
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      key: expansionTileKey,
      animation: widget.controller,
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Padding(
                padding: widget.headerMargin,
                child: MaterialButton(
                  animationDuration: widget.controller.duration,
                  color: widget.headercolor,
                  padding: widget.headerPadding,
                  shape: widget.headerShape,
                  onPressed: () {
                    if (isExpanded) {
                      widget.controller.reverse();
                    } else {
                      widget.controller.forward();
                    }
                    _scrollToSelectedContent(
                        expansionTileKey: expansionTileKey);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: widget.titleChild ?? Container(),
                      ),
                      SizedBox(width: widget.headerPadding.horizontal),
                      Flexible(
                        child: Icon(
                            isExpanded ? Icons.expand_less : Icons.expand_more,
                            color: widget.iconColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            widget.children.isNotEmpty
                ? SizeTransition(
                    sizeFactor: widget.controller,
                    child: Padding(
                      padding: widget.childrenMargin,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: widget.children,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        );
      },
    );
  }
}
