import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/gym_models.dart';
import '../models/home_models.dart';

/// Eroare la încărcarea / citirea datelor din JSON.
class FitnessDataException implements Exception {
  const FitnessDataException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Sursa de date a aplicației: fișierul `assets/data/lab_v3.json`,
/// citit asincron din pachetul aplicației.
class FitnessRepository {
  FitnessRepository({
    AssetBundle? bundle,
    this.assetPath = defaultAssetPath,
    this.latency = const Duration(milliseconds: 800),
  }) : _bundle = bundle ?? rootBundle;

  static const String defaultAssetPath = 'assets/data/lab_v3.json';

  final AssetBundle _bundle;
  final String assetPath;

  /// Întârziere artificială, ca să se vadă starea „Loading”.
  final Duration latency;

  Future<Map<String, dynamic>>? _cache;

  Future<Map<String, dynamic>> _loadJson() {
    return _cache ??= () async {
      try {
        if (latency > Duration.zero) await Future<void>.delayed(latency);
        final String raw = await _bundle.loadString(assetPath, cache: false);
        final Object? decoded = jsonDecode(raw);
        if (decoded is! Map<String, dynamic>) {
          throw const FitnessDataException('Fișierul JSON are un format greșit.');
        }
        return decoded;
      } on FitnessDataException {
        rethrow;
      } on FormatException catch (e) {
        throw FitnessDataException('JSON invalid: ${e.message}');
      } catch (e) {
        throw FitnessDataException('Nu am putut încărca datele ($e).');
      }
    }()
      // La eroare golim cache-ul, ca „Retry” să încerce din nou.
      ..catchError((Object _) {
        _cache = null;
        return <String, dynamic>{};
      });
  }

  Future<FitnessHome> loadHome() async {
    final Map<String, dynamic> json = await _loadJson();
    try {
      return FitnessHome.fromJson(
          json['fitnessHomePage'] as Map<String, dynamic>);
    } catch (e) {
      throw FitnessDataException('Date invalide pentru pagina Home ($e).');
    }
  }

  Future<GymDetails> loadGymDetails() async {
    final Map<String, dynamic> json = await _loadJson();
    try {
      return GymDetails.fromJson(
          json['fitnessGymDetailsPage'] as Map<String, dynamic>);
    } catch (e) {
      throw FitnessDataException('Date invalide pentru detaliile sălii ($e).');
    }
  }
}
