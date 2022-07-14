# lazy_sticky_headers

A flutter implementation of a sticky header list widget with lazy loading support. Significant performance improvement compared to other non-lazy implementations.

[![Pub](https://img.shields.io/pub/v/lazy_sticky_headers.svg)](https://pub.dartlang.org/packages/lazy_sticky_headers)
[!["Buy Me A Coffee"](https://img.shields.io/badge/-buy_me_a%C2%A0coffee-gray?logo=buy-me-a-coffee)](https://www.buymeacoffee.com/incompetent)


![Screenshot](https://raw.githubusercontent.com/incompetent-tester/lazy_sticky_headers/master/doc/sample.gif)

## Features

* Headers and contents are all lazy-loaded.
* Supports programmatically scrolling to a specific item in the list.

## Getting Started

In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  ...
  lazy_sticky_headers:
```

In your library add the following import:

```dart
...
import 'package:lazy_sticky_headers/lazy_sticky_headers.dart';
```

## Usage Example

### Defining a LazyStickyHeaders widget
```dart
LazyStickyHeaders<String, String>(
    scrollPhysics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
    // Header
    header: List.generate(5, (header) => header.toString()),

    // Builder header
    builderHeader: (header) {
        return Row(
            children: [
            Container(
                padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
                margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.grey,
                ),
                child: SizedBox(child: Text('Header $header')),
            )
            ],
        );
    },

    // Content
    content: List.generate(
        5,
        (header) => List.generate(
            10,
            (content) {
            return "$header --- Lorem ipsum dolor sit amet, consectetur adipiscing elit, "
                "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Amet venenatis ";
            },
        ),
    ),

    // Builder content
    builderContent: (content) {
        return Container(
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            decoration: BoxDecoration(
            border: Border.all(
                color: Colors.blue,
            ),
            ),
            child: Text(content),
        );
    },
),
```

### Defining a Header item and builder
The example below shows the generation of the header item and the widget builder for each header.

```dart
// Header
header: List.generate(5, (header) => header.toString()),

// Builder header
builderHeader: (header) {
    return Row(
        children: [
        Container(
            padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
            margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.grey,
            ),
            child: SizedBox(child: Text('Header $header')),
        )
        ],
    );
},
```

### Defining a Content item and builder
The example below shows the generation of the content item and the widget builder for each content. Each *header* will have a corresponding *list of content* associated with it. Ensure that the number of *header* matches with the number of *list of content*.

```dart
// Content
content: List.generate(
    5,
    (header) => List.generate(
        10,
        (content) {
        return "$header --- Lorem ipsum dolor sit amet, consectetur adipiscing elit, "
            "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Amet venenatis ";
        },
    ),
),

// Builder content
builderContent: (content) {
    return Container(
        padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
        margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
        decoration: BoxDecoration(
        border: Border.all(
            color: Colors.blue,
        ),
        ),
        child: Text(content),
    );
},
```

### Scrolling to list item
The example below shows the index-based scrolling feature. 

```dart
...
final _itemScrollController = StickyItemScrollController();

void onClicked(int index){
    _itemScrollController.scrollTo(
        index: index,
        duration: const Duration(milliseconds: 500),
    );
}

@override
Widget build(BuildContext context) {
return LazyStickyHeaders<String, String>(
    ...
    scrollController: _itemScrollController,
    
    ...
);

```

## Like my work?
Support me with


![Monero](https://img.shields.io/badge/monero-FF6600?style=for-the-badge&logo=monero&logoColor=white) 41fezqfD3syGsUQNnR8t4hQghCJG61YWmHkYHMmYcNFoMgAg3VPhpXi7J94zdqqW7uBMrTTJS1FwNEZhCsoGMa2T3vQq82A

or 

[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/incompetent)
