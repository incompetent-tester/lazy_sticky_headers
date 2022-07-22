import 'dart:async';
import 'package:flutter/material.dart';

class WidgetStickyHeader<X> extends StatefulWidget {
  final Stream<X?> stream;
  final Widget Function(X) builder;

  const WidgetStickyHeader({
    Key? key,
    required this.stream,
    required this.builder,
  }) : super(key: key);

  @override
  createState() => _WidgetStickyHeaderState<X>();
}

class _WidgetStickyHeaderState<X> extends State<WidgetStickyHeader<X>> {
  X? _item;
  late StreamSubscription _sub;

  @override
  void initState() {
    super.initState();

    _sub = widget.stream.distinct().listen((evt) {
      setState(() {
        _item = evt;
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
    return _item == null ? Container() : widget.builder(_item as X);
  }
}
