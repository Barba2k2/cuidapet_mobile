// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';

class Debauncer {
  final int milliseconds;
  Timer? _timer;

  Debauncer({
    required this.milliseconds,
  });

  void run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }

    _timer = Timer(
      Duration(microseconds: milliseconds),
      action,
    );
  }
}
