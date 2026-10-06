import 'package:discount_calculator/app.dart';
import 'package:discount_calculator/data/repositories/fitness_repository.dart';
import 'package:discount_calculator/presentation/screens/gym_details_screen.dart';
import 'package:discount_calculator/presentation/screens/home_screen.dart';
import 'package:discount_calculator/presentation/screens/programs_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/fakes.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester, FitnessRepository repo) async {
    tester.view.physicalSize = const Size(375 * 3, 812 * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(FitnessApp(repository: repo));
  }

  testWidgets('Home: Loading, apoi datele din JSON', (tester) async {
    // Repository-ul real, care citește assets/data/lab_v3.json.
    await pumpApp(
        tester, FitnessRepository(latency: const Duration(milliseconds: 300)));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Loading your workouts...'), findsOneWidget);

    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 500)));
    await tester.pumpAndSettle();

    expect(find.text('Friday, 20 May'), findsOneWidget);
    expect(find.text('Good Morning'), findsOneWidget);
    expect(find.text('Running'), findsOneWidget);
    expect(find.text('15/20'), findsOneWidget);
    expect(find.text('Massive Upper Body'), findsOneWidget);
    expect(find.text('Workout Programs'), findsOneWidget);
    expect(find.text('Arm Strengthening'), findsOneWidget);
  });

  testWidgets('Home: Error + Try again', (tester) async {
    final FakeFitnessRepository repo = FakeFitnessRepository(fail: true);
    await pumpApp(tester, repo);
    await tester.pumpAndSettle();

    expect(find.text('Something went wrong'), findsOneWidget);
    expect(find.text('Network is down'), findsOneWidget);

    repo.fail = false;
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.text('Good Morning'), findsOneWidget);
    expect(repo.homeCalls, 2);
  });

  testWidgets('Home: Empty', (tester) async {
    await pumpApp(tester, FakeFitnessRepository(empty: true));
    await tester.pumpAndSettle();
    expect(find.text('No workouts yet'), findsOneWidget);
  });

  testWidgets('Home: chip-urile filtrează, iar Boxing e gol', (tester) async {
    await pumpApp(tester, FakeFitnessRepository());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cardio'));
    await tester.pumpAndSettle();
    expect(find.text('Cardio Training'), findsOneWidget);
    expect(find.text('Yoga'), findsOneWidget); // doar chip-ul

    await tester.tap(find.text('Boxing'));
    await tester.pumpAndSettle();
    expect(find.text('No programs found'), findsOneWidget);
  });

  testWidgets('See All: căutare, favorite, filtru gol', (tester) async {
    await pumpApp(tester, FakeFitnessRepository());
    await tester.pumpAndSettle();

    await tester.tap(find.text('See All').last);
    await tester.pumpAndSettle();
    expect(find.byType(ProgramsScreen), findsOneWidget);
    expect(find.text('3 results'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'yo');
    await tester.pumpAndSettle();
    expect(find.text('1 result'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.favorite_border).last);
    await tester.pumpAndSettle();
    expect(find.text('Yoga added to favorites'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '');
    await tester.tap(find.byKey(const Key('favorites-only')));
    await tester.pumpAndSettle();
    expect(find.text('1 result'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pumpAndSettle();
    expect(find.text('No programs found'), findsOneWidget);
    await tester.tap(find.text('Clear filters'));
    await tester.pumpAndSettle();
    expect(find.text('3 results'), findsOneWidget);
  });

  testWidgets('See All: sortare A–Z', (tester) async {
    await pumpApp(tester, FakeFitnessRepository());
    await tester.pumpAndSettle();
    await tester.tap(find.text('See All').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sort'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Name (A–Z)'));
    await tester.pumpAndSettle();

    final double arm = tester.getTopLeft(find.text('Arm Strengthening')).dy;
    final double yoga = tester
        .getTopLeft(find.descendant(
            of: find.byType(GridView), matching: find.text('Yoga')))
        .dy;
    expect(arm, lessThan(yoga));
  });

  testWidgets('Start Now → detalii sală → Reserve → înapoi', (tester) async {
    await pumpApp(tester, FakeFitnessRepository());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Start Now').first);
    await tester.pumpAndSettle();

    expect(find.byType(GymDetailsScreen), findsOneWidget);
    expect(find.text('Mid City Gym Training'), findsOneWidget);
    expect(find.text('California, New York'), findsOneWidget);
    expect(find.text('Showers'), findsOneWidget);
    expect(find.text('Lockers'), findsOneWidget);
    expect(find.text('Free Wi-fi'), findsNothing);

    await tester.tap(find.text('Reserve'));
    await tester.pumpAndSettle();
    expect(find.text('Reserved'), findsOneWidget);
    expect(find.text('Reserved Mid City Gym Training!'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Back'));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  test('formatThousands', () {
    expect(formatThousands(1232), '1,232');
    expect(formatThousands(999), '999');
    expect(formatThousands(1234567), '1,234,567');
  });
}
