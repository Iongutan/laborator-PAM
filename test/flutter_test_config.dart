import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Încarcă fontul real (Plus Jakarta Sans) în teste, ca layout-ul
/// să fie măsurat la fel ca pe telefon.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final FontLoader loader = FontLoader('PlusJakartaSans');
  for (final String weight in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
    loader.addFont(
      rootBundle.load('assets/fonts/PlusJakartaSans-$weight.ttf'),
    );
  }
  await loader.load();
  await testMain();
}
