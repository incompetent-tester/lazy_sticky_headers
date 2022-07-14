import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:lazy_sticky_headers/lazy_sticky_headers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _itemScrollController = StickyItemScrollController();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (Platform.isLinux || Platform.isMacOS || Platform.isWindows || Platform.isFuchsia) {
      throw Exception("Unsupported platforms");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Randomly jump to different item index.
            // Ensure index is not more than the number of headers and contents.
            var index = Random.secure().nextInt(105);
            debugPrint('Scrolling to $index');

            _itemScrollController.scrollTo(
              index: index,
              duration: const Duration(milliseconds: 500),
            );
          },
          child: const Icon(Icons.run_circle_outlined),
        ),
        appBar: AppBar(
          title: const Text('Lazy Sticky Headers'),
        ),
        body: LazyStickyHeaders<String, String>(
          scrollPhysics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          scrollController: _itemScrollController,

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
              20,
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
      ),
    );
  }
}
