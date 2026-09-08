import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const DiscountCalculatorApp());
}

class DiscountCalculatorApp extends StatelessWidget {
  const DiscountCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color accent = Color(0xFF2E7D32); // verde accent

    return MaterialApp(
      title: 'Calculator de reducere',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorSchemeSeed: accent,
        scaffoldBackgroundColor: const Color(0xFFFAFAFA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          centerTitle: true,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: accent, width: 1.6),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: accent,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black54,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

/// Opțiuni de rotunjire pentru rezultatul final.
enum RoundingOption { none, twoDecimals }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _pretController = TextEditingController();
  final TextEditingController _reducereController = TextEditingController();

  RoundingOption _rounding = RoundingOption.twoDecimals;

  bool _afiseazaRezultat = false;
  double _valoareReducere = 0;
  double _pretFinal = 0;

  @override
  void dispose() {
    _pretController.dispose();
    _reducereController.dispose();
    super.dispose();
  }

  /// Validează inputul utilizatorului. Returnează un mesaj de eroare
  /// (string) dacă ceva e invalid, sau null dacă totul e valid.
  String? _valideazaInput(double? pret, double? reducere) {
    if (_pretController.text.trim().isEmpty ||
        _reducereController.text.trim().isEmpty) {
      return 'Completează ambele câmpuri.';
    }
    if (pret == null || reducere == null) {
      return 'Introdu valori numerice valide.';
    }
    if (pret < 0) {
      return 'Prețul inițial nu poate fi negativ.';
    }
    if (reducere < 0 || reducere > 100) {
      return 'Procentul reducerii trebuie să fie între 0 și 100.';
    }
    return null;
  }

  void _calculeaza() {
    FocusScope.of(context).unfocus(); // ascunde tastatura

    final double? pret = double.tryParse(
      _pretController.text.trim().replaceAll(',', '.'),
    );
    final double? reducere = double.tryParse(
      _reducereController.text.trim().replaceAll(',', '.'),
    );

    final String? eroare = _valideazaInput(pret, reducere);
    if (eroare != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(eroare),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.shade400,
        ),
      );
      return;
    }

    double valoareReducere = pret! * (reducere! / 100);
    double pretFinal = pret - valoareReducere;

    if (_rounding == RoundingOption.twoDecimals) {
      valoareReducere = double.parse(valoareReducere.toStringAsFixed(2));
      pretFinal = double.parse(pretFinal.toStringAsFixed(2));
    }

    setState(() {
      _valoareReducere = valoareReducere;
      _pretFinal = pretFinal;
      _afiseazaRezultat = true;
    });
  }

  void _reseteaza() {
    FocusScope.of(context).unfocus();
    setState(() {
      _pretController.clear();
      _reducereController.clear();
      _afiseazaRezultat = false;
      _valoareReducere = 0;
      _pretFinal = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator de reducere'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              // ---- Preț inițial ----
              TextField(
                controller: _pretController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*[.,]?\d*')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Preț inițial',
                  hintText: 'ex: 250',
                  prefixIcon: Icon(Icons.attach_money),
                  suffixText: 'lei',
                ),
              ),
              const SizedBox(height: 16),

              // ---- Procent reducere ----
              TextField(
                controller: _reducereController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*[.,]?\d*')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Procent reducere',
                  hintText: 'ex: 20',
                  prefixIcon: Icon(Icons.percent),
                  suffixText: '%',
                ),
              ),
              const SizedBox(height: 16),

              // ---- Rotunjire (RadioButton) ----
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: Column(
                  children: [
                    RadioListTile<RoundingOption>(
                      title: const Text('Rotunjire la 2 zecimale'),
                      value: RoundingOption.twoDecimals,
                      groupValue: _rounding,
                      onChanged: (v) => setState(() => _rounding = v!),
                    ),
                    RadioListTile<RoundingOption>(
                      title: const Text('Fără rotunjire'),
                      value: RoundingOption.none,
                      groupValue: _rounding,
                      onChanged: (v) => setState(() => _rounding = v!),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ---- Butoane ----
              ElevatedButton(
                onPressed: _calculeaza,
                child: const Text('Calculează'),
              ),
              const SizedBox(height: 4),
              TextButton(
                onPressed: _reseteaza,
                child: const Text('Resetează'),
              ),

              const SizedBox(height: 24),

              // ---- Rezultat ----
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _afiseazaRezultat
                    ? Container(
                        key: const ValueKey('rezultat'),
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E7D32).withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Reducere: ${_valoareReducere.toStringAsFixed(2)} lei',
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Preț final: ${_pretFinal.toStringAsFixed(2)} lei',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(key: ValueKey('gol')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
