import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_course/helpers/loading/loading_screen_controller.dart';
import 'package:flutter_course/widgets/loading_indicator.dart';

class LoadingScreen {
  factory LoadingScreen() => _shared;
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  LoadingScreen._sharedInstance();

  LoadingScreenController? controller;

  void show({
    required BuildContext context,
    required String text,
  }) {
    if (controller?.update(text) ?? false) {
      return;
    } else {
      controller = showOverlay(
        context: context,
        text: text,
      );
    }
  }

  void hide() {
    controller?.close();
    controller = null;
  }

  LoadingScreenController showOverlay({
    required BuildContext context,
    required String text,
  }) {
    final _text = StreamController<String>();
    _text.add(text);

    /// Getting the overlay of the context.
    final state = Overlay.of(context);

    /// Getting the size of the screen.
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(builder: (context) {
      return Material(
        color: Colors.black.withAlpha(150),
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: size.width * 0.8,
              maxHeight: size.height * 0.8,
              minWidth: size.width * 0.5,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.transparent,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  customLoadingIndicator(),
                  const SizedBox(
                    height: 20,
                  ),
                  StreamBuilder(
                    stream: _text.stream,
                    builder: (ctx, snapshot) => snapshot.hasData
                        ? Text(
                            snapshot.data as String,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                          )
                        : Container(),
                  )
                ],
              )),
            ),
          ),
        ),
      );
    });

    state.insert(overlay);

    return LoadingScreenController(close: () {
      _text.close();
      overlay.remove();
      return true;
    }, update: (text) {
      _text.add(text);
      return true;
    });
  }
}
