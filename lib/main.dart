import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/legal/licenses.dart';

void main() {
  registerAppLicenses();
  runApp(const ProviderScope(child: EnglishWordApp()));
}
