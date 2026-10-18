import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

/// Ekran görüntüsü (golden) testleri için ayar: Flutter sürümleri arasındaki
/// küçük kenar yumuşatma farkları testleri düşürmesin diye %1,5'e kadar piksel
/// farkı kabul edilir. Gerçek tasarım değişiklikleri bundan çok daha büyük
/// fark üretir.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  final current = goldenFileComparator;
  if (current is LocalFileComparator) {
    goldenFileComparator = TolerantGoldenComparator(
      current.basedir.resolve('golden_test.dart'),
    );
  }
  await testMain();
}

class TolerantGoldenComparator extends LocalFileComparator {
  TolerantGoldenComparator(super.testFile, {this.tolerance = 0.015});

  /// Kabul edilen fark oranı (0–1).
  final double tolerance;

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );
    if (result.passed || result.diffPercent <= tolerance) {
      result.dispose();
      return true;
    }
    final error = await generateFailureOutput(result, golden, basedir);
    result.dispose();
    throw TestFailure(error);
  }
}
