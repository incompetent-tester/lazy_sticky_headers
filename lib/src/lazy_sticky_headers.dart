library lazy_sticky_headers;

import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lazy_sticky_headers/src/data.dart';
import 'package:lazy_sticky_headers/src/widget_header.dart';
import 'package:lazy_sticky_headers/src/widget_sticky_header.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:visibility_detector/visibility_detector.dart';

/* -------------------------------------------------------------------------- */
/*                                   Widget                                   */
/* -------------------------------------------------------------------------- */
class LazyStickyHeaders<X, Y> extends StatefulWidget {
  final List<X> header;
  final List<List<Y>> content;
  final Widget Function(X) builderHeader;
  final Widget Function(Y) builderContent;

  final Widget Function()? builderLoader;
  final StickyItemScrollController? scrollController;

  final ScrollPhysics? scrollPhysics;
  final EdgeInsets? padding;
  final bool reverse;
  final bool shrinkWrap;

  LazyStickyHeaders({
    Key? key,
    required this.header,
    required this.content,
    required this.builderHeader,
    required this.builderContent,
    this.builderLoader,

    // Related to ScrollList
    this.scrollController,
    this.scrollPhysics,
    this.padding,
    this.reverse = false,
    this.shrinkWrap = false,
  }) : super(key: key) {
    assert(header.length == content.length,
        "header.length should be equal to content.length");
  }

  @override
  createState() => _LazyStickyHeadersState<X, Y>();
}

class _LazyStickyHeadersState<X, Y> extends State<LazyStickyHeaders<X, Y>> {
  final _headerStreamCtrl = StreamController<X?>.broadcast();

  final _itemPositionsListener = ItemPositionsListener.create();
  final _sortedIdxSet = SplayTreeSet<int>((a, b) => a.compareTo(b));

  late List<StickyItem> _stickyItems;

  late final StickyItemScrollController _itemScrollCtrl =
      widget.scrollController == null
          ? StickyItemScrollController() //
          : widget.scrollController!;

  late final Future<void> _mappingFuture = _mapHeaderContent();

  bool _overscrollTop = false;
  StickyHeader? _curStickyHeader;

  @override
  void initState() {
    super.initState();
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  }

  @override
  void dispose() {
    _headerStreamCtrl.close();
    super.dispose();
  }

  void _stickyHeaderTransition() {
    if (_overscrollTop) {
      return;
    }

    for (var it = 0; it < _sortedIdxSet.length; it++) {
      var item = _stickyItems[_sortedIdxSet.elementAt(it)];

      if (item.type == StickyType.header) {
        if (it == 0) {
          _curStickyHeader = item as StickyHeader;
        } else {
          _curStickyHeader = (item as StickyHeader).previousHeader;
        }

        if (!_headerStreamCtrl.isClosed) {
          _headerStreamCtrl.add(_curStickyHeader?.content);
        }
        break;
      }
    }
  }

  Future<void> _mapHeaderContent() async {
    _stickyItems = await _computeMapping(widget.header, widget.content);
  }

  /* ---------------------------- Render Functions ---------------------------- */
  Widget _buildLoader() {
    return widget.builderLoader == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : widget.builderLoader!.call();
  }

  Widget _buildList() {
    return Stack(
      children: [
        NotificationListener<ScrollUpdateNotification>(
          onNotification: (n) {
            _overscrollTop = n.metrics.outOfRange && n.metrics.pixels < 0;

            if (_overscrollTop && _curStickyHeader != null) {
              _curStickyHeader = null;
              _headerStreamCtrl.add(null);
            }
            return false;
          },
          child: ScrollablePositionedList.builder(
            //
            physics: widget.scrollPhysics,
            padding: widget.padding,
            reverse: widget.reverse,
            shrinkWrap: widget.shrinkWrap,

            //
            itemCount: _stickyItems.length,
            itemScrollController: _itemScrollCtrl,
            itemPositionsListener: _itemPositionsListener,
            itemBuilder: (context, index) {
              var item = _stickyItems[index];

              switch (item.type) {
                case StickyType.content:
                  return VisibilityDetector(
                      key: ValueKey('content_$index'),
                      child: widget.builderContent(item.content),
                      onVisibilityChanged: (info) {
                        if (info.visibleFraction > 0.05 &&
                            !_sortedIdxSet.contains(index)) {
                          _sortedIdxSet.add(index);
                        } else if (info.visibleFraction <= 0.05 &&
                            _sortedIdxSet.contains(index)) {
                          _sortedIdxSet.remove(index);
                        }

                        _stickyHeaderTransition();
                      });

                case StickyType.header:
                  return VisibilityDetector(
                    key: ValueKey('header_$index'),
                    child: WidgetHeader<X>(
                      builder: widget.builderHeader,
                      item: item.content,
                      stream: _headerStreamCtrl.stream,
                    ),
                    onVisibilityChanged: (info) {
                      if (info.visibleFraction > 0.05 &&
                          !_sortedIdxSet.contains(index)) {
                        _sortedIdxSet.add(index);
                        _stickyHeaderTransition();
                      } else if (info.visibleFraction <= 0.05 &&
                          _sortedIdxSet.contains(index)) {
                        _sortedIdxSet.remove(index);
                        _stickyHeaderTransition();
                      }
                    },
                  );
              }
            },
          ),
        ),

        //
        WidgetStickyHeader<X>(
          stream: _headerStreamCtrl.stream,
          builder: widget.builderHeader,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _mappingFuture,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return _buildList();
        } else {
          return _buildLoader();
        }
      },
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                              Compute / Isolate                             */
/* -------------------------------------------------------------------------- */
Future<List<StickyItem>> _computeMapping(List header, List content) async {
  var param = {
    'header': header,
    'content': content,
  };

  return await compute(_headerContentMapping, param);
}

List<StickyItem> _headerContentMapping(Map<String, dynamic> params) {
  List header = params['header'];
  List content = params['content'];

  final stickyItems = <StickyItem>[];

  int i = 0;
  StickyHeader? previousHeader;

  while (i < header.length) {
    var h = StickyHeader(
      item: header[i],
      previousHeader: previousHeader,
    );
    stickyItems.add(h);

    previousHeader?.nextHeader = h;

    for (var iC = 0; iC < content[i].length; iC++) {
      var c = StickyContent(item: content[i][iC]);
      stickyItems.add(c);
    }

    previousHeader = h;
    i += 1;
  }

  return stickyItems;
}
