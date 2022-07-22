import 'dart:async';
import 'package:flutter/material.dart';

class WidgetHeader<X> extends StatefulWidget {
  final Stream<X?> stream;
  final X item;
  final Widget Function(X) builder;

  const WidgetHeader({
    Key? key,
    required this.item,
    required this.stream,
    required this.builder,
  }) : super(key: key);

  @override
  createState() => _WidgetHeaderState<X>();
}

class _WidgetHeaderState<X> extends State<WidgetHeader<X>> {
  X? _stickyItem;
  late StreamSubscription _sub;

  @override
  void initState() {
    super.initState();

    _sub = widget.stream.distinct().listen((evt) {
      setState(() {
        _stickyItem = evt;
      });
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _stickyItem == widget.item ? 0.0 : 1.0,
      child: widget.builder(widget.item),
    );
  }
}
