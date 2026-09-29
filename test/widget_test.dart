import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:discount_calculator/main.dart';
import 'package:discount_calculator/models/fitness_data.dart';
import 'package:discount_calculator/screens/gym_detail_screen.dart';
import 'package:discount_calculator/screens/home_screen.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(375 * 3, 812 * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const FitnessApp());
    await tester.pumpAndSettle();
  }

  testWidgets('Home afișează secțiunile din design', (tester) async {
    await pumpApp(tester);

    expect(find.text('Today’s Challenge'), findsOneWidget);
    expect(find.text('Running'), findsOneWidget);
    expect(find.text('15/20'), findsOneWidget);
    expect(find.text('Featured Plan'), findsOneWidget);
    expect(find.text('Massive Upper Body'), findsWidgets);
    expect(find.text('Workout Programs'), findsOneWidget);
    expect(find.text('All Type'), findsOneWidget);
    expect(find.text('Yoga'), findsWidgets);
    expect(find.text('Arm\nStrengthening'), findsOneWidget);
  });

  testWidgets('Chip-urile filtrează programele', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Cardio'));
    await tester.pumpAndSettle();
    expect(find.text('Arm\nStrengthening'), findsOneWidget);
    expect(find.text('210 kcl'), findsOneWidget);

    await tester.tap(find.text('All Type'));
    await tester.pumpAndSettle();
    expect(find.text('210 kcl'), findsNWidgets(2));
  });

  testWidgets('Cardul challenge crește progresul', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Running'));
    await tester.pumpAndSettle();
    expect(find.text('16/20'), findsOneWidget);
  });

  testWidgets('Start Now deschide detaliile sălii, iar Reserve rezervă',
      (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Start Now').first);
    await tester.pumpAndSettle();

    expect(find.byType(GymDetailScreen), findsOneWidget);
    expect(find.text('Mid City Gym Training'), findsOneWidget);
    expect(find.text('California, New York'), findsOneWidget);
    expect(find.text('Amenities'), findsOneWidget);
    expect(find.text('Showers'), findsOneWidget);
    expect(find.text('Lockers'), findsOneWidget);

    await tester.tap(find.text('Reserve'));
    await tester.pump();
    expect(find.text('Reserved'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Back'));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  test('Formatare dată, salut și numere', () {
    expect(formatDate(DateTime(2022, 5, 20)), 'Friday, 20 May');
    expect(greetingFor(DateTime(2022, 5, 20, 9)), 'Good Morning');
    expect(greetingFor(DateTime(2022, 5, 20, 14)), 'Good Afternoon');
    expect(greetingFor(DateTime(2022, 5, 20, 20)), 'Good Evening');
    expect(formatThousands(1232), '1,232');
    expect(formatThousands(999), '999');
    expect(
      shortDescription(midCityGym.description),
      'Lorem ipsum dolor sit amet consectetur. Blandit vitae aliquet eros '
      'laoreet quam sollicitudin. Duis non eu habitant id vel nisi eget amet '
      'tellus',
    );
  });
}
