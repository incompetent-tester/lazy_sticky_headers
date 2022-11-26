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
  List<String>? header;
  List<List<String>>? content;

  @override
  void initState() {
    super.initState();
    checkPlatformState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(
        const Duration(seconds: 2),
        () {
          header = List.generate(5, (header) => header.toString());
          content = List.generate(
            5,
            (header) => List.generate(
              20,
              (content) {
                return "$header --- Lorem ipsum dolor sit amet, consectetur adipiscing elit, "
                    "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Amet venenatis ";
              },
            ),
          );

          setState(() {});
        },
      );
    });
  }

  Future<void> checkPlatformState() async {
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

          // Loader
          loader: const Center(child: CircularProgressIndicator()),

          // Header
          header: header,

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
          content: content,

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
