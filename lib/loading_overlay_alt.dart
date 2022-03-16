import 'dart:ui';

import 'package:flutter/material.dart';

class LoadingOverlayAlt extends StatelessWidget {
  LoadingOverlayAlt({
    Key? key,
    required this.child,
    this.delay = const Duration(milliseconds: 500),
  })  : _isLoadingNotifier = ValueNotifier(false),
        super(key: key);

  final ValueNotifier<bool> _isLoadingNotifier;

  final Widget child;
  final Duration delay;

  static LoadingOverlayAlt of(BuildContext context) {
    return context.findAncestorWidgetOfExactType<LoadingOverlayAlt>()!;
  }

  void show() {
    _isLoadingNotifier.value = true;
  }

  void hide() {
    _isLoadingNotifier.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isLoadingNotifier,
      child: child,
      builder: (context, value, child) {
        return Stack(
          children: [
            child!,
            if (value)
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                child: const Opacity(
                  opacity: 0.8,
                  child: ModalBarrier(dismissible: false, color: Colors.black),
                ),
              ),
            if (value)
              Center(
                child: FutureBuilder(
                  future: Future.delayed(delay),
                  builder: (context, snapshot) {
                    return snapshot.connectionState == ConnectionState.done
                        ? const CircularProgressIndicator()
                        : const SizedBox();
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
