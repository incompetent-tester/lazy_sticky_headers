import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class Tuple<X, Y> {
  final X first;
  final Y second;

  Tuple({required this.first, required this.second});
}

typedef StickyItemScrollController = ItemScrollController;

/* -------------------------------------------------------------------------- */
/*                              Sticky Item Types                             */
/* -------------------------------------------------------------------------- */
enum StickyType {
  header,
  content,
}

/* -------------------------------------------------------------------------- */
/*                                 StickItems                                 */
/* -------------------------------------------------------------------------- */
abstract class StickyItem<X> {
  X content;

  StickyType get type;
  StickyItem({required this.content});
}

class StickyHeader<X> extends StickyItem<X> {
  StickyHeader? nextHeader;
  StickyHeader? previousHeader;

  @override
  StickyType get type => StickyType.header;

  StickyHeader({
    required X item,
    this.nextHeader,
    this.previousHeader,
  }) : super(content: item);
}

class StickyContent<X> extends StickyItem<X> {
  @override
  StickyType get type => StickyType.content;

  StickyContent({required X item}) : super(content: item);
}
